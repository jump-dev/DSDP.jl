# Copyright (c) 2022: Joey Huchette, Benoît Legat, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

module Test_c_api

using DSDP
using Test

function di(u, v)
    u, v = max(u, v), min(u, v)
    return div((u - Cint(1)) * u, Cint(2)) + (v - Cint(1))
end
di(u) = di(u, u)

signz(t) = t < 0 ? -1 : 1

# Apply the Goemens and Williamson randomized cut algorithm to the SDP relaxation of the max-cut problem
function MaxCutRandomized(sdpcone, nnodes::Integer)
    ymin = Cdouble(0)
    vv = Vector{Cdouble}(undef, nnodes)
    tt = Vector{Cdouble}(undef, nnodes)
    cc = Vector{Cdouble}(undef, nnodes + 2)
    derror = Ref{Cint}()
    DSDP.SDPConeComputeXV(sdpcone, 0, derror)
    @assert derror[] == 0
    for i in 1:nnodes
        for j in eachindex(vv)
            dd = rand() - 0.5
            vv[j] = tan(π * dd)
        end
        DSDP.SDPConeXVMultiply(sdpcone, 0, vv, tt, nnodes)
        map!(signz, tt, tt)
        map!(zero, cc, cc)
        DSDP.SDPConeAddXVAV(sdpcone, 0, tt, nnodes, cc, nnodes + 2)
        if cc[1] < ymin
            ymin = cc[1]
        end
    end
    return ymin
end

function maxcut(nnodes, edges)
    nedges = length(edges)
    p = Ref{Ptr{Cvoid}}()
    DSDP.DSDPCreate(nnodes, p)
    dsdp = p[]
    DSDP.DSDPCreateSDPCone(dsdp, 1, p)
    sdpcone = p[]
    DSDP.SDPConeSetBlockSize(sdpcone, 0, nnodes)
    # Formulate the problem from the data
    # Diagonal elements equal 1.0
    # Create Constraint matrix A_i for i=1, ..., nnodes.
    # that has a single nonzero element.
    diag = ones(Cdouble, nnodes)
    N = Cint(1):Cint(nnodes)
    iptr = di.(N)
    for i in 1:nnodes
        DSDP.DSDPSetDualObjective(dsdp, i, 1.0)
        DSDP.SDPConeSetASparseVecMat(
            sdpcone,
            0,
            i,
            nnodes,
            1.0,
            0,
            pointer(iptr, i),
            pointer(diag, i),
            1,
        )
    end
    # C matrix is the Laplacian of the adjacency matrix
    # Also compute a feasible initial point y such that S >= 0
    yy = zeros(nnodes)
    indd = zeros(Cint, nnodes + nedges)
    val = zeros(nnodes + nedges)
    indd[nedges .+ (1:nnodes)] = iptr
    tval = 0.0
    for (i, (u, v, w)) in enumerate(edges)
        indd[i] = di(u, v)
        tval += abs(w)
        val[i] = w / 4
        val[nedges+u] -= w / 4
        val[nedges+v] -= w / 4
        yy[u] -= abs(w / 2)
        yy[v] -= abs(w / 2)
    end
    DSDP.SDPConeSetASparseVecMat(
        sdpcone,
        0,
        0,
        nnodes,
        1.0,
        0,
        pointer(indd),
        pointer(val),
        nedges,
    )
    DSDP.SDPConeAddASparseVecMat(
        sdpcone,
        0,
        0,
        nnodes,
        1.0,
        0,
        pointer(indd, nedges + 1),
        pointer(val, nedges + 1),
        nnodes,
    )
    # Initial Point
    DSDP.DSDPSetR0(dsdp, 0.0)
    DSDP.DSDPSetZBar(dsdp, 10 * tval + 1.0)
    for i in 1:nnodes
        DSDP.DSDPSetY0(dsdp, i, 10 * yy[i])
    end
    # Get read to go
    DSDP.DSDPSetGapTolerance(dsdp, 0.001)
    DSDP.DSDPSetPotentialParameter(dsdp, 5)
    DSDP.DSDPSetReuseMatrix(dsdp, 0)
    DSDP.DSDPSetPNormTolerance(dsdp, 1.0)
    #info = TCheckArgs(dsdp,argc,argv)
    DSDP.DSDPSetStandardMonitor(dsdp, 0)
    DSDP.DSDPSetup(dsdp)
    DSDP.DSDPSolve(dsdp)
    stop = Ref{DSDP.DSDPTerminationReason}()
    DSDP.DSDPStopReason(dsdp, stop)
    reason = stop[]
    @test reason != DSDP.DSDP_INFEASIBLE_START
    ret = Ref{Cdouble}()
    DSDP.DSDPGetDObjective(dsdp, ret)
    @test ret[] ≈ -9.250079 rtol = 1e-7
    DSDP.DSDPGetDDObjective(dsdp, ret)
    @test ret[] ≈ -9.250079 rtol = 1e-7
    DSDP.DSDPGetPObjective(dsdp, ret)
    @test ret[] ≈ 1e10
    DSDP.DSDPGetPPObjective(dsdp, ret)
    @test ret[] ≈ -9.240522 rtol = 1e-7
    DSDP.DSDPGetDualityGap(dsdp, ret)
    @test ret[] ≈ 0.009557113 rtol = 1e-7
    # Randomized solution strategy
    @test MaxCutRandomized(sdpcone, nnodes) ≈ -9.25
    return DSDP.DSDPDestroy(dsdp)
end

function test_sdp(tol = 1e-6)
    p = Ref{Ptr{Cvoid}}()
    DSDP.DSDPCreate(1, p)
    dsdp = p[]
    DSDP.DSDPCreateSDPCone(dsdp, 1, p)
    sdpcone = p[]
    DSDP.SDPConeSetBlockSize(sdpcone, 0, 2)
    DSDP.SDPConeSetSparsity(sdpcone, 0, 0)
    DSDP.SDPConeSetStorageFormat(sdpcone, 0, UInt8('U'))
    DSDP.DSDPSetY0(dsdp, 1, 0.0)
    DSDP.DSDPSetDualObjective(dsdp, 1, 1.0)
    DSDP.SDPConeSetASparseVecMat(sdpcone, 0, 1, 2, 1.0, 0, Int32[2], [0.5], 1)
    DSDP.SDPConeSetASparseVecMat(
        sdpcone,
        0,
        0,
        2,
        1.0,
        0,
        Int32[0, 3],
        [1.0, 1.0],
        2,
    )
    DSDP.DSDPSetup(dsdp)
    DSDP.DSDPSolve(dsdp)
    DSDP.DSDPComputeX(dsdp)
    ret = Ref{Cint}()
    DSDP.DSDPGetIts(dsdp, ret)
    @test ret[] == 10
    derr = zeros(Cdouble, 6)
    DSDP.DSDPGetFinalErrors(dsdp, derr)
    @test derr != zeros(Cdouble, 6) # To check that it's not just the allocated vector and we actually got the errors
    @test derr ≈ zeros(Cdouble, 6) atol = tol
    # P Infeasible: derr[1]
    # D Infeasible: derr[3]
    # Minimal P Eigenvalue: derr[2]
    # Minimal D Eigenvalue: 0.00, see `DSDP` source in `examples/readsdpa.c`
    # Relative P - D Objective values: derr[5]
    # Relative X Dot S: %4.2e: derr[6]
    stop = Ref{DSDP.DSDPTerminationReason}()
    DSDP.DSDPStopReason(dsdp, stop)
    @test stop[] == 1
    sol = Ref{DSDP.DSDPSolutionType}()
    DSDP.DSDPGetSolutionType(dsdp, sol)
    @test sol[] == 1
    ret = Ref{Cdouble}()
    DSDP.DSDPGetDObjective(dsdp, ret)
    @test ret[] ≈ 2 rtol = tol
    DSDP.DSDPGetPObjective(dsdp, ret)
    @test ret[] ≈ 2 rtol = tol
    xmat = Ref{Ptr{Cdouble}}()
    nn = Ref{Cint}()
    DSDP.SDPConeGetXArray(sdpcone, 0, xmat, nn)
    @test unsafe_wrap(Array, xmat[], nn[]) ≈ [1, 0, 1, 1] rtol = tol
    num = Ref{Cint}()
    DSDP.DSDPGetNumberOfVariables(dsdp, num)
    @test num[] == 1
    DSDP.SDPConeGetNumberOfBlocks(sdpcone, num)
    @test num[] == 1
    y = zeros(Cdouble, 1)
    DSDP.DSDPGetY(dsdp, y, 1)
    @test y[1] ≈ 2 rtol = tol
    return
end

@testset "SDP example" begin
    test_sdp()
end

@testset "DSDP MaxCut example" begin
    nnodes = 6
    edges = [
        (1, 2, 0.3)
        (1, 4, 2.7)
        (1, 6, 1.5)
        (2, 3, -1.0)
        (2, 5, 1.45)
        (3, 4, -0.2)
        (4, 5, 1.2)
        (5, 6, 2.1)
    ]
    maxcut(nnodes, edges)
end

@testset "LPConeSetData doc example" begin
    lpdvars = Cint[3, 3, 2, 2, 1, 3, 1, 1]
    lpdrows = Cint[2, 0, 1, 0, 0, 1, 1, 2]
    lpcoefs = Cdouble[-1, 2, 3, 4, 6, 7, 10, 12]
    nnzin, row, aval = DSDP._build_lp(3, lpdvars, lpdrows, lpcoefs)
    @test nnzin isa Vector{Cint}
    @test nnzin == [0, 3, 5, 8]
    @test row isa Vector{Cint}
    @test row == [0, 1, 2, 0, 1, 0, 1, 2]
    @test aval isa Vector{Cdouble}
    @test aval == [6, 10, 12, 4, 3, 2, 7, -1]
end

end  # module
