function test_sdp(tol)
    dsdp = DSDP.Create(1)
    sdpcone = DSDP.CreateSDPCone(dsdp, 1)
    DSDP.SDPCone.SetBlockSize(sdpcone, 0, 2)
    DSDP.SDPCone.SetSparsity(sdpcone, 0, 0)
    DSDP.SDPCone.SetStorageFormat(sdpcone, 0, UInt8('U'))
    DSDP.SetY0(dsdp, 1, 0.0)
    DSDP.SetDualObjective(dsdp, 1, 1.0)
    DSDP.SDPCone.SetASparseVecMat(sdpcone, 0, 1, 2, 1.0, 0, Int32[2], [0.5], 1)
    DSDP.SDPCone.SetASparseVecMat(sdpcone, 0, 0, 2, 1.0, 0, Int32[0, 3], [0.5, 0.5], 2)
    DSDP.Setup(dsdp)
    DSDP.Solve(dsdp)
    DSDP.ComputeX(dsdp)
    @test DSDP.GetIts(dsdp) == 11
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
    @test DSDP.GetDObjective(dsdp) ≈ 1 rtol = 1e-6
    @test DSDP.GetPObjective(dsdp) ≈ 1 rtol = 1e-6
    DSDP.ComputeX(dsdp)
    @test DSDP.SDPCone.GetXArray(sdpcone, 0) ≈ [1, 0, 1, 1] rtol = 1e-6
end
test_sdp(1e-6)
