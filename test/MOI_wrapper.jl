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
        include = [r"test_conic_PositiveSemidefiniteConeTriangle_VectorOfVariables$"],
#        exclude = Regex[
#            # ArgumentError: DSDP does not support problems with no constraint.
#            # See https://github.com/jump-dev/MathOptInterface.jl/issues/1741#issuecomment-1057286739
#            r"test_solve_optimize_twice$",
#            r"test_solve_result_index$",
#            r"test_objective_ObjectiveFunction_constant$",
#            r"test_objective_ObjectiveFunction_VariableIndex$",
#            r"test_objective_FEASIBILITY_SENSE_clears_objective$",
#            r"test_modification_transform_singlevariable_lessthan$",
#            r"test_modification_set_singlevariable_lessthan$",
#            r"test_modification_delete_variables_in_a_batch$",
#            r"test_modification_delete_variable_with_single_variable_obj$",
#            r"test_modification_const_scalar_objective$",
#            r"test_modification_coef_scalar_objective$",
#            r"test_attribute_RawStatusString$",
#            r"test_attribute_SolveTimeSec$",
#            r"test_objective_ObjectiveFunction_blank$",
#            r"test_objective_ObjectiveFunction_duplicate_terms$",
#            r"test_solve_TerminationStatus_DUAL_INFEASIBLE$",
#            # TODO investigate
#            #  Expression: MOI.get(model, MOI.TerminationStatus()) == config.infeasible_status
#            #   Evaluated: MathOptInterface.OPTIMAL == MathOptInterface.INFEASIBLE
#            r"test_conic_NormInfinityCone_INFEASIBLE$",
#            r"test_conic_NormOneCone_INFEASIBLE$",
#            r"test_conic_linear_INFEASIBLE$",
#            r"test_conic_linear_INFEASIBLE_2$",
#            r"test_solve_DualStatus_INFEASIBILITY_CERTIFICATE_EqualTo_lower$",
#            r"test_solve_DualStatus_INFEASIBILITY_CERTIFICATE_EqualTo_upper$",
#            r"test_solve_DualStatus_INFEASIBILITY_CERTIFICATE_GreaterThan$",
#            r"test_solve_DualStatus_INFEASIBILITY_CERTIFICATE_Interval_lower$",
#            r"test_solve_DualStatus_INFEASIBILITY_CERTIFICATE_Interval_upper$",
#            r"test_solve_DualStatus_INFEASIBILITY_CERTIFICATE_LessThan$",
#            r"test_solve_DualStatus_INFEASIBILITY_CERTIFICATE_VariableIndex_LessThan$",
#            # TODO investigate
#            # Incorrect result value
#            r"test_conic_NormInfinityCone_3$",
#            r"test_conic_NormInfinityCone_VectorAffineFunction$",
#            r"test_conic_NormInfinityCone_VectorOfVariables$",
#            r"test_conic_NormOneCone$",
#            r"test_conic_NormOneCone_VectorAffineFunction$",
#            r"test_conic_NormOneCone_VectorOfVariables$",
#            r"test_conic_linear_VectorAffineFunction$",
#            r"test_conic_linear_VectorAffineFunction_2$",
#            r"test_conic_linear_VectorOfVariables$",
#            r"test_conic_linear_VectorOfVariables_2$",
#            r"test_constraint_ScalarAffineFunction_Interval$",
#            r"test_linear_variable_open_intervals$",
#            # Incorrect objective
#            # See https://github.com/jump-dev/MathOptInterface.jl/issues/1759
#            r"test_infeasible_MAX_SENSE$",
#            r"test_infeasible_MAX_SENSE_offset$",
#            r"test_infeasible_MIN_SENSE$",
#            r"test_infeasible_MIN_SENSE_offset$",
#            r"test_infeasible_affine_MAX_SENSE$",
#            r"test_infeasible_affine_MAX_SENSE_offset$",
#            r"test_infeasible_affine_MIN_SENSE$",
#            r"test_infeasible_affine_MIN_SENSE_offset$",
#            r"test_linear_Interval_inactive$",
#            r"test_linear_integration$",
#            r"test_linear_integration_Interval$",
#            r"test_linear_integration_delete_variables$",
#            r"test_linear_transform$",
#            r"test_modification_affine_deletion_edge_cases$",
#            r"test_modification_multirow_vectoraffine_nonpos$",
#            r"test_modification_set_scalaraffine_lessthan$",
#            r"test_variable_solve_with_lowerbound$",
#            r"test_variable_solve_with_upperbound$",
#            # TODO: inaccurate solution
#            r"test_linear_HyperRectangle_VectorAffineFunction$",
#            r"test_linear_HyperRectangle_VectorOfVariables$",
#        ],
    )
    return
end

end  # module

TestDSDP.runtests()
