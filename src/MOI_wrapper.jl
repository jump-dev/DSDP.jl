# Copyright (c) 2022: Joey Huchette, Benoît Legat, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

macro _check(expr)
    @assert expr.head == :call
    msg = "Error calling $(expr.args[1])"
    return quote
        if (ret = $(esc(expr))) != 0
            error($msg)
        end
    end
end

mutable struct Optimizer <: MOI.AbstractOptimizer
    dsdp::Ptr{Cvoid}
    lpcone::Ptr{Cvoid}
    objective_constant::Cdouble
    objective_sign::Int
    b::Vector{Cdouble}
    # List of block dimensions `d > 0`:
    # * `-d` means a diagonal block with diagonal of length `d`
    # * `d` means a symmetric `d x d` block
    blockdims::Vector{Int}
    varmap::Vector{Tuple{Int,Int,Int}} # Variable Index vi -> blk, i, j
    # If `blockdims[i] < 0`, `blk[i]` is the offset in `lpdvars`.
    # That is the **sum of length** of diagonal block before
    # Otherwise, `blk[i]` is the **number** of SDP blocks before + 1
    # and hence the index in `sdpdrows`, `sdpdcols` and `sdpdcoefs`.
    blk::Vector{Int}
    sdpcone::Ptr{Nothing}
    # Sum of length of diagonal blocks
    nlpdrows::Int
    lpdvars::Vector{Int}
    lpdrows::Vector{Int}
    lpcoefs::Vector{Cdouble}
    # DSDP does not create its own copy of these vectors so we must absolutely have different ones
    # for each matrix
    sdpdinds::Vector{Vector{Vector{Cint}}}
    sdpdcoefs::Vector{Vector{Vector{Cdouble}}}
    y::Vector{Cdouble}
    silent::Bool
    options::Dict{String,Any}

    function Optimizer()
        model = new(
            C_NULL,
            C_NULL,
            0.0,
            1,
            Cdouble[],
            Int[],
            Tuple{Int,Int,Int}[],
            Int[],
            C_NULL,
            0,
            Int[],
            Int[],
            Cdouble[],
            Vector{Int}[],
            Vector{Vector{Cdouble}}[],
            Cdouble[],
            false,
            Dict{String,Any}(),
        )
        finalizer(MOI.empty!, model)
        return model
    end
end

Base.cconvert(::Type{Ptr{Cvoid}}, x::Optimizer) = x

Base.unsafe_convert(::Type{Ptr{Cvoid}}, x::Optimizer) = x.dsdp

# MOI.Silent

MOI.supports(::Optimizer, ::MOI.Silent) = true

function MOI.set(model::Optimizer, ::MOI.Silent, value::Bool)
    model.silent = value
    return
end

MOI.get(model::Optimizer, ::MOI.Silent) = model.silent

# MOI.SolverName

MOI.get(::Optimizer, ::MOI.SolverName) = "DSDP"

# Empty

function MOI.empty!(model::Optimizer)
    if model.dsdp != C_NULL
        @_check DSDPDestroy(model)
        model.dsdp = C_NULL
        model.lpcone = C_NULL
        model.sdpcone = C_NULL
    end
    model.objective_constant = 0
    model.objective_sign = 1
    empty!(model.b)
    empty!(model.blockdims)
    empty!(model.varmap)
    empty!(model.blk)
    model.nlpdrows = 0
    empty!(model.lpdvars)
    empty!(model.lpdrows)
    empty!(model.lpcoefs)
    empty!(model.sdpdinds)
    empty!(model.sdpdcoefs)
    empty!(model.y)
    return
end

function MOI.is_empty(model::Optimizer)
    return iszero(model.objective_constant) &&
           isone(model.objective_sign) &&
           isempty(model.b) &&
           isempty(model.blockdims) &&
           isempty(model.varmap) &&
           isempty(model.blk) &&
           iszero(model.nlpdrows) &&
           isempty(model.lpdvars) &&
           isempty(model.lpdrows) &&
           isempty(model.lpcoefs) &&
           isempty(model.sdpdinds) &&
           isempty(model.sdpdcoefs)
end

# MOI.RawOptimizerAttribute

function MOI.supports(model::Optimizer, attr::MOI.RawOptimizerAttribute)
    return attr.name in (
        "MaxIts",
        "GapTolerance",
        "PNormTolerance",
        "DualBound",
        "StepTolerance",
        "RTolerance",
        "PTolerance",
        "MaxTrustRadius",
        "BarrierParameter",
        "PotentialParameter",
        "PenaltyParameter",
        "ReuseMatrix",
        "R0",
        "ZBar",
    )
end

function MOI.get(model::Optimizer, attr::MOI.RawOptimizerAttribute)
    if !MOI.supports(model, attr)
        throw(MOI.UnsupportedAttribute(attr))
    end
    return get(model, attr.name, nothing)
end

function MOI.set(model::Optimizer, attr::MOI.RawOptimizerAttribute, value)
    if attr.name == "MaxIts"
        @_check DSDPSetMaxIts(model, value)
    elseif attr.name == "GapTolerance"
        @_check DSDPSetGapTolerance(model, value)
    elseif attr.name == "PNormTolerance"
        @_check DSDPSetPNormTolerance(model, value)
    elseif attr.name == "DualBound"
        @_check DSDPSetDualBound(model, value)
    elseif attr.name == "StepTolerance"
        @_check DSDPSetStepTolerance(model, value)
    elseif attr.name == "RTolerance"
        @_check DSDPSetRTolerance(model, value)
    elseif attr.name == "PTolerance"
        @_check DSDPSetPTolerance(model, value)
    elseif attr.name == "MaxTrustRadius"
        @_check DSDPSetMaxTrustRadius(model, value)
    elseif attr.name == "BarrierParameter"
        @_check DSDPSetBarrierParameter(model, value)
    elseif attr.name == "PotentialParameter"
        @_check DSDPSetPotentialParameter(model, value)
    elseif attr.name == "PenaltyParameter"
        @_check DSDPSetPenaltyParameter(model, value)
    elseif attr.name == "ReuseMatrix"
        @_check DSDPSetReuseMatrix(model, value)
    elseif attr.name == "R0"
        @_check DSDPSetR0(model, value)
    elseif attr.name == "ZBar"
        @_check DSDPSetZBar(model, value)
    else
        throw(MOI.UnsupportedAttribute(attr))
    end
    model.options[attr.name] = value
    return
end

# MOI.supports

MOI.supports(::Optimizer, ::MOI.ObjectiveSense) = true

function MOI.supports(
    ::Optimizer,
    ::MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Cdouble}},
)
    return true
end

MOI.supports_add_constrained_variables(::Optimizer, ::Type{MOI.Reals}) = false

function MOI.supports_add_constrained_variables(
    ::Optimizer,
    ::Type{<:Union{MOI.Nonnegatives,MOI.PositiveSemidefiniteConeTriangle}},
)
    return true
end

function MOI.supports_constraint(
    ::Optimizer,
    ::Type{MOI.ScalarAffineFunction{Cdouble}},
    ::Type{MOI.EqualTo{Cdouble}},
)
    return true
end

function _new_block(model::Optimizer, set::MOI.Nonnegatives)
    push!(model.blockdims, -MOI.dimension(set))
    blk = length(model.blockdims)
    for i in 1:MOI.dimension(set)
        push!(model.varmap, (blk, i, i))
    end
    return
end

function _new_block(model::Optimizer, set::MOI.PositiveSemidefiniteConeTriangle)
    push!(model.blockdims, set.side_dimension)
    blk = length(model.blockdims)
    for j in 1:set.side_dimension
        for i in 1:j
            push!(model.varmap, (blk, i, j))
        end
    end
    return
end

function _error(start, stop)
    return error(
        start,
        ". Use `MOI.instantiate(CSDP.Optimizer, with_bridge_type = Float64)` ",
        stop,
    )
end

function _constrain_variables_on_creation(
    dest::Optimizer,
    src::MOI.ModelLike,
    index_map::MOI.Utilities.IndexMap,
    ::Type{S},
) where {S<:Union{MOI.Nonnegatives,MOI.PositiveSemidefiniteConeTriangle}}
    for ci_src in
        MOI.get(src, MOI.ListOfConstraintIndices{MOI.VectorOfVariables,S}())
        f_src = MOI.get(src, MOI.ConstraintFunction(), ci_src)
        if !allunique(f_src.variables)
            _error(
                "Cannot copy constraint `$(ci_src)` as variables constrained on creation because there are duplicate variables in the function `$(f_src)`",
                "to bridge this by creating slack variables.",
            )
        elseif any(vi -> haskey(index_map, vi), f_src.variables)
            _error(
                "Cannot copy constraint `$(ci_src)` as variables constrained on creation because some variables of the function `$(f_src)` are in another constraint as well.",
                "to bridge constraints having the same variables by creating slack variables.",
            )
        end
        set = MOI.get(src, MOI.ConstraintSet(), ci_src)::S
        offset = length(dest.varmap)
        _new_block(dest, set)
        index_map[ci_src] =
            MOI.ConstraintIndex{MOI.VectorOfVariables,S}(offset + 1)
        for (i, vi_src) in enumerate(f_src.variables)
            index_map[vi_src] = MOI.VariableIndex(offset + i)
        end
    end
    return
end

function _set_coefficient(
    model::Optimizer,
    coef,
    constr::Integer,
    blk::Integer,
    i::Integer,
    j::Integer,
)
    if model.blockdims[blk] < 0
        @assert i == j
        push!(model.lpdvars, constr + 1)
        push!(model.lpdrows, model.blk[blk] + i - 1) # -1 because indexing starts at 0 in DSDP
        push!(model.lpcoefs, coef)
    else
        sdp = model.blk[blk]
        push!(model.sdpdinds[end][sdp], i + (j - 1) * model.blockdims[blk] - 1)
        if i != j
            coef /= 2
        end
        push!(model.sdpdcoefs[end][sdp], coef)
    end
    return
end

function _set_A_matrices(model::Optimizer, i)
    for (blk, blkdim) in zip(model.blk, model.blockdims)
        if blkdim > 0
            @_check SDPConeSetASparseVecMat(
                model.sdpcone,
                blk - 1,
                i,
                blkdim,
                1.0,
                0,
                model.sdpdinds[end][blk],
                model.sdpdcoefs[end][blk],
                length(model.sdpdcoefs[end][blk]),
            )
        end
    end
    return
end

function _new_A_matrix(model::Optimizer)
    push!(model.sdpdinds, Vector{Cint}[])
    push!(model.sdpdcoefs, Vector{Cdouble}[])
    for i in eachindex(model.blockdims)
        if model.blockdims[i] >= 0
            push!(model.sdpdinds[end], Cint[])
            push!(model.sdpdcoefs[end], Cdouble[])
        end
    end
    return
end

# Largely inspired from CSDP.jl
function MOI.copy_to(dest::Optimizer, src::MOI.ModelLike)
    @assert MOI.is_empty(dest)
    index_map = MOI.Utilities.IndexMap()
    # Step 1) Compute the dimensions of what needs to be allocated
    _constrain_variables_on_creation(dest, src, index_map, MOI.Nonnegatives)
    _constrain_variables_on_creation(
        dest,
        src,
        index_map,
        MOI.PositiveSemidefiniteConeTriangle,
    )
    vis_src = MOI.get(src, MOI.ListOfVariableIndices())
    if length(vis_src) < length(index_map.var_map)
        _error(
            "Free variables are not supported by DSDP",
            "to bridge free variables into `x - y` where `x` and `y` are nonnegative.",
        )
    end
    F, S = MOI.ScalarAffineFunction{Cdouble}, MOI.EqualTo{Float64}
    cis_src = MOI.get(src, MOI.ListOfConstraintIndices{F,S}())
    if isempty(cis_src)
        msg = "DSDP does not support problems with no constraint."
        throw(ArgumentError(msg))
    end
    resize!(dest.b, length(cis_src))
    dest.blk = zero(dest.blockdims)
    num_sdp = 0
    for i in 1:length(dest.blockdims)
        if dest.blockdims[i] < 0
            dest.blk[i] = dest.nlpdrows
            dest.nlpdrows -= dest.blockdims[i]
        else
            num_sdp += 1
            dest.blk[i] = num_sdp
        end
    end
    # Create a new solver object with the correct number of constraints.
    p = Ref{Ptr{Cvoid}}()
    @_check DSDPCreate(length(dest.b), p)
    dest.dsdp = p[]
    # Set options
    for (option, value) in dest.options
        MOI.set(dest, MOI.RawOptimizerAttribute(option), value)
    end
    if num_sdp > 0
        sdpcone = Ref{Ptr{Cvoid}}()
        @_check DSDPCreateSDPCone(dest, num_sdp, sdpcone)
        dest.sdpcone = sdpcone[]
        for (i, blk_dim) in enumerate(dest.blockdims)
            if blk_dim < 0
                continue    # It's an LP block
            end
            blk = dest.blk[i]
            @_check SDPConeSetBlockSize(dest.sdpcone, blk - 1, blk_dim)
            @_check SDPConeSetStorageFormat(dest.sdpcone, blk - 1, UInt8('U'))
        end
    end
    # TODO ComputeY0 as in examples/readsdpa.c
    empty!(dest.y)
    for (k, ci_src) in enumerate(cis_src)
        func = MOI.get(src, MOI.CanonicalConstraintFunction(), ci_src)
        set = MOI.get(src, MOI.ConstraintSet(), ci_src)
        f_k = MOI.constant(func)
        if !iszero(f_k)
            throw(MOI.ScalarFunctionConstantNotZero{Cdouble,F,S}(f_k))
        end
        @_check DSDPSetDualObjective(dest, k, MOI.constant(set))
        _new_A_matrix(dest)
        for t in func.terms
            if !iszero(t.coefficient)
                blk, i, j = dest.varmap[index_map[t.variable].value]
                _set_coefficient(dest, t.coefficient, k, blk, i, j)
            end
        end
        _set_A_matrices(dest, k)
        dest.b[k] = MOI.constant(set)
        index_map[ci_src] = MOI.ConstraintIndex{F,S}(k)
    end
    # Throw error for variable attributes
    MOI.Utilities.pass_attributes(dest, src, index_map, vis_src)
    # Throw error for constraint attributes
    MOI.Utilities.pass_attributes(dest, src, index_map, cis_src)
    # Pass objective attributes and throw error for other ones
    model_attributes = MOI.get(src, MOI.ListOfModelAttributesSet())
    obj_attr = MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Cdouble}}()
    for attr in model_attributes
        if attr != MOI.ObjectiveSense() && attr != obj_attr
            throw(MOI.UnsupportedAttribute(attr))
        end
    end
    if MOI.ObjectiveSense() in model_attributes
        sense = MOI.get(src, MOI.ObjectiveSense())
        dest.objective_sign = sense == MOI.MIN_SENSE ? 1 : -1
    end
    if obj_attr in model_attributes
        obj = MOI.Utilities.canonical(MOI.get(src, obj_attr))
        dest.objective_constant = obj.constant
        _new_A_matrix(dest)
        for term in obj.terms
            if !iszero(term.coefficient)
                vi = index_map[term.variable]
                blk, i, j = dest.varmap[vi.value]
                coef = dest.objective_sign * term.coefficient
                _set_coefficient(dest, coef, 0, blk, i, j)
            end
        end
        _set_A_matrices(dest, 0)
    end
    # Pass info to `dest.dsdp`
    if !isempty(dest.lpdvars)
        lpcone = Ref{Ptr{Cvoid}}()
        @_check DSDPCreateLPCone(dest, lpcone)
        dest.lpcone = lpcone[]
        nnzin, row, aval = _build_lp(
            length(dest.b) + 1,
            dest.lpdvars,
            dest.lpdrows,
            dest.lpcoefs,
        )
        @_check LPConeSetData(dest.lpcone, dest.nlpdrows, nnzin, row, aval)
    end
    @_check DSDPSetup(dest)
    return index_map
end

function _build_lp(nvars, lpdvars, lpdrows, lpcoefs)
    @assert length(lpdvars) == length(lpdrows) == length(lpcoefs)
    nzin = zeros(Cint, nvars)
    n = length(lpdvars)
    for var in lpdvars
        nzin[var] += 1
    end
    nnzin = Cint[zero(Cint); cumsum(nzin)]
    @assert nnzin[end] == n
    idx = map(var -> Int[], 1:nvars)
    for (i, var) in enumerate(lpdvars)
        push!(idx[var], i)
    end
    row = Vector{Cint}(undef, n)
    aval = Vector{Cdouble}(undef, n)
    for var in 1:nvars
        sort!(idx[var]; by = i -> lpdrows[i])
        row[(nnzin[var]+1):(nnzin[var+1])] = lpdrows[idx[var]]
        aval[(nnzin[var]+1):(nnzin[var+1])] = lpcoefs[idx[var]]
    end
    return nnzin, row, aval
end

function MOI.optimize!(model::Optimizer)
    @_check DSDPSetStandardMonitor(model, !model.silent ? 1 : 0)
    @_check DSDPSolve(model)
    # Calling `DSDPComputeX` not right after `DSDPSolve` seems to sometime cause
    # segfaults or weird Heisenbug's. Let's call it directly after, like
    # `DSDP/examples/readsdpa.c` does
    @_check DSDPComputeX(model)
    resize!(model.y, length(model.b))
    @_check DSDPGetY(model, model.y, length(model.y))
    return
end

function MOI.get(model::Optimizer, ::MOI.RawStatusString)
    if model.dsdp == C_NULL
        return "`optimize!` not called"
    end
    stop = Ref{DSDPTerminationReason}()
    @_check DSDPStopReason(model, stop)
    status = stop[]
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
    else
        @assert status == CONTINUE_ITERATING
        return "Continue iterating"
    end
end

function MOI.get(model::Optimizer, ::MOI.TerminationStatus)
    if model.dsdp == C_NULL
        return MOI.OPTIMIZE_NOT_CALLED
    end
    stop = Ref{DSDPTerminationReason}()
    @_check DSDPStopReason(model, stop)
    status = stop[]
    if status == DSDP_CONVERGED
        sol = Ref{DSDPSolutionType}()
        @_check DSDPGetSolutionType(model, sol)
        sol_status = sol[]
        if sol_status == DSDP_PDFEASIBLE
            return MOI.OPTIMAL
        elseif sol_status == DSDP_UNBOUNDED
            return MOI.INFEASIBLE
        elseif sol_status == DSDP_INFEASIBLE
            return MOI.DUAL_INFEASIBLE
        else
            @assert sol_status == DSDP_PDUNKNOWN
            return MOI.OTHER_ERROR
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
    else
        @assert status == CONTINUE_ITERATING
        return MOI.OTHER_ERROR
    end
end

function MOI.get(model::Optimizer, attr::MOI.PrimalStatus)
    if attr.result_index > MOI.get(model, MOI.ResultCount())
        return MOI.NO_SOLUTION
    end
    sol = Ref{DSDPSolutionType}()
    @_check DSDPGetSolutionType(model, sol)
    status = sol[]
    if status == DSDP_PDUNKNOWN
        return MOI.UNKNOWN_RESULT_STATUS
    elseif status == DSDP_PDFEASIBLE
        return MOI.FEASIBLE_POINT
    elseif status == DSDP_UNBOUNDED
        return MOI.INFEASIBLE_POINT
    else
        @assert status == DSDP_INFEASIBLE
        return MOI.INFEASIBILITY_CERTIFICATE
    end
end

function MOI.get(model::Optimizer, attr::MOI.DualStatus)
    if attr.result_index > MOI.get(model, MOI.ResultCount())
        return MOI.NO_SOLUTION
    end
    sol = Ref{DSDPSolutionType}()
    @_check DSDPGetSolutionType(model, sol)
    status = sol[]
    if status == DSDP_PDUNKNOWN
        return MOI.UNKNOWN_RESULT_STATUS
    elseif status == DSDP_PDFEASIBLE
        return MOI.FEASIBLE_POINT
    elseif status == DSDP_UNBOUNDED
        return MOI.INFEASIBILITY_CERTIFICATE
    else
        @assert status == DSDP_INFEASIBLE
        return MOI.INFEASIBLE_POINT
    end
end

MOI.get(model::Optimizer, ::MOI.ResultCount) = model.dsdp == C_NULL ? 0 : 1

function MOI.get(model::Optimizer, attr::MOI.ObjectiveValue)
    MOI.check_result_index_bounds(model, attr)
    ret = Ref{Cdouble}()
    @_check DSDPGetPPObjective(model, ret)
    return model.objective_sign * ret[] + model.objective_constant
end

function MOI.get(model::Optimizer, attr::MOI.DualObjectiveValue)
    MOI.check_result_index_bounds(model, attr)
    ret = Ref{Cdouble}()
    @_check DSDPGetDDObjective(model, ret)
    return model.objective_sign * ret[] + model.objective_constant
end

abstract type LPBlock <: AbstractMatrix{Cdouble} end

abstract type SDPBlock <: AbstractMatrix{Cdouble} end

Base.size(x::Union{LPBlock,SDPBlock}) = (x.dim, x.dim)

function Base.getindex(x::LPBlock, i, j)
    if i == j
        return _get_array(x)[x.offset+i]
    else
        return zero(Cdouble)
    end
end

function Base.getindex(x::SDPBlock, i, j)
    if i > j
        return getindex(x, j, i)
    else
        return _get_array(x)[MOI.Utilities.trimap(i, j)]
    end
end

abstract type AbstractBlockMatrix{T} <: AbstractMatrix{T} end

function Base.size(bm::AbstractBlockMatrix)
    n = mapreduce(
        blk -> LinearAlgebra.checksquare(block(bm, blk)),
        +,
        1:nblocks(bm);
        init = 0,
    )
    return (n, n)
end

function Base.getindex(bm::AbstractBlockMatrix, i::Integer, j::Integer)
    (i < 0 || j < 0) && throw(BoundsError(i, j))
    for k in 1:nblocks(bm)
        blk = block(bm, k)
        n = size(blk, 1)
        if i <= n && j <= n
            return blk[i, j]
        elseif i <= n || j <= n
            return 0
        else
            i -= n
            j -= n
        end
    end
    i, j = (i, j) .+ size(bm)
    throw(BoundsError(i, j))
end

Base.getindex(A::AbstractBlockMatrix, I::Tuple) = getindex(A, I...)

abstract type BlockMat <: AbstractBlockMatrix{Cdouble} end

nblocks(x::BlockMat) = length(x.model.blk)

struct LPXBlock <: LPBlock
    lpcone::Ptr{Cvoid}
    dim::Int
    offset::Int
end

function _get_array(x::LPXBlock)
    xout = Ref{Ptr{Cdouble}}()
    n = Ref{Cint}()
    @_check LPConeGetXArray(x.lpcone, xout, n)
    return unsafe_wrap(Array, xout[], n[])
end

struct SDPXBlock <: SDPBlock
    sdpcone::Ptr{Nothing}
    dim::Int
    blockj::Int
end

function _get_array(x::SDPXBlock)
    xmat = Ref{Ptr{Cdouble}}()
    nn = Ref{Cint}()
    @_check SDPConeGetXArray(x.sdpcone, x.blockj - 1, xmat, nn)
    v = unsafe_wrap(Array, xmat[], nn[])
    return [v[i+(j-1)*x.dim] for j in 1:x.dim for i in 1:j]
end

struct XBlockMat <: BlockMat
    model::Optimizer
end

function block(x::XBlockMat, i)
    if x.model.blockdims[i] < 0
        LPXBlock(x.model.lpcone, abs(x.model.blockdims[i]), x.model.blk[i])
    else
        SDPXBlock(x.model.sdpcone, x.model.blockdims[i], x.model.blk[i])
    end
end

function block(model::Optimizer, ci::MOI.ConstraintIndex{MOI.VectorOfVariables})
    return model.varmap[ci.value][1]
end

function _vectorize_block(M, blk::Integer, ::Type{MOI.Nonnegatives})
    return LinearAlgebra.diag(block(M, blk))
end

function _vectorize_block(
    M::AbstractMatrix{Cdouble},
    blk::Integer,
    ::Type{MOI.PositiveSemidefiniteConeTriangle},
)
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

function MOI.get(
    model::Optimizer,
    attr::MOI.VariablePrimal,
    vi::MOI.VariableIndex,
)
    MOI.check_result_index_bounds(model, attr)
    blk, i, j = model.varmap[vi.value]
    return block(XBlockMat(model), blk)[i, j]
end

function MOI.get(
    model::Optimizer,
    attr::MOI.ConstraintPrimal,
    ci::MOI.ConstraintIndex{MOI.VectorOfVariables,S},
) where {S<:Union{MOI.Nonnegatives,MOI.PositiveSemidefiniteConeTriangle}}
    MOI.check_result_index_bounds(model, attr)
    return _vectorize_block(XBlockMat(model), block(model, ci), S)
end

function MOI.get(
    model::Optimizer,
    attr::MOI.ConstraintDual,
    ci::MOI.ConstraintIndex{
        MOI.ScalarAffineFunction{Cdouble},
        MOI.EqualTo{Cdouble},
    },
)
    MOI.check_result_index_bounds(model, attr)
    return model.y[ci.value]
end
