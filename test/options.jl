using MathOptInterface
const MOI = MathOptInterface

using SemidefiniteOptInterface
const SOI = SemidefiniteOptInterface

@testset "Options" begin
    instance = DSDP.DSDPSolverInstance()
    SOI.initinstance!(instance, [1], 42)
    for (option, default) in Iterators.flatten((DSDP.options, DSDP.gettable_options))
        @eval begin
            @test MOI.get($instance, DSDP.$option()) == $default
        end
    end
end
