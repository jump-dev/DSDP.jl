using MathOptInterface
const MOI = MathOptInterface
const MOIU = MOI.Utilities
const AFFEQ = MOI.ConstraintIndex{MOI.ScalarAffineFunction{Cdouble}, MOI.EqualTo{Cdouble}}

mutable struct Optimizer <: MOI.AbstractOptimizer
    dsdp::DSDPT
    lpcone::LPCone.LPConeT
    objconstant::Cdouble
    objsign::Int
    b::Vector{Cdouble}
    blockdims::Vector{Int}
    varmap::Vector{Tuple{Int, Int, Int}} # Variable Index vi -> blk, i, j
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

    is_setup::Bool

    silent::Bool
    options::Dict{Symbol,Any}
    function Optimizer(; kwargs...)
        optimizer = new(C_NULL, C_NULL, 0.0, 1, Cdouble[], Int[], Tuple{Int, Int, Int}[], Int[], C_NULL, 0, Int[],
                        Int[], Cdouble[], true, true, Cdouble[], true,
                        false, false, Dict{Symbol, Any}())
		for (key, value) in kwargs
			MOI.set(optimizer, MOI.RawParameter(key), value)
		end
        finalizer(_free, optimizer)
        return optimizer
    end
end

varmap(optimizer::Optimizer, vi::MOI.VariableIndex) = optimizer.varmap[vi.value]

MOI.supports(::Optimizer, ::MOI.Silent) = true
function MOI.set(optimizer::Optimizer, ::MOI.Silent, value::Bool)
	optimizer.silent = value
end
MOI.get(optimizer::Optimizer, ::MOI.Silent) = optimizer.silent

MOI.get(::Optimizer, ::MOI.SolverName) = "DSDP"

function MOI.empty!(optimizer::Optimizer)
    _free(optimizer)
    optimizer.objconstant = 0
    optimizer.objsign = 1
    empty!(optimizer.b)
    empty!(optimizer.blockdims)
    empty!(optimizer.varmap)
    empty!(optimizer.blk)
    optimizer.nlpdrows = 0
    empty!(optimizer.lpdvars)
    empty!(optimizer.lpdrows)
    empty!(optimizer.lpcoefs)

    optimizer.x_computed = false
    optimizer.y_valid = true
    empty!(optimizer.y)
    optimizer.z_computed = false
    optimizer.is_setup = false
end

function MOI.is_empty(optimizer::Optimizer)
    return iszero(optimizer.objconstant) &&
        isone(optimizer.objsign) &&
        isempty(optimizer.b) &&
        isempty(optimizer.blockdims) &&
        isempty(optimizer.varmap) &&
        isempty(optimizer.blk) &&
        iszero(optimizer.nlpdrows) &&
        isempty(optimizer.lpdvars) &&
        isempty(optimizer.lpdrows) &&
        isempty(optimizer.lpcoefs)
end

function _free(m::Optimizer)
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

abstract type Option <: MOI.AbstractOptimizerAttribute end
abstract type GettableOption <: Option end

MOI.supports(solver::Optimizer, ::Option) = true
function MOI.set(m::Optimizer, o::Option, val)
    # Need to set it in the dictionary so that it is also used when init! is called again
    _dict_set!(m.options, o, val)
    _call_set!(m.dsdp, o, val)
end

MOI.get(m::Optimizer, o::Option) = _dict_get(m.options, o)
function MOI.get(m::Optimizer, o::GettableOption)
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

function MOI.supports(
    optimizer::Optimizer,
    ::Union{MOI.ObjectiveSense,
            MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Cdouble}}})
    return true
end

MOI.supports_add_constrained_variables(::Optimizer, ::Type{MOI.Reals}) = false
const SupportedSets = Union{MOI.Nonnegatives, MOI.PositiveSemidefiniteConeTriangle}
MOI.supports_add_constrained_variables(::Optimizer, ::Type{<:SupportedSets}) = true
function MOI.supports_constraint(
    ::Optimizer, ::Type{MOI.ScalarAffineFunction{Cdouble}},
    ::Type{MOI.EqualTo{Cdouble}})
    return true
end

function MOI.copy_to(dest::Optimizer, src::MOI.ModelLike; kws...)
    return MOIU.automatic_copy_to(dest, src; kws...)
end
MOIU.supports_allocate_load(::Optimizer, copy_names::Bool) = !copy_names

function MOIU.allocate(optimizer::Optimizer, ::MOI.ObjectiveSense, sense::MOI.OptimizationSense)
    # DSDP convention is MIN so we reverse the sign of coef if it is MAX
    optimizer.objsign = sense == MOI.MIN_SENSE ? 1 : -1
end
function MOIU.allocate(::Optimizer, ::MOI.ObjectiveFunction, ::MOI.ScalarAffineFunction) end

function MOIU.load(::Optimizer, ::MOI.ObjectiveSense, ::MOI.OptimizationSense) end
# Loads objective coefficient α * vi
function load_objective_term!(optimizer::Optimizer, α, vi::MOI.VariableIndex)
    blk, i, j = varmap(optimizer, vi)
    coef = optimizer.objsign * α
    if i != j
        coef /= 2
    end
    _setcoefficient!(optimizer, coef, 0, blk, i, j)
end
function MOIU.load(optimizer::Optimizer, ::MOI.ObjectiveFunction, f::MOI.ScalarAffineFunction)
    obj = MOIU.canonical(f)
    optimizer.objconstant = f.constant
    for t in obj.terms
        if !iszero(t.coefficient)
            load_objective_term!(optimizer, t.coefficient, t.variable_index)
        end
    end
end

function new_block(optimizer::Optimizer, set::MOI.Nonnegatives)
    push!(optimizer.blockdims, -MOI.dimension(set))
    blk = length(optimizer.blockdims)
    for i in 1:MOI.dimension(set)
        push!(optimizer.varmap, (blk, i, i))
    end
end

function new_block(optimizer::Optimizer, set::MOI.PositiveSemidefiniteConeTriangle)
    push!(optimizer.blockdims, set.side_dimension)
    blk = length(optimizer.blockdims)
    for i in 1:set.side_dimension
        for j in 1:i
            push!(optimizer.varmap, (blk, i, j))
        end
    end
end

function MOIU.allocate_constrained_variables(optimizer::Optimizer,
                                             set::SupportedSets)
    offset = length(optimizer.varmap)
    new_block(optimizer, set)
    ci = MOI.ConstraintIndex{MOI.VectorOfVariables, typeof(set)}(offset + 1)
    return [MOI.VariableIndex(i) for i in offset .+ (1:MOI.dimension(set))], ci
end

function MOIU.load_constrained_variables(
    optimizer::Optimizer, vis::Vector{MOI.VariableIndex},
    ci::MOI.ConstraintIndex{MOI.VectorOfVariables},
    set::SupportedSets)
end

function MOIU.load_variables(m::Optimizer, nvars)
    _free(m)
    m.nlpdrows = 0
    sdpidx = 0
    m.blk = similar(m.blockdims)
    for i in 1:length(m.blockdims)
        if m.blockdims[i] < 0
            m.blk[i] = m.nlpdrows
            m.nlpdrows -= m.blockdims[i]
        else
            sdpidx += 1
            m.blk[i] = sdpidx
        end
    end
    m.lpdvars = Int[]
    m.lpdrows = Int[]
    m.lpcoefs = Cdouble[]

    m.dsdp = Create(length(m.b))
    for (option, value) in m.options
        options_setters[option](m.dsdp, value)
    end

    # TODO only create if necessary
    m.sdpcone = CreateSDPCone(m.dsdp, length(m.blockdims))
    for constr in eachindex(m.b)
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

function _setcoefficient!(m::Optimizer, coef, constr::Integer, blk::Integer, i::Integer, j::Integer)
    if m.blockdims[blk] < 0
        @assert i == j
        push!(m.lpdvars, constr+1)
        push!(m.lpdrows, m.blk[blk] + i - 1) # -1 because indexing starts at 0 in DSDP
        push!(m.lpcoefs, coef)
    else
        error("TODO")
    end
end

function MOIU.allocate_constraint(optimizer::Optimizer,
                                  func::MOI.ScalarAffineFunction{Cdouble},
                                  set::MOI.EqualTo{Cdouble})
    push!(optimizer.b, MOI.constant(set))
    return AFFEQ(length(optimizer.b))
end

function MOIU.load_constraint(m::Optimizer, ci::AFFEQ,
                              f::MOI.ScalarAffineFunction, s::MOI.EqualTo)
    if !iszero(MOI.constant(f))
        throw(MOI.ScalarFunctionConstantNotZero{
            Cdouble, MOI.ScalarAffineFunction{Cdouble}, MOI.EqualTo{Cdouble}}(
                MOI.constant(f)))
    end
    SetDualObjective(m.dsdp, ci.value, MOI.constant(s))
    f = MOIU.canonical(f) # sum terms with same variables and same outputindex
    for t in f.terms
        if !iszero(t.coefficient)
            blk, i, j = varmap(m, t.variable_index)
            coef = t.coefficient
            if i != j
                coef /= 2
            end
            _setcoefficient!(m, coef, ci.value, blk, i, j)
        end
    end
end


function MOI.optimize!(m::Optimizer)
    # TODO in MOI v0.10, remove the `is_setup` flag
    #      and do this in `MOI.Utilities.final_touch`.
    if !m.is_setup
        if !isempty(m.lpdvars)
            m.lpcone = CreateLPCone(m.dsdp)
            LPCone.SetDataSparse(m.lpcone, m.nlpdrows, length(m.b) + 1, m.lpdvars, m.lpdrows, m.lpcoefs)
        end

        Setup(m.dsdp)
        m.is_setup = true
    end

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

function MOI.get(m::Optimizer, ::MOI.RawStatusString)
    if m.dsdp == C_NULL
        return "`optimize!` not called"
    end
    status = StopReason(m.dsdp)
    compute_x(m)
    if status == DSDP_CONVERGED
        return "Converged"
    elseif status == DSDP_INFEASIBLE_START
        return "Infeasible start"
    elseif status == DSDP_SMALL_STEPS
        return "Small steps"
    elseif status == DSDP_INDEFINITE_SCHUR_MATRIX
        return "Indefinite Schur matrix"
    elseif status == DSDP_MAX_IT
        return "Max iteration"
    elseif status == DSDP_NUMERICAL_ERROR
        return "Numerical error"
    elseif status == DSDP_UPPERBOUND
        return "Upperbound"
    elseif status == DSDP_USER_TERMINATION
        return "User termination"
    elseif status == CONTINUE_ITERATING
        return "Continue iterating"
    else
        error("Internal library error: status=$status")
    end
end

function MOI.get(m::Optimizer, ::MOI.TerminationStatus)
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
            return MOI.OTHER_ERROR
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

function MOI.get(m::Optimizer, attr::MOI.PrimalStatus)
    if attr.N > MOI.get(m, MOI.ResultCount())
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

function MOI.get(m::Optimizer, attr::MOI.DualStatus)
    if attr.N > MOI.get(m, MOI.ResultCount())
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

MOI.get(m::Optimizer, ::MOI.ResultCount) = m.dsdp == C_NULL ? 0 : 1
function MOI.get(m::Optimizer, attr::MOI.ObjectiveValue)
    MOI.check_result_index_bounds(m, attr)
    return m.objsign * GetPPObjective(m.dsdp) + m.objconstant
end
function MOI.get(m::Optimizer, attr::MOI.DualObjectiveValue)
    MOI.check_result_index_bounds(m, attr)
    return m.objsign * GetDDObjective(m.dsdp) + m.objconstant
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

include("blockdiag.jl")
abstract type BlockMat <: AbstractBlockMatrix{Cdouble} end
nblocks(x::BlockMat) = length(x.optimizer.blk)

function compute_x(m::Optimizer)
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
    optimizer::Optimizer
end
function block(x::XBlockMat, i)
    compute_x(x.optimizer)
    @assert x.optimizer.blockdims[i] < 0
    LPXBlock(x.optimizer.lpcone, abs(x.optimizer.blockdims[i]), x.optimizer.blk[i])
end
struct PrimalSolutionMatrix <: MOI.AbstractModelAttribute end
MOI.is_set_by_optimize(::PrimalSolutionMatrix) = true
MOI.get(optimizer::Optimizer, ::PrimalSolutionMatrix) = XBlockMat(optimizer)

struct DualSolutionVector <: MOI.AbstractModelAttribute end
MOI.is_set_by_optimize(::DualSolutionVector) = true
function MOI.get(optimizer::Optimizer, ::DualSolutionVector)
    if !optimizer.y_valid
        optimizer.y = Vector{Cdouble}(undef, length(optimizer.b))
        GetY(optimizer.dsdp, optimizer.y)
        map!(-, optimizer.y, optimizer.y) # The primal objective is Max in SDOI but Min in DSDP
    end
    return optimizer.y
end

function compute_z(m::Optimizer)
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
    optimizer::Optimizer
end
function block(z::ZBlockMat, i)
    compute_z(z.optimizer)
    @assert z.optimizer.blockdims[i] < 0
    LPZBlock(z.optimizer.lpcone, abs(z.optimizer.blockdims[i]), z.optimizer.blk[i])
end
struct DualSlackMatrix <: MOI.AbstractModelAttribute end
MOI.is_set_by_optimize(::DualSlackMatrix) = true
MOI.get(optimizer::Optimizer, ::DualSlackMatrix) = ZBlockMat(optimizer)

function block(optimizer::Optimizer, ci::MOI.ConstraintIndex{MOI.VectorOfVariables})
    return optimizer.varmap[ci.value][1]
end
function dimension(optimizer::Optimizer, ci::MOI.ConstraintIndex{MOI.VectorOfVariables})
    blockdim = optimizer.blockdims[block(optimizer, ci)]
    if blockdim < 0
        return -blockdim
    else
        return MOI.dimension(MOI.PositiveSemidefiniteConeTriangle(blockdim))
    end
end
function vectorize_block(M, blk::Integer, s::Type{MOI.Nonnegatives})
    return diag(block(M, blk))
end
function vectorize_block(M::AbstractMatrix{Cdouble}, blk::Integer, s::Type{MOI.PositiveSemidefiniteConeTriangle}) where T
    B = block(M, blk)
    d = LinearAlgebra.checksquare(B)
    n = MOI.dimension(MOI.PositiveSemidefiniteConeTriangle(d))
    v = Vector{Cdouble}(undef, n)
    k = 0
    for j in 1:d
        for i in 1:j
            k += 1
            v[k] = B[i, j]
        end
    end
    @assert k == n
    return v
end

function MOI.get(optimizer::Optimizer, attr::MOI.VariablePrimal, vi::MOI.VariableIndex)
    MOI.check_result_index_bounds(optimizer, attr)
    blk, i, j = varmap(optimizer, vi)
    return block(MOI.get(optimizer, PrimalSolutionMatrix()), blk)[i, j]
end

function MOI.get(optimizer::Optimizer, attr::MOI.ConstraintPrimal,
                 ci::MOI.ConstraintIndex{MOI.VectorOfVariables, S}) where S<:SupportedSets
    MOI.check_result_index_bounds(optimizer, attr)
    return vectorize_block(MOI.get(optimizer, PrimalSolutionMatrix()), block(optimizer, ci), S)
end
function MOI.get(optimizer::Optimizer, attr::MOI.ConstraintPrimal, ci::AFFEQ)
    MOI.check_result_index_bounds(optimizer, attr)
    return optimizer.b[ci.value]
end

function MOI.get(optimizer::Optimizer, attr::MOI.ConstraintDual,
                 ci::MOI.ConstraintIndex{MOI.VectorOfVariables, S}) where S<:SupportedSets
    MOI.check_result_index_bounds(optimizer, attr)
    return vectorize_block(MOI.get(optimizer, DualSlackMatrix()), block(optimizer, ci), S)
end
function MOI.get(optimizer::Optimizer, attr::MOI.ConstraintDual, ci::AFFEQ)
    MOI.check_result_index_bounds(optimizer, attr)
    return -MOI.get(optimizer, DualSolutionVector())[ci.value]
end
