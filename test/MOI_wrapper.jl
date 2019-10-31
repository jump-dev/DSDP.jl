using MathOptInterface

const MOI = MathOptInterface
const MOIT = MOI.Test
const MOIU = MOI.Utilities
const MOIB = MOI.Bridges

import DSDP
const optimizer = DSDP.Optimizer()

@testset "SolverName" begin
    @test MOI.get(optimizer, MOI.SolverName()) == "DSDP"
end

@testset "supports_default_copy_to" begin
    @test MOIU.supports_allocate_load(optimizer, false)
    @test !MOIU.supports_allocate_load(optimizer, true)
end

const cache = MOIU.UniversalFallback(MOIU.Model{Float64}())
const cached = MOIU.CachingOptimizer(cache, optimizer)
const bridged = MOIB.full_bridge_optimizer(cached, Float64)
const config = MOIT.TestConfig(atol=1e-6, rtol=1e-6)

@testset "Unit" begin
    MOIT.unittest(bridged, config, [
        # To investigate...
        "solve_duplicate_terms_obj", "solve_with_lowerbound",
        "solve_blank_obj", "solve_affine_interval",
        "solve_singlevariable_obj", "solve_constant_obj",
        "solve_affine_deletion_edge_cases",
        # `NumberOfThreads` not supported.
        "number_threads",
        # `TimeLimitSec` not supported.
        "time_limit_sec",
        # Quadratic functions are not supported
        "solve_qcp_edge_cases", "solve_qp_edge_cases",
        # Integer and ZeroOne sets are not supported
        "solve_integer_edge_cases", "solve_objbound_edge_cases",
        "solve_zero_one_with_bounds_1",
        "solve_zero_one_with_bounds_2",
        "solve_zero_one_with_bounds_3"
    ])
end

@testset "Continuous Linear" begin
    # See explanation in `MOI/test/Bridges/lazy_bridge_optimizer.jl`.
    # This is to avoid `Variable.VectorizeBridge` which does not support
    # `ConstraintSet` modification.
    MOIB.remove_bridge(bridged, MOIB.Constraint.ScalarSlackBridge{Float64})
    MOIT.contlineartest(bridged, config, [
        "linear1", "linear11", "linear12", "linear14"
    ])
end

#@testset "Conic tests" begin
#    contconictest(bridged, config)
#end
