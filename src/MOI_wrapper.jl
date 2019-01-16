using SemidefiniteOptInterface
SDOI = SemidefiniteOptInterface

using MathOptInterface
MOI = MathOptInterface

mutable struct SDOptimizer <: SDOI.AbstractSDOptimizer
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
    function SDOptimizer(; kwargs...)
        optimizer = new(C_NULL, C_NULL, 0, Int[], Int[], C_NULL, 0, Int[],
                        Int[], Cdouble[], true, true, Cdouble[], true,
                        Dict{Symbol, Any}(kwargs))
        finalizer(_free, optimizer)
        return optimizer
    end
end
Optimizer(; kws...) = SDOI.SDOIOptimizer(SDOptimizer(; kws...))

MOI.get(::SDOptimizer, ::MOI.SolverName) = "DSDP"

function MOI.empty!(optimizer::SDOptimizer)
    _free(optimizer)
    optimizer.nconstrs = 0
    optimizer.blkdims = Int[]
    optimizer.blk = Int[]
    optimizer.nlpdrows = 0
    optimizer.lpdvars = Int[]
    optimizer.lpdrows = Int[]
    optimizer.lpcoefs = Cdouble[]

    optimizer.x_computed = true
    optimizer.y_valid = true
    optimizer.y = Cdouble[]
    optimizer.z_computed = true
end

function _free(m::SDOptimizer)
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

abstract type Option <: MOI.AbstractModelAttribute end
abstract type GettableOption <: Option end

MOI.supports(solver::SDOptimizer, ::Option) = true
function MOI.set(m::SDOptimizer, o::Option, val)
    # Need to set it in the dictionary so that it is also used when init! is called again
    _dict_set!(m.options, o, val)
    _call_set!(m.dsdp, o, val)
end

MOI.get(m::SDOptimizer, o::Option) = _dict_get(m.options, o)
function MOI.get(m::SDOptimizer, o::GettableOption)
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

function SDOI.init!(m::SDOptimizer, blkdims::Vector{Int}, nconstrs::Int)
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

function SDOI.setconstraintconstant!(m::SDOptimizer, val, constr::Integer)
    SetDualObjective(m.dsdp, constr, val)
end
function _setcoefficient!(m::SDOptimizer, coef, constr::Integer, blk::Integer, i::Integer, j::Integer)
    if m.blkdims[blk] < 0
        @assert i == j
        push!(m.lpdvars, constr+1)
        push!(m.lpdrows, m.blk[blk] + i - 1) # -1 because indexing starts at 0 in DSDP
        push!(m.lpcoefs, coef)
    else
        error("TODO")
    end
end
function SDOI.setconstraintcoefficient!(m::SDOptimizer, coef, constr::Integer, blk::Integer, i::Integer, j::Integer)
    _setcoefficient!(m, coef, constr, blk, i, j)
end
function SDOI.setobjectivecoefficient!(m::SDOptimizer, coef, blk::Integer, i::Integer, j::Integer)
    # in SDOI, convention is MAX but in DSDP, convention is MIN so we reverse the sign of coef
    _setcoefficient!(m, -coef, 0, blk, i, j)
end

function MOI.optimize!(m::SDOptimizer)
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

    # It seems that calling this later causes segfaults, maybe it can be fixed
    # with some `GC.@preserve` somewhere like in
    # https://github.com/JuliaOpt/ECOS.jl/pull/63
    # and
    # https://github.com/JuliaOpt/SCS.jl/pull/91
    compute_x(m)
    compute_z(m)
end

function MOI.get(m::SDOptimizer, ::MOI.TerminationStatus)
    if m.dsdp == C_NULL
        return MOI.OPTIMIZE_NOT_CALLED
    end
    status = StopReason(m.dsdp)
    compute_x(m)
    if status == DSDP_CONVERGED
        sol_status = GetSolutionType(m.dsdp)
        if sol_status == DSDP_PDFEASIBLE
            return MOI.OPTIMAL
        elseif sol_status == DSDP_UNBOUNDED
            return MOI.INFEASIBLE
        elseif sol_status == DSDP_INFEASIBLE
            return MOI.DUAL_INFEASIBLE
        elseif sol_status == DSDP_PDUNKNOWN
            return MOI.ALMOST_OPTIMAL
        else
            error("Internal library error: status=$sol_status")
        end
    elseif status == DSDP_INFEASIBLE_START
        return MOI.OTHER_ERROR
    elseif status == DSDP_SMALL_STEPS
        return MOI.SLOW_PROGRESS
    elseif status == DSDP_INDEFINITE_SCHUR_MATRIX
        return MOI.NUMERICAL_ERROR
    elseif status == DSDP_MAX_IT
        return MOI.ITERATION_LIMIT
    elseif status == DSDP_NUMERICAL_ERROR
        return MOI.NUMERICAL_ERROR
    elseif status == DSDP_UPPERBOUND
        return MOI.OBJECTIVE_LIMIT
    elseif status == DSDP_USER_TERMINATION
        return MOI.INTERRUPTED
    elseif status == CONTINUE_ITERATING
        return MOI.OTHER_ERROR
    else
        error("Internal library error: status=$status")
    end
end

function MOI.get(m::SDOptimizer, ::MOI.PrimalStatus)
    if m.dsdp == C_NULL
        return MOI.NO_SOLUTION
    end
    compute_x(m)
    status = GetSolutionType(m.dsdp)
    if status == DSDP_PDUNKNOWN
        return MOI.UNKNOWN_RESULT_STATUS
    elseif status == DSDP_PDFEASIBLE
        return MOI.FEASIBLE_POINT
    elseif status == DSDP_UNBOUNDED
        return MOI.INFEASIBLE_POINT
    elseif status == DSDP_INFEASIBLE
        return MOI.INFEASIBILITY_CERTIFICATE
    else
        error("Internal library error: status=$status")
    end
end

function MOI.get(m::SDOptimizer, ::MOI.DualStatus)
    if m.dsdp == C_NULL
        return MOI.NO_SOLUTION
    end
    compute_x(m)
    status = GetSolutionType(m.dsdp)
    if status == DSDP_PDUNKNOWN
        return MOI.UNKNOWN_RESULT_STATUS
    elseif status == DSDP_PDFEASIBLE
        return MOI.FEASIBLE_POINT
    elseif status == DSDP_UNBOUNDED
        return MOI.INFEASIBILITY_CERTIFICATE
    elseif status == DSDP_INFEASIBLE
        return MOI.INFEASIBLE_POINT
    else
        error("Internal library error: status=$status")
    end
end

function SDOI.getprimalobjectivevalue(m::SDOptimizer)
    -GetPPObjective(m.dsdp)
end
function SDOI.getdualobjectivevalue(m::SDOptimizer)
    -GetDDObjective(m.dsdp)
end

abstract type LPBlock <: AbstractMatrix{Cdouble} end
Base.size(x::LPBlock) = (x.dim, x.dim)
function Base.getindex(x::LPBlock, i, j)
    if i == j
        return get_array(x)[x.offset + i]
    else
        return zero(Cdouble)
    end
end


abstract type BlockMat <: SDOI.AbstractBlockMatrix{Cdouble} end
SDOI.nblocks(x::BlockMat) = length(x.optimizer.blk)

function compute_x(m::SDOptimizer)
    if !m.x_computed
        @assert m.dsdp != C_NULL
        ComputeX(m.dsdp)
        m.x_computed = true
        m.z_computed = false
    end
end
struct LPXBlock <: LPBlock
    lpcone::LPCone.LPConeT
    dim::Int
    offset::Int
end
get_array(x::LPXBlock) = LPCone.GetXArray(x.lpcone)
struct XBlockMat <: BlockMat
    optimizer::SDOptimizer
end
function SDOI.block(x::XBlockMat, i)
    compute_x(x.optimizer)
    @assert x.optimizer.blkdims[i] < 0
    LPXBlock(x.optimizer.lpcone, abs(x.optimizer.blkdims[i]), x.optimizer.blk[i])
end
function SDOI.getX(optimizer::SDOptimizer)
    XBlockMat(optimizer)
end

function SDOI.gety(m::SDOptimizer)
    if !m.y_valid
        m.y = Vector{Cdouble}(undef, m.nconstrs)
        GetY(m.dsdp, m.y)
        map!(-, m.y, m.y) # The primal objective is Max in SDOI but Min in DSDP
    end
    m.y
end

function compute_z(m::SDOptimizer)
    if !m.z_computed
        GC.@preserve m begin
            ComputeAndFactorS(m.dsdp)
        end
        m.z_computed = true
    end
end
struct LPZBlock <: LPBlock
    lpcone::LPCone.LPConeT
    dim::Int
    offset::Int
end
get_array(z::LPZBlock) = LPCone.GetSArray(z.lpcone)
struct ZBlockMat <: BlockMat
    optimizer::SDOptimizer
end
function SDOI.block(z::ZBlockMat, i)
    compute_z(z.optimizer)
    @assert z.optimizer.blkdims[i] < 0
    LPZBlock(z.optimizer.lpcone, abs(z.optimizer.blkdims[i]), z.optimizer.blk[i])
end
function SDOI.getZ(m::SDOptimizer)
    return ZBlockMat(m)
end
