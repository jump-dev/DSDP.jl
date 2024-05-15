using Test, DSDP

function test_sdp(tol = 1e-6)
    dsdp = DSDP.Create(1)
    sdpcone = DSDP.CreateSDPCone(dsdp, 1)
    DSDP.SDPCone.SetBlockSize(sdpcone, 0, 2)
    DSDP.SDPCone.SetSparsity(sdpcone, 0, 0)
    DSDP.SDPCone.SetStorageFormat(sdpcone, 0, UInt8('U'))
    DSDP.SetY0(dsdp, 1, 0.0)
    DSDP.SetDualObjective(dsdp, 1, 1.0)
    DSDP.SDPCone.SetASparseVecMat(sdpcone, 0, 1, 2, 1.0, 0, Int32[2], [0.5], 1)
    DSDP.SDPCone.SetASparseVecMat(sdpcone, 0, 0, 2, 1.0, 0, Int32[0, 3], [1.0, 1.0], 2)
    DSDP.Setup(dsdp)
    DSDP.Solve(dsdp)
    DSDP.ComputeX(dsdp)
    @test DSDP.GetIts(dsdp) == 10
    derr = DSDP.GetFinalErrors(dsdp)
    @test derr != zeros(Cdouble, 6) # To check that it's not just the allocated vector and we actually got the errors
    @test derr ≈ zeros(Cdouble, 6) atol = tol
    
    # P Infeasible: derr[1]
    # D Infeasible: derr[3]
    # Minimal P Eigenvalue: derr[2]
    # Minimal D Eigenvalue: 0.00, see `DSDP` source in `examples/readsdpa.c`
    # Relative P - D Objective values: derr[5]
    # Relative X Dot S: %4.2e: derr[6]
    
    @test DSDP.StopReason(dsdp) == 1
    @test DSDP.GetSolutionType(dsdp) == 1
    @test DSDP.GetDObjective(dsdp) ≈ 2 rtol = tol
    @test DSDP.GetPObjective(dsdp) ≈ 2 rtol = tol
    @test DSDP.SDPCone.GetXArray(sdpcone, 0) ≈ [1, 0, 1, 1] rtol = tol
    @test DSDP.GetNumberOfVariables(dsdp) == 1
    @test DSDP.SDPCone.GetNumberOfBlocks(sdpcone) == 1
    y = zeros(Cdouble, 1)
    DSDP.GetY(dsdp, y)
    @test y[1] ≈ 2 rtol = tol
    return
end

import MathOptInterface as MOI

function test_moi(tol = 1e-6)
    model = MOI.Utilities.Model{Float64}()
    X, _ = MOI.add_constrained_variables(model, MOI.PositiveSemidefiniteConeTriangle(2))
    c = MOI.add_constraint(model, 1.0 * X[2], MOI.EqualTo(1.0))
    obj = 1.0 * X[1] + 1.0 * X[3]
    MOI.set(model, MOI.ObjectiveSense(), MOI.MIN_SENSE)
    MOI.set(
        model,
        MOI.ObjectiveFunction{typeof(obj)}(),
        obj,
    )
    dsdp = DSDP.Optimizer()
    MOI.copy_to(dsdp, model)
    MOI.optimize!(dsdp)
    @test MOI.get(dsdp, MOI.ObjectiveValue()) ≈ 2 rtol = tol
    @test MOI.get(dsdp, MOI.DualObjectiveValue()) ≈ 2 rtol = tol
    @test MOI.get.(dsdp, MOI.VariablePrimal(), X) ≈ [1, 1, 1] rtol = tol
    @test MOI.get(dsdp, MOI.ConstraintDual(), c) ≈ 2 rtol = tol
    return
end

@testset "SDP example" begin
    test_sdp()
    test_moi()
end
