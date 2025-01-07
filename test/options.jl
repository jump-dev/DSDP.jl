# Copyright (c) 2022: Joey Huchette, Benoît Legat, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

using MathOptInterface
const MOI = MathOptInterface

@testset "Options" begin
    optimizer = MOI.Utilities.CachingOptimizer(
        MOI.Utilities.Model{Float64}(),
        DSDP.Optimizer(),
    )
    x, cx = MOI.add_constrained_variables(optimizer, MOI.Nonnegatives(1))
    MOI.add_constraint(optimizer, 1.0x[1], MOI.EqualTo(1.0))
    MOI.Utilities.attach_optimizer(optimizer)
    for (option, default) in
        Iterators.flatten((DSDP.options, DSDP.gettable_options))
        @eval begin
            @test MOI.get($optimizer, DSDP.$option()) == $default
        end
    end
end
