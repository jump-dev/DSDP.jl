using MathOptInterface
const MOI = MathOptInterface
const MOIT = MOI.Test
const MOIU = MOI.Utilities
const MOIB = MOI.Bridges

MOIU.@model(SDModelData,
            (),
            (MOI.EqualTo, MOI.GreaterThan, MOI.LessThan),
            (MOI.Zeros, MOI.Nonnegatives, MOI.Nonpositives,
             MOI.PositiveSemidefiniteConeTriangle),
            (),
            (MOI.SingleVariable,),
            (MOI.ScalarAffineFunction,),
            (MOI.VectorOfVariables,),
            (MOI.VectorAffineFunction,))

const cache = MOIU.UniversalFallback(SDModelData{Float64}())
const optimizer = MOIU.CachingOptimizer(cache,
                                        DSDP.Optimizer())
const config = MOIT.TestConfig(atol=1e-6, rtol=1e-6)

@testset "SolverName" begin
    @test MOI.get(optimizer, MOI.SolverName()) == "DSDP"
end

@testset "Unit" begin
    MOIT.unittest(MOIB.SplitInterval{Float64}(optimizer), config,
                  [# To investigate...
                  "solve_duplicate_terms_obj", "solve_with_lowerbound",
                  "solve_blank_obj", "solve_affine_interval",
                  "solve_singlevariable_obj", "solve_constant_obj",
                  "solve_affine_deletion_edge_cases",
                   # Quadratic functions are not supported
                   "solve_qcp_edge_cases", "solve_qp_edge_cases",
                   # Integer and ZeroOne sets are not supported
                   "solve_integer_edge_cases", "solve_objbound_edge_cases"])
end

@testset "Continuous Linear" begin
    MOIT.contlineartest(MOIB.SplitInterval{Float64}(optimizer), config,
                        ["linear1", "linear11", "linear12", "linear14"])
end

#@testset "Conic tests" begin
#    include(joinpath(Pkg.dir("MathOptInterface"), "test", "contconic.jl"))
#    contconictest(DSDP.DSDPSolver(printlevel=0), atol=1e-7, rtol=1e-7)
#end
