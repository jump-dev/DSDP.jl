module TestDSDP

using Test
using MathOptInterface
import DSDP

const MOI = MathOptInterface

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
        MOI.instantiate(DSDP.Optimizer, with_bridge_type = Float64),
    )
    # `Variable.ZerosBridge` makes dual needed by some tests fail.
    MOI.Bridges.remove_bridge(
        model.optimizer,
        MathOptInterface.Bridges.Variable.ZerosBridge{Float64},
    )
    MOI.set(model, MOI.Silent(), true)
    MOI.Test.runtests(
        model,
        MOI.Test.Config(
            rtol = 1e-3,
            atol = 1e-3,
            exclude = Any[
                MOI.ConstraintBasisStatus,
                MOI.VariableBasisStatus,
                MOI.ObjectiveBound,
                MOI.SolverVersion,
            ],
        ),
        exclude = String[
            # ArgumentError: DSDP does not support problems with no constraint.
            # See https://github.com/jump-dev/MathOptInterface.jl/issues/1741#issuecomment-1057286739
            "test_solve_optimize_twice",
            "test_solve_result_index",
            "test_quadratic_nonhomogeneous",
            "test_quadratic_integration",
            "test_objective_ObjectiveFunction_constant",
            "test_objective_ObjectiveFunction_VariableIndex",
            "test_objective_FEASIBILITY_SENSE_clears_objective",
            "test_modification_transform_singlevariable_lessthan",
            "test_modification_set_singlevariable_lessthan",
            "test_modification_delete_variables_in_a_batch",
            "test_modification_delete_variable_with_single_variable_obj",
            "test_modification_const_scalar_objective",
            "test_modification_coef_scalar_objective",
            "test_attribute_RawStatusString",
            "test_attribute_SolveTimeSec",
            "test_objective_ObjectiveFunction_blank",
            "test_objective_ObjectiveFunction_duplicate_terms",
            "test_solve_TerminationStatus_DUAL_INFEASIBLE",
            # TODO investigate
            #  Expression: MOI.get(model, MOI.TerminationStatus()) == config.infeasible_status
            #   Evaluated: MathOptInterface.OPTIMAL == MathOptInterface.INFEASIBLE
            "test_conic_NormInfinityCone_INFEASIBLE",
            "test_conic_NormOneCone_INFEASIBLE",
            "test_conic_linear_INFEASIBLE",
            "test_conic_linear_INFEASIBLE_2",
            "test_solve_DualStatus_INFEASIBILITY_CERTIFICATE_EqualTo_lower",
            "test_solve_DualStatus_INFEASIBILITY_CERTIFICATE_EqualTo_upper",
            "test_solve_DualStatus_INFEASIBILITY_CERTIFICATE_GreaterThan",
            "test_solve_DualStatus_INFEASIBILITY_CERTIFICATE_Interval_lower",
            "test_solve_DualStatus_INFEASIBILITY_CERTIFICATE_Interval_upper",
            "test_solve_DualStatus_INFEASIBILITY_CERTIFICATE_LessThan",
            "test_solve_DualStatus_INFEASIBILITY_CERTIFICATE_VariableIndex_LessThan",
            # TODO investigate
            # Incorrect result value
            "test_conic_NormInfinityCone_3",
            "test_conic_NormInfinityCone_VectorAffineFunction",
            "test_conic_NormInfinityCone_VectorOfVariables",
            "test_conic_NormOneCone",
            "test_conic_NormOneCone_VectorAffineFunction",
            "test_conic_NormOneCone_VectorOfVariables",
            "test_conic_linear_VectorAffineFunction",
            "test_conic_linear_VectorAffineFunction_2",
            "test_conic_linear_VectorOfVariables",
            "test_constraint_ScalarAffineFunction_Interval",
            "test_linear_variable_open_intervals",
            # Incorrect objective
            # See https://github.com/jump-dev/MathOptInterface.jl/issues/1759
            "test_infeasible_MAX_SENSE",
            "test_infeasible_MAX_SENSE_offset",
            "test_infeasible_MIN_SENSE",
            "test_infeasible_MIN_SENSE_offset",
            "test_infeasible_affine_MAX_SENSE",
            "test_infeasible_affine_MAX_SENSE_offset",
            "test_infeasible_affine_MIN_SENSE",
            "test_infeasible_affine_MIN_SENSE_offset",
            "test_linear_Interval_inactive",
            "test_linear_integration",
            "test_linear_integration_Interval",
            "test_linear_integration_delete_variables",
            "test_linear_transform",
            "test_modification_affine_deletion_edge_cases",
            "test_modification_multirow_vectoraffine_nonpos",
            "test_modification_set_scalaraffine_lessthan",
            "test_variable_solve_with_lowerbound",
            "test_variable_solve_with_upperbound",
            # TODO: inaccurate solution
            "test_linear_HyperRectangle_VectorAffineFunction",
            "test_linear_HyperRectangle_VectorOfVariables",
        ],
    )
    return
end

end  # module

TestDSDP.runtests()
