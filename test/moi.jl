@testset "Linear tests" begin
    include(joinpath(Pkg.dir("MathOptInterface"), "test", "contlinear.jl"))
    linear2test(DSDP.DSDPSolver(), atol=1e-7, rtol=1e-7)
    linear3test(DSDP.DSDPSolver(), atol=1e-7, rtol=1e-7)
    linear4test(DSDP.DSDPSolver(), atol=1e-7, rtol=1e-7)
    linear5test(DSDP.DSDPSolver(), atol=1e-7, rtol=1e-7)
    linear6test(DSDP.DSDPSolver(), atol=1e-6, rtol=1e-6)
    linear7test(DSDP.DSDPSolver(), atol=1e-6, rtol=1e-6)
    linear8test(DSDP.DSDPSolver(), atol=1e-7, rtol=1e-7)
    linear9test(DSDP.DSDPSolver(), atol=1e-7, rtol=1e-7)
    linear10test(DSDP.DSDPSolver(), atol=1e-7, rtol=1e-7)
end
#@testset "Conic tests" begin
#    include(joinpath(Pkg.dir("MathOptInterface"), "test", "contconic.jl"))
#    contconictest(CSDP.CSDPSolver(printlevel=0), atol=1e-7, rtol=1e-7)
#end
