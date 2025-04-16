# Copyright (c) 2022: Joey Huchette, Benoît Legat, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

module TestDSDP

using Test
import MathOptInterface as MOI
import LowRankOpt as LRO
import DSDP

function runtests()
    for name in names(@__MODULE__; all = true)
        if startswith("$(name)", "test_")
            @testset "$(name)" begin
                getfield(@__MODULE__, name)()
            end
        end
    end
    return
end

function test_solver_name()
    @test MOI.get(DSDP.Optimizer(), MOI.SolverName()) == "DSDP"
end

function test_options()
    param = MOI.RawOptimizerAttribute("bad_option")
    err = MOI.UnsupportedAttribute(param)
    @test_throws err MOI.set(
        DSDP.Optimizer(),
        MOI.RawOptimizerAttribute("bad_option"),
        0,
    )
end

function test_runtests()
    model = MOI.Utilities.CachingOptimizer(
        MOI.Utilities.UniversalFallback(MOI.Utilities.Model{Float64}()),
        MOI.instantiate(DSDP.Optimizer; with_bridge_type = Float64),
    )
    # `Variable.ZerosBridge` makes dual needed by some tests fail.
    MOI.Bridges.remove_bridge(
        model.optimizer,
        MOI.Bridges.Variable.ZerosBridge{Float64},
    )
    # Remove `FreeBridge` so that problems requiring free variables are
    # automatically skipped rather than solved with the degenerate
    # z = z⁺ - z⁻ splitting that DSDP (a dual-only solver) cannot handle.
    MOI.Bridges.remove_bridge(
        model.optimizer,
        MOI.Bridges.Variable.FreeBridge{Float64},
    )
    MOI.set(model, MOI.Silent(), true)
    MOI.Test.runtests(
        model,
        MOI.Test.Config(;
            rtol = 1e-2,
            atol = 1e-2,
            exclude = Any[
                MOI.ConstraintBasisStatus,
                MOI.VariableBasisStatus,
                MOI.ObjectiveBound,
                MOI.SolverVersion,
            ],
        );
        exclude = Regex[
            # ArgumentError: DSDP does not support problems with no constraint.
            # See https://github.com/jump-dev/MathOptInterface.jl/issues/1741#issuecomment-1057286739
            r"test_modification_set_singlevariable_lessthan$",
            r"test_solve_optimize_twice$",
            r"test_solve_result_index$",
            r"test_objective_ObjectiveFunction_constant$",
            r"test_objective_ObjectiveFunction_VariableIndex$",
            r"test_objective_FEASIBILITY_SENSE_clears_objective$",
            r"test_modification_transform_singlevariable_lessthan$",
            r"test_modification_delete_variables_in_a_batch$",
            r"test_modification_delete_variable_with_single_variable_obj$",
            r"test_modification_const_scalar_objective$",
            r"test_modification_coef_scalar_objective$",
            r"test_attribute_RawStatusString$",
            r"test_attribute_SolveTimeSec$",
            r"test_objective_ObjectiveFunction_blank$",
            r"test_objective_ObjectiveFunction_duplicate_terms$",
            r"test_solve_TerminationStatus_DUAL_INFEASIBLE$",
            r"test_DualObjectiveValue_Max_VariableIndex_LessThan$",
            r"test_DualObjectiveValue_Min_VariableIndex_GreaterThan$",
            # ArgumentError: DSDP does not support problems with no constraint.
            r"test_conic_SecondOrderCone_negative_initial_bound$",
            r"test_conic_SecondOrderCone_negative_post_bound$",
            r"test_conic_SecondOrderCone_nonnegative_initial_bound$",
            # TODO investigate
            r"test_model_copy_to_UnsupportedAttribute$",
            # TODO investigate: DSDP reports OPTIMAL instead of INFEASIBLE
            r"test_conic_linear_INFEASIBLE_2$",
            r"test_conic_RotatedSecondOrderCone_INFEASIBLE$",
            r"test_solve_DualStatus_INFEASIBILITY_CERTIFICATE_EqualTo_lower$",
            r"test_solve_DualStatus_INFEASIBILITY_CERTIFICATE_EqualTo_upper$",
            r"test_solve_DualStatus_INFEASIBILITY_CERTIFICATE_GreaterThan$",
            r"test_solve_DualStatus_INFEASIBILITY_CERTIFICATE_Interval_lower$",
            r"test_solve_DualStatus_INFEASIBILITY_CERTIFICATE_Interval_upper$",
            r"test_solve_DualStatus_INFEASIBILITY_CERTIFICATE_LessThan$",
            r"test_solve_DualStatus_INFEASIBILITY_CERTIFICATE_VariableIndex_LessThan$",
            # TODO investigate: incorrect result value
            r"test_variable_solve_with_lowerbound$",
        ],
    )
    return
end

function test_LRO_runtests()
    T = Float64
    model = MOI.instantiate(
        DSDP.Optimizer,
        with_bridge_type = T,
        with_cache_type = T,
    )
    LRO.Bridges.add_all_bridges(model, T)
    MOI.set(model, MOI.Silent(), true)
    config = MOI.Test.Config(
        rtol = 1e-2,
        atol = 1e-2,
    )
    MOI.Test.runtests(model, config, test_module = LRO.Test)
    return
end


end  # module

TestDSDP.runtests()
