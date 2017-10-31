using SemidefiniteOptInterface
SOI = SemidefiniteOptInterface

using MathOptInterface
MOI = MathOptInterface

export DSDPSolver

struct DSDPSolver <: SOI.AbstractSDSolver
    options::Dict{Symbol,Any}
end
DSDPSolver(;kwargs...) = DSDPSolver(Dict{Symbol,Any}(kwargs))

mutable struct DSDPSolverInstance <: SOI.AbstractSDSolverInstance
    dsdp::DSDPT
    lpcone::LPCone.LPConeT
    nconstrs::Int
    blkdims::Vector{Int}
    blk::Vector{Int}
    sdpcone::SDPCone.SDPConeT
    nlpdrows::Int
    lpdvars::Vector{Int}
    lpdrows::Vector{Int}
    lpcoefs::Vector{Cdouble}

    x_computed::Bool
    y_valid::Bool
    y::Vector{Cdouble}
    z_computed::Bool

    options::Dict{Symbol,Any}
    function DSDPSolverInstance(; kwargs...)
        m = new(C_NULL, C_NULL, 0, Int[], Int[], C_NULL, 0, Int[], Int[], Cdouble[],
            true, true, Cdouble[], true, Dict{Symbol, Any}(kwargs))
        finalizer(m, _free)
        m
    end
end
SOI.SDSolverInstance(s::DSDPSolver) = DSDPSolverInstance(; s.options...)

function _free(m::DSDPSolverInstance)
    if m.dsdp != C_NULL
        Destroy(m.dsdp)
        m.dsdp = C_NULL
        m.lpcone = C_NULL
        m.sdpcone = C_NULL
    end
end

function SOI.initinstance!(m::DSDPSolverInstance, blkdims::Vector{Int}, nconstrs::Int)
    _free(m)
    @assert nconstrs >= 0
    m.nconstrs = nconstrs
    m.blkdims = blkdims
    m.nlpdrows = 0
    sdpidx = 0
    m.blk = similar(blkdims)
    for i in 1:length(blkdims)
        if blkdims[i] < 0
            m.blk[i] = m.nlpdrows
            m.nlpdrows -= blkdims[i]
        else
            sdpidx += 1
            m.blk[i] = sdpidx
        end
    end
    m.lpdvars = Int[]
    m.lpdrows = Int[]
    m.lpcoefs = Cdouble[]
    m.dsdp = Create(nconstrs)
    # TODO only create if necessary
    m.sdpcone = CreateSDPCone(m.dsdp, length(blkdims))
    for constr in 1:nconstrs
        # TODO in examples/readsdpa.c line 162,
        # -0.0 is used instead of 0.0 if the dual obj is <= 0., check if it has impact
        SetY0(m.dsdp, constr, 0.0)
    end
    # TODO ComputeY0 as in examples/readsdpa.c

    m.x_computed = false
    # m.y does not contain the solution y
    m.y_valid = false
    m.z_computed = false
end

function SOI.setconstraintconstant!(m::DSDPSolverInstance, val, constr::Integer)
    SetDualObjective(m.dsdp, constr, val)
end
function _setcoefficient!(m::DSDPSolverInstance, coef, constr::Integer, blk::Integer, i::Integer, j::Integer)
    if m.blkdims[blk] < 0
        @assert i == j
        push!(m.lpdvars, constr+1)
        push!(m.lpdrows, m.blk[blk] + i - 1) # -1 because indexing starts at 0 in DSDP
        push!(m.lpcoefs, coef)
    else
        error("TODO")
    end
end
function SOI.setconstraintcoefficient!(m::DSDPSolverInstance, coef, constr::Integer, blk::Integer, i::Integer, j::Integer)
    _setcoefficient!(m, coef, constr, blk, i, j)
end
function SOI.setobjectivecoefficient!(m::DSDPSolverInstance, coef, blk::Integer, i::Integer, j::Integer)
    # in SOI, convention is MAX but in DSDP, convention is MIN so we reverse the sign of coef
    _setcoefficient!(m, -coef, 0, blk, i, j)
end

function MOI.optimize!(m::DSDPSolverInstance)
    if !isempty(m.lpdvars)
        m.lpcone = CreateLPCone(m.dsdp)
        LPCone.SetDataSparse(m.lpcone, m.nlpdrows, m.nconstrs+1, m.lpdvars, m.lpdrows, m.lpcoefs)
    end

    Setup(m.dsdp)
    Solve(m.dsdp)

    m.x_computed = false
    # m.y does not contain the solution y
    m.y_valid = false
    m.z_computed = true
end

function MOI.get(m::DSDPSolverInstance, ::MOI.TerminationStatus)
    status = StopReason(m.dsdp)
    if status == DSDP_CONVERGED
        return MOI.Success
    elseif status == DSDP_INFEASIBLE_START
        return MOI.OtherError
    elseif status == DSDP_SMALL_STEPS
        return MOI.SlowProgress
    elseif status == DSDP_INDEFINITE_SCHUR_MATRIX
        return MOI.NumericalError
    elseif status == DSDP_MAX_IT
        return MOI.IterationLimit
    elseif status == DSDP_NUMERICAL_ERROR
        return MOI.NumericalError
    elseif status == DSDP_UPPERBOUND
        return MOI.ObjectiveLimit
    elseif status == DSDP_USER_TERMINATION
        return MOI.Interrupted
    elseif status == CONTINUE_ITERATING
        return MOI.OtherError
    else
        error("Internal library error: status=$status")
    end
end

MOI.canget(m::DSDPSolverInstance, ::MOI.PrimalStatus) = GetSolutionType(m.dsdp) != DSDP_PDUNKNOWN
function MOI.get(m::DSDPSolverInstance, ::MOI.PrimalStatus)
    compute_x(m)
    status = GetSolutionType(m.dsdp)
    if status == DSDP_PDUNKNOWN
        return MOI.UnknownResultStatus
    elseif status == DSDP_PDFEASIBLE
        return MOI.FeasiblePoint
    elseif status == DSDP_UNBOUNDED
        return MOI.InfeasiblePoint
    elseif status == DSDP_INFEASIBLE
        return MOI.InfeasibilityCertificate
    else
        error("Internal library error: status=$status")
    end
end

MOI.canget(m::DSDPSolverInstance, ::MOI.DualStatus) = GetSolutionType(m.dsdp) != DSDP_PDUNKNOWN
function MOI.get(m::DSDPSolverInstance, ::MOI.DualStatus)
    compute_x(m)
    status = GetSolutionType(m.dsdp)
    if status == DSDP_PDUNKNOWN
        return MOI.UnknownResultStatus
    elseif status == DSDP_PDFEASIBLE
        return MOI.FeasiblePoint
    elseif status == DSDP_UNBOUNDED
        return MOI.InfeasibilityCertificate
    elseif status == DSDP_INFEASIBLE
        return MOI.InfeasiblePoint
    else
        error("Internal library error: status=$status")
    end
end

function SOI.getprimalobjectivevalue(m::DSDPSolverInstance)
    -GetPPObjective(m.dsdp)
end
function SOI.getdualobjectivevalue(m::DSDPSolverInstance)
    -GetDDObjective(m.dsdp)
end

function compute_x(m::DSDPSolverInstance)
    if !m.x_computed
        ComputeX(m.dsdp)
        m.x_computed = true
        m.z_computed = false
    end
end
struct LPXBlock <: AbstractMatrix{Cdouble}
    lpcone::LPCone.LPConeT
    offset::Int
end
function Base.getindex(x::LPXBlock, i, j)
    if i == j
        LPCone.GetXArray(x.lpcone)[x.offset+i]
    else
        zero(Cdouble)
    end
end
struct XBlockMat <: AbstractMatrix{Cdouble}
    instance::DSDPSolverInstance
end
function Base.getindex(x::XBlockMat, i)
    compute_x(x.instance)
    @assert x.instance.blkdims[i] < 0
    LPXBlock(x.instance.lpcone, x.instance.blk[i])
end
function SOI.getX(m::DSDPSolverInstance)
    XBlockMat(m)
end

function SOI.gety(m::DSDPSolverInstance)
    if !m.y_valid
        m.y = Vector{Cdouble}(m.nconstrs)
        GetY(m.dsdp, m.y)
        map!(-, m.y, m.y) # The primal objective is Max in SOI but Min in DSDP
    end
    m.y
end

function compute_z(m::DSDPSolverInstance)
    if !m.z_computed
        ComputeAndFactorS(m.dsdp)
        m.z_computed = true
    end
end
struct LPZBlock <: AbstractMatrix{Cdouble}
    lpcone::LPCone.LPConeT
    offset::Int
end
function Base.getindex(z::LPZBlock, i, j)
    if i == j
        LPCone.GetSArray(z.lpcone)[z.offset+i]
    else
        zero(Cdouble)
    end
end
struct ZBlockMat <: AbstractMatrix{Cdouble}
    instance::DSDPSolverInstance
end
function Base.getindex(z::ZBlockMat, i)
    compute_z(z.instance)
    @assert z.instance.blkdims[i] < 0
    LPZBlock(z.instance.lpcone, z.instance.blk[i])
end
function SOI.getZ(m::DSDPSolverInstance)
    ZBlockMat(m)
end
