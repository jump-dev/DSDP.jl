using MathOptInterfaceTests
const MOIT = MathOptInterfaceTests

const solver = () -> DSDP.DSDPInstance()
const config = MOIT.TestConfig(1e-6, 1e-6, true, true, true, true)

@testset "Linear tests" begin
    MOIT.contlineartest(solver, config, ["linear1", "linear11", "linear12"])
end
#@testset "Conic tests" begin
#    include(joinpath(Pkg.dir("MathOptInterface"), "test", "contconic.jl"))
#    contconictest(CSDP.CSDPSolver(printlevel=0), atol=1e-7, rtol=1e-7)
#end
