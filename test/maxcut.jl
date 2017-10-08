function di(i)
    j = i - Cint(1)
    div(j * i, Cint(2)) + j
end

function maxcut(nnodes, edges)
    nedges = length(edges)
    dsdp = DSDP.Create(nnodes)
    sdpcone = DSDP.CreateSDPCone(dsdp, 1)

    DSDP.SDPConeSetBlockSize(sdpcone, 0, nnodes)


    # Formulate the problem from the data
    # Diagonal elements equal 1.0
    # Create Constraint matrix A_i for i=1, ..., nnodes.
    # that has a single nonzero element.
    diag = ones(Cdouble, nnodes)
    N = Cint(1):Cint(nnodes)
    iptr = di.(N)

    for i in 1:nnodes
        DSDP.SetDualObjective(dsdp, i, 1.0)
        DSDP.SDPConeSetASparseVecMat(sdpcone, 0, i, nnodes, 1.0, 0, pointer(iptr, i), pointer(diag, i), 1)
    end

    # C matrix is the Laplacian of the adjacency matrix
    # Also compute a feasible initial point y such that S >= 0
    yy = zeros(nnodes)
    indd = zeros(Cint, nnodes + nedges)
    val = zeros(nnodes+nedges)
    indd[nedges+(1:nnodes)] = iptr
    tval = 0.0
    for (i, (u, v, w)) in enumerate(edges)
        indd[i] = (u-1) * u / 2 + v-1
        tval += abs(w)
        val[i] = w / 4
        val[nedges+u]-= w/4
        val[nedges+v]-= w/4
        yy[u] -= abs(w/2)
        yy[v] -= abs(w/2)
    end

    DSDP.SDPConeSetASparseVecMat(sdpcone,0,0,nnodes,1.0,0,pointer(indd),pointer(val),nedges)
    DSDP.SDPConeAddASparseVecMat(sdpcone,0,0,nnodes,1.0,0,pointer(indd,nedges+1),pointer(val,nedges+1),nnodes)

    # Initial Point
    DSDP.SetR0(dsdp,0.0)
    DSDP.SetZBar(dsdp,10*tval+1.0)
    for i in 1:nnodes
        DSDP.SetY0(dsdp, i, 10*yy[i])
    end

    # Get read to go
    DSDP.SetGapTolerance(dsdp, 0.001)
    DSDP.SetPotentialParameter(dsdp, 5)
    DSDP.ReuseMatrix(dsdp, 0)
    DSDP.SetPNormTolerance(dsdp, 1.0)
    #info = TCheckArgs(dsdp,argc,argv)

    DSDP.SetStandardMonitor(dsdp,1)

    DSDP.Setup(dsdp)

    info = DSDP.Solve(dsdp)
    iszero(info) || error("Numerical error")
    reason = DSDP.StopReason(dsdp)

    if reason != DSDP.DSDP_INFEASIBLE_START
        # Randomized solution strategy
#        info=MaxCutRandomized(sdpcone,nnodes)
#        if false # Look at the solution
#            int n; double *xx,*y=diag
#            info = DSDPGetY(dsdp, y, nnodes)
#            info = DSDPComputeX(dsdp)
#            DSDPCHKERR(info)
#            info = SDPConeGetXArray(sdpcone,0,&xx,&n)
#        end
    end
    info = DSDP.Destroy(dsdp)
end

maxcut(1, [(1, 1, 1)])


#    # Initial Point
#    info = DSDPSetR0(dsdp,0.0)
#    info = DSDPSetZBar(dsdp,10*tval+1.0)
#    for i in 1:nnodes
#        info = DSDPSetY0(dsdp, i+1, 10*yy[i])
#    end
#    iszero(info) || return info
#
#    # Get read to go
#    info = DSDPSetGapTolerance(dsdp, 0.001)
#    info = DSDPSetPotentialParameter(dsdp, 5)
#    info = DSDPReuseMatrix(dsdp, 0)
#    info = DSDPSetPNormTolerance(dsdp, 1.0)
#    #info = TCheckArgs(dsdp,argc,argv)
#
#    iszero(info) || error("Out of memory")
#    info = DSDPSetStandardMonitor(dsdp,1)
#
#    info = DSDPSetup(dsdp)
#    iszero(info) || error("Out of memory")
#
#    info = DSDPSolve(dsdp)
#    iszero(info) || error("Numerical error")
#    info = DSDPStopReason(dsdp, &reason)
#
#    if reason != DSDP_INFEASIBLE_START
#        # Randomized solution strategy
#        info=MaxCutRandomized(sdpcone,nnodes)
#        if false # Look at the solution
#            int n; double *xx,*y=diag
#            info = DSDPGetY(dsdp, y, nnodes)
#            info = DSDPComputeX(dsdp)
#            DSDPCHKERR(info)
#            info = SDPConeGetXArray(sdpcone,0,&xx,&n)
#        end
#    end
#    info = DSDPDestroy(dsdp)
#end
#
#signz(t) = t < 0 ? -1 : 1
#
## maxcutrandomized(sdpcone::SDPCone, nnodes::Int)
## Apply the Goemens and Williamson randomized cut algorithm to the SDP relaxation of the max-cut problem
## sdpcone the SDP cone
## nnodes number of nodes in the graph
#function maxcutrandomized(sdpcone::SDPCone, nnodes::Int)
#    ymin = 0
#
#    vv = Vector{Cdouble}(nnodes)
#    tt = Vector{Cdouble}(nnodes)
#    cc = Vector{Cdouble}(nnodes+2)
#    info = SDPConeComputeXV(sdpcone, 0, &derror)
#    for i in 1:nnodes
#        for j in 1:nnodes
#            dd = rand() - .5
#            vv[j] = tan(pi*dd)
#        end
#        info = SDPConeXVMultiply(sdpcone, 0, vv, tt, nnodes)
#        map!(signz, tt)
#        map!(zero, cc)
#        info = SDPConeAddXVAV(sdpcone, 0, tt, nnodes, cc, nnodes+2)
#        if cc[1] < ymin
#            ymin = cc[1]
#        end
#    end
#    printf("Best integer solution: %4.2f\n",ymin);
#end
