using MathOptInterface
const MOI = MathOptInterface

using SemidefiniteOptInterface
const SDOI = SemidefiniteOptInterface

@testset "Options" begin
    instance = DSDP.SDOptimizer()
    SDOI.init!(instance, [1], 42)
    for (option, default) in Iterators.flatten((DSDP.options, DSDP.gettable_options))
        @eval begin
            @test MOI.get($instance, DSDP.$option()) == $default
        end
    end
end
