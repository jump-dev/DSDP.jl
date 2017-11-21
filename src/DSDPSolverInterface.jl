using SemidefiniteOptInterface
SDOI = SemidefiniteOptInterface

using MathOptInterface
MOI = MathOptInterface

export DSDPInstance

mutable struct DSDPSolverInstance <: SDOI.AbstractSDSolverInstance
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
DSDPInstance(; kws...) = SDOI.SDOIInstance(DSDPSolverInstance(; kws...))

function _free(m::DSDPSolverInstance)
    if m.dsdp != C_NULL
        Destroy(m.dsdp)
        m.dsdp = C_NULL
        m.lpcone = C_NULL
        m.sdpcone = C_NULL
    end
end

# Taken from src/solver/dsdpsetup.c
const gettable_options = Dict(
# Stopping parameters
:MaxIts => 500,
:GapTolerance => 1.0e-7, # 100<=nconstrs<=3000 => 1e-6, nconstrs>3000 => 5e-6
:PNormTolerance => 1.0e30,
:DualBound => 1.0e20,
:StepTolerance => 5.0e-2,
:RTolerance => 1.0e-6,
:PTolerance => 1.0e-4,
# Solver options
:MaxTrustRadius => 1.0e10,
:BarrierParameter => -1.0,
:PotentialParameter => 5.0, # nconstrs>100 => 3.0
:PenaltyParameter => 1.0e8,
:ReuseMatrix => 4, # 100<nconstrs<=1000 => 7, nconstrs>1000 => 10
:YBounds => (-1e7, 1e7))
# TODO
# UsePenalty(dsdp,0)
# UseDynamicRho(dsdp,1)
# DSDPLogInfoAllow(iloginfo,0)
# DSDPSetFixedVariable[s]
# DSDPSetDualLowerBound

const options = Dict(
# Solver options
:R0 => -1.0,
:ZBar => 1e10)

const options_setters = Dict{Symbol, Function}()

abstract type Option <: MOI.AbstractInstanceAttribute end
abstract type GettableOption <: Option end

MOI.canget(solver::DSDPSolverInstance, ::Option) = true
function MOI.set!(m::DSDPSolverInstance, o::Option, val)
    # Need to set it in the dictionary so that it is also used when initinstance! is called again
    _dict_set!(m.options, o, val)
    _call_set!(m.dsdp, o, val)
end

MOI.get(m::DSDPSolverInstance, o::Option) = _dict_get(m.options, o)
function MOI.get(m::DSDPSolverInstance, o::GettableOption)
    if m.dsdp == C_NULL
        _dict_get(m.options, o)
    else
        # May be different from _dict_get for ReuseMatrix, GapTolerance and PotentialParameter since it depends on nconstrs
        _call_get(m.dsdp, o)
    end
end

for (param, default) in gettable_options
    getter = Symbol("Get" * string(param))
    @eval begin
        struct $param <: GettableOption
        end
        function _call_get(dsdp, ::$param)
            $getter(dsdp)
        end
    end
end

for option in keys(options)
    @eval begin
        struct $option <: Option
        end
    end
end

for (param, default) in Iterators.flatten((options, gettable_options))
    setter = Symbol("Set" * string(param))
    sym = QuoteNode(param)
    @eval begin
        options_setters[$sym] = $setter
        function _dict_set!(options, ::$param, val)
            options[$sym] = val
        end
        function _dict_get(options, ::$param)
            get(options, $sym, $default)
        end
        function _call_set!(dsdp, ::$param, val)
            $setter(dsdp, val)
        end
    end
end

function SDOI.initinstance!(m::DSDPSolverInstance, blkdims::Vector{Int}, nconstrs::Int)
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
    for (option, value) in m.options
        options_setters[option](m.dsdp, value)
    end

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

function SDOI.setconstraintconstant!(m::DSDPSolverInstance, val, constr::Integer)
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
function SDOI.setconstraintcoefficient!(m::DSDPSolverInstance, coef, constr::Integer, blk::Integer, i::Integer, j::Integer)
    _setcoefficient!(m, coef, constr, blk, i, j)
end
function SDOI.setobjectivecoefficient!(m::DSDPSolverInstance, coef, blk::Integer, i::Integer, j::Integer)
    # in SDOI, convention is MAX but in DSDP, convention is MIN so we reverse the sign of coef
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

function SDOI.getprimalobjectivevalue(m::DSDPSolverInstance)
    -GetPPObjective(m.dsdp)
end
function SDOI.getdualobjectivevalue(m::DSDPSolverInstance)
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
function SDOI.getX(m::DSDPSolverInstance)
    XBlockMat(m)
end

function SDOI.gety(m::DSDPSolverInstance)
    if !m.y_valid
        m.y = Vector{Cdouble}(m.nconstrs)
        GetY(m.dsdp, m.y)
        map!(-, m.y, m.y) # The primal objective is Max in SDOI but Min in DSDP
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
function SDOI.getZ(m::DSDPSolverInstance)
    ZBlockMat(m)
end
