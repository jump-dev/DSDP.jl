# Copyright (c) 2022: Joey Huchette, Benoît Legat, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

# Disable JuliaFormatter for this file.
#!format:off

function DSDPError(arg1, arg2, arg3)
    @ccall libdsdp.DSDPError(arg1::Ptr{Cchar}, arg2::Cint, arg3::Ptr{Cchar})::Cvoid
end

function DSDPSetBarrierParameter(arg1, arg2)
    @ccall libdsdp.DSDPSetBarrierParameter(arg1::Ptr{Cvoid}, arg2::Cdouble)::Cint
end

function DSDPGetBarrierParameter(arg1, arg2)
    @ccall libdsdp.DSDPGetBarrierParameter(arg1::Ptr{Cvoid}, arg2::Ptr{Cdouble})::Cint
end

@cenum DSDPTruth::UInt32 begin
    DSDP_FALSE = 0
    DSDP_TRUE = 1
end

@cenum DSDPDualFactorMatrix::UInt32 begin
    DUAL_FACTOR = 1
    PRIMAL_FACTOR = 2
end

@cenum DSDPPenalty::UInt32 begin
    DSDPAlways = 1
    DSDPNever = 2
    DSDPInfeasible = 0
end

@cenum DSDPSolutionType::UInt32 begin
    DSDP_PDUNKNOWN = 0
    DSDP_PDFEASIBLE = 1
    DSDP_UNBOUNDED = 3
    DSDP_INFEASIBLE = 4
end

@cenum DSDPTerminationReason::Int32 begin
    DSDP_CONVERGED = 1
    DSDP_INFEASIBLE_START = -6
    DSDP_SMALL_STEPS = -2
    DSDP_INDEFINITE_SCHUR_MATRIX = -8
    DSDP_MAX_IT = -3
    DSDP_NUMERICAL_ERROR = -9
    DSDP_UPPERBOUND = 5
    DSDP_USER_TERMINATION = 7
    CONTINUE_ITERATING = 0
end

function DSDPSetConvergenceFlag(arg1, arg2)
    @ccall libdsdp.DSDPSetConvergenceFlag(arg1::Ptr{Cvoid}, arg2::DSDPTerminationReason)::Cint
end

function DSDPTime(arg1)
    @ccall libdsdp.DSDPTime(arg1::Ptr{Cdouble})::Cvoid
end

function DSDPLogInfoAllow(arg1, arg2)
    @ccall libdsdp.DSDPLogInfoAllow(arg1::Cint, arg2::Ptr{Cchar})::Cint
end

function DSDPMemoryLog()
    @ccall libdsdp.DSDPMemoryLog()::Cvoid
end

function DSDPEventLogBegin(arg1)
    @ccall libdsdp.DSDPEventLogBegin(arg1::Cint)::Cint
end

function DSDPEventLogEnd(arg1)
    @ccall libdsdp.DSDPEventLogEnd(arg1::Cint)::Cint
end

function DSDPEventLogRegister(arg1, arg2)
    @ccall libdsdp.DSDPEventLogRegister(arg1::Ptr{Cchar}, arg2::Ptr{Cint})::Cint
end

function DSDPEventLogInitialize()
    @ccall libdsdp.DSDPEventLogInitialize()::Cint
end

function DSDPEventLogSummary()
    @ccall libdsdp.DSDPEventLogSummary()::Cint
end

function DSDPMMalloc(arg1, arg2, arg3)
    @ccall libdsdp.DSDPMMalloc(arg1::Ptr{Cchar}, arg2::Csize_t, arg3::Ptr{Ptr{Cvoid}})::Cint
end

function DSDPFFree(arg1)
    @ccall libdsdp.DSDPFFree(arg1::Ptr{Ptr{Cvoid}})::Cint
end

function DSDPCreate(arg1, arg2)
    @ccall libdsdp.DSDPCreate(arg1::Cint, arg2::Ptr{Ptr{Cvoid}})::Cint
end

function DSDPSetup(arg1)
    @ccall libdsdp.DSDPSetup(arg1::Ptr{Cvoid})::Cint
end

function DSDPSolve(arg1)
    @ccall libdsdp.DSDPSolve(arg1::Ptr{Cvoid})::Cint
end

function DSDPComputeX(arg1)
    @ccall libdsdp.DSDPComputeX(arg1::Ptr{Cvoid})::Cint
end

function DSDPComputeAndFactorS(arg1, arg2)
    @ccall libdsdp.DSDPComputeAndFactorS(arg1::Ptr{Cvoid}, arg2::Ptr{DSDPTruth})::Cint
end

function DSDPDestroy(arg1)
    @ccall libdsdp.DSDPDestroy(arg1::Ptr{Cvoid})::Cint
end

function DSDPCreateBCone(arg1, arg2)
    @ccall libdsdp.DSDPCreateBCone(arg1::Ptr{Cvoid}, arg2::Ptr{Ptr{Cvoid}})::Cint
end

function BConeAllocateBounds(arg1, arg2)
    @ccall libdsdp.BConeAllocateBounds(arg1::Ptr{Cvoid}, arg2::Cint)::Cint
end

function BConeSetLowerBound(arg1, arg2, arg3)
    @ccall libdsdp.BConeSetLowerBound(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Cdouble)::Cint
end

function BConeSetUpperBound(arg1, arg2, arg3)
    @ccall libdsdp.BConeSetUpperBound(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Cdouble)::Cint
end

function BConeSetPSlackVariable(arg1, arg2)
    @ccall libdsdp.BConeSetPSlackVariable(arg1::Ptr{Cvoid}, arg2::Cint)::Cint
end

function BConeSetPSurplusVariable(arg1, arg2)
    @ccall libdsdp.BConeSetPSurplusVariable(arg1::Ptr{Cvoid}, arg2::Cint)::Cint
end

function BConeScaleBarrier(arg1, arg2)
    @ccall libdsdp.BConeScaleBarrier(arg1::Ptr{Cvoid}, arg2::Cdouble)::Cint
end

function BConeView(arg1)
    @ccall libdsdp.BConeView(arg1::Ptr{Cvoid})::Cint
end

function BConeSetXArray(arg1, arg2, arg3)
    @ccall libdsdp.BConeSetXArray(arg1::Ptr{Cvoid}, arg2::Ptr{Cdouble}, arg3::Cint)::Cint
end

function BConeCopyX(arg1, arg2, arg3, arg4)
    @ccall libdsdp.BConeCopyX(arg1::Ptr{Cvoid}, arg2::Ptr{Cdouble}, arg3::Ptr{Cdouble}, arg4::Cint)::Cint
end

function DSDPBoundDualVariables(arg1, arg2, arg3)
    @ccall libdsdp.DSDPBoundDualVariables(arg1::Ptr{Cvoid}, arg2::Cdouble, arg3::Cdouble)::Cint
end

function DSDPSetYBounds(arg1, arg2, arg3)
    @ccall libdsdp.DSDPSetYBounds(arg1::Ptr{Cvoid}, arg2::Cdouble, arg3::Cdouble)::Cint
end

function DSDPGetYBounds(arg1, arg2, arg3)
    @ccall libdsdp.DSDPGetYBounds(arg1::Ptr{Cvoid}, arg2::Ptr{Cdouble}, arg3::Ptr{Cdouble})::Cint
end

function DSDPCreateLPCone(arg1, arg2)
    @ccall libdsdp.DSDPCreateLPCone(arg1::Ptr{Cvoid}, arg2::Ptr{Ptr{Cvoid}})::Cint
end

function LPConeSetData(arg1, arg2, arg3, arg4, arg5)
    @ccall libdsdp.LPConeSetData(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Ptr{Cint}, arg4::Ptr{Cint}, arg5::Ptr{Cdouble})::Cint
end

function LPConeSetData2(arg1, arg2, arg3, arg4, arg5)
    @ccall libdsdp.LPConeSetData2(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Ptr{Cint}, arg4::Ptr{Cint}, arg5::Ptr{Cdouble})::Cint
end

function LPConeGetData(arg1, arg2, arg3, arg4)
    @ccall libdsdp.LPConeGetData(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Ptr{Cdouble}, arg4::Cint)::Cint
end

function LPConeScaleBarrier(arg1, arg2)
    @ccall libdsdp.LPConeScaleBarrier(arg1::Ptr{Cvoid}, arg2::Cdouble)::Cint
end

function LPConeGetXArray(arg1, arg2, arg3)
    @ccall libdsdp.LPConeGetXArray(arg1::Ptr{Cvoid}, arg2::Ptr{Ptr{Cdouble}}, arg3::Ptr{Cint})::Cint
end

function LPConeGetSArray(arg1, arg2, arg3)
    @ccall libdsdp.LPConeGetSArray(arg1::Ptr{Cvoid}, arg2::Ptr{Ptr{Cdouble}}, arg3::Ptr{Cint})::Cint
end

function LPConeGetDimension(arg1, arg2)
    @ccall libdsdp.LPConeGetDimension(arg1::Ptr{Cvoid}, arg2::Ptr{Cint})::Cint
end

function LPConeView(lpcone)
    @ccall libdsdp.LPConeView(lpcone::Ptr{Cvoid})::Cint
end

function LPConeView2(lpcone)
    @ccall libdsdp.LPConeView2(lpcone::Ptr{Cvoid})::Cint
end

function LPConeCopyS(arg1, arg2, arg3)
    @ccall libdsdp.LPConeCopyS(arg1::Ptr{Cvoid}, arg2::Ptr{Cdouble}, arg3::Cint)::Cint
end

function DSDPCreateSDPCone(arg1, arg2, arg3)
    @ccall libdsdp.DSDPCreateSDPCone(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Ptr{Ptr{Cvoid}})::Cint
end

function SDPConeSetBlockSize(arg1, arg2, arg3)
    @ccall libdsdp.SDPConeSetBlockSize(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Cint)::Cint
end

function SDPConeGetBlockSize(arg1, arg2, arg3)
    @ccall libdsdp.SDPConeGetBlockSize(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Ptr{Cint})::Cint
end

function SDPConeSetStorageFormat(arg1, arg2, arg3)
    @ccall libdsdp.SDPConeSetStorageFormat(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Cchar)::Cint
end

function SDPConeGetStorageFormat(arg1, arg2, arg3)
    @ccall libdsdp.SDPConeGetStorageFormat(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Ptr{Cchar})::Cint
end

function SDPConeCheckStorageFormat(arg1, arg2, arg3)
    @ccall libdsdp.SDPConeCheckStorageFormat(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Cchar)::Cint
end

function SDPConeSetSparsity(arg1, arg2, arg3)
    @ccall libdsdp.SDPConeSetSparsity(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Cint)::Cint
end

function SDPConeView(arg1)
    @ccall libdsdp.SDPConeView(arg1::Ptr{Cvoid})::Cint
end

function SDPConeView2(arg1)
    @ccall libdsdp.SDPConeView2(arg1::Ptr{Cvoid})::Cint
end

function SDPConeView3(arg1)
    @ccall libdsdp.SDPConeView3(arg1::Ptr{Cvoid})::Cint
end

function SDPConeSetASparseVecMat(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    @ccall libdsdp.SDPConeSetASparseVecMat(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Cint, arg4::Cint, arg5::Cdouble, arg6::Cint, arg7::Ptr{Cint}, arg8::Ptr{Cdouble}, arg9::Cint)::Cint
end

function SDPConeSetADenseVecMat(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
    @ccall libdsdp.SDPConeSetADenseVecMat(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Cint, arg4::Cint, arg5::Cdouble, arg6::Ptr{Cdouble}, arg7::Cint)::Cint
end

function SDPConeSetARankOneMat(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    @ccall libdsdp.SDPConeSetARankOneMat(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Cint, arg4::Cint, arg5::Cdouble, arg6::Cint, arg7::Ptr{Cint}, arg8::Ptr{Cdouble}, arg9::Cint)::Cint
end

function SDPConeSetConstantMat(arg1, arg2, arg3, arg4, arg5)
    @ccall libdsdp.SDPConeSetConstantMat(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Cint, arg4::Cint, arg5::Cdouble)::Cint
end

function SDPConeSetZeroMat(arg1, arg2, arg3, arg4)
    @ccall libdsdp.SDPConeSetZeroMat(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Cint, arg4::Cint)::Cint
end

function SDPConeSetIdentity(arg1, arg2, arg3, arg4, arg5)
    @ccall libdsdp.SDPConeSetIdentity(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Cint, arg4::Cint, arg5::Cdouble)::Cint
end

function SDPConeViewDataMatrix(arg1, arg2, arg3)
    @ccall libdsdp.SDPConeViewDataMatrix(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Cint)::Cint
end

function SDPConeMatrixView(arg1, arg2)
    @ccall libdsdp.SDPConeMatrixView(arg1::Ptr{Cvoid}, arg2::Cint)::Cint
end

function SDPConeAddASparseVecMat(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    @ccall libdsdp.SDPConeAddASparseVecMat(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Cint, arg4::Cint, arg5::Cdouble, arg6::Cint, arg7::Ptr{Cint}, arg8::Ptr{Cdouble}, arg9::Cint)::Cint
end

function SDPConeAddADenseVecMat(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
    @ccall libdsdp.SDPConeAddADenseVecMat(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Cint, arg4::Cint, arg5::Cdouble, arg6::Ptr{Cdouble}, arg7::Cint)::Cint
end

function SDPConeAddConstantMat(arg1, arg2, arg3, arg4, arg5)
    @ccall libdsdp.SDPConeAddConstantMat(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Cint, arg4::Cint, arg5::Cdouble)::Cint
end

function SDPConeAddIdentity(arg1, arg2, arg3, arg4, arg5)
    @ccall libdsdp.SDPConeAddIdentity(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Cint, arg4::Cint, arg5::Cdouble)::Cint
end

function SDPConeAddARankOneMat(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    @ccall libdsdp.SDPConeAddARankOneMat(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Cint, arg4::Cint, arg5::Cdouble, arg6::Cint, arg7::Ptr{Cint}, arg8::Ptr{Cdouble}, arg9::Cint)::Cint
end

function SDPConeAddSparseVecMat(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
    @ccall libdsdp.SDPConeAddSparseVecMat(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Cint, arg4::Cint, arg5::Cint, arg6::Ptr{Cint}, arg7::Ptr{Cdouble}, arg8::Cint)::Cint
end

function SDPConeAddDenseVecMat(arg1, arg2, arg3, arg4, arg5, arg6)
    @ccall libdsdp.SDPConeAddDenseVecMat(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Cint, arg4::Cint, arg5::Ptr{Cdouble}, arg6::Cint)::Cint
end

function SDPConeSetSparseVecMat(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
    @ccall libdsdp.SDPConeSetSparseVecMat(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Cint, arg4::Cint, arg5::Cint, arg6::Ptr{Cint}, arg7::Ptr{Cdouble}, arg8::Cint)::Cint
end

function SDPConeSetDenseVecMat(arg1, arg2, arg3, arg4, arg5, arg6)
    @ccall libdsdp.SDPConeSetDenseVecMat(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Cint, arg4::Cint, arg5::Ptr{Cdouble}, arg6::Cint)::Cint
end

function SDPConeSetXMat(arg1, arg2, arg3)
    @ccall libdsdp.SDPConeSetXMat(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Cint)::Cint
end

function SDPConeSetXArray(arg1, arg2, arg3, arg4, arg5)
    @ccall libdsdp.SDPConeSetXArray(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Cint, arg4::Ptr{Cdouble}, arg5::Cint)::Cint
end

function SDPConeGetXArray(arg1, arg2, arg3, arg4)
    @ccall libdsdp.SDPConeGetXArray(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Ptr{Ptr{Cdouble}}, arg4::Ptr{Cint})::Cint
end

function SDPConeRestoreXArray(arg1, arg2, arg3, arg4)
    @ccall libdsdp.SDPConeRestoreXArray(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Ptr{Ptr{Cdouble}}, arg4::Ptr{Cint})::Cint
end

function SDPConeCheckData(arg1)
    @ccall libdsdp.SDPConeCheckData(arg1::Ptr{Cvoid})::Cint
end

function SDPConeRemoveDataMatrix(arg1, arg2, arg3)
    @ccall libdsdp.SDPConeRemoveDataMatrix(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Cint)::Cint
end

function SDPConeGetNumberOfBlocks(arg1, arg2)
    @ccall libdsdp.SDPConeGetNumberOfBlocks(arg1::Ptr{Cvoid}, arg2::Ptr{Cint})::Cint
end

function SDPConeComputeS(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    @ccall libdsdp.SDPConeComputeS(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Cdouble, arg4::Ptr{Cdouble}, arg5::Cint, arg6::Cdouble, arg7::Cint, arg8::Ptr{Cdouble}, arg9::Cint)::Cint
end

function SDPConeComputeX(arg1, arg2, arg3, arg4, arg5)
    @ccall libdsdp.SDPConeComputeX(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Cint, arg4::Ptr{Cdouble}, arg5::Cint)::Cint
end

function SDPConeAddADotX(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
    @ccall libdsdp.SDPConeAddADotX(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Cdouble, arg4::Ptr{Cdouble}, arg5::Cint, arg6::Ptr{Cdouble}, arg7::Cint)::Cint
end

function SDPConeViewX(arg1, arg2, arg3, arg4, arg5)
    @ccall libdsdp.SDPConeViewX(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Cint, arg4::Ptr{Cdouble}, arg5::Cint)::Cint
end

function SDPConeSetLanczosIterations(arg1, arg2)
    @ccall libdsdp.SDPConeSetLanczosIterations(arg1::Ptr{Cvoid}, arg2::Cint)::Cint
end

function SDPConeScaleBarrier(arg1, arg2, arg3)
    @ccall libdsdp.SDPConeScaleBarrier(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Cdouble)::Cint
end

function SDPConeXVMultiply(arg1, arg2, arg3, arg4, arg5)
    @ccall libdsdp.SDPConeXVMultiply(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Ptr{Cdouble}, arg4::Ptr{Cdouble}, arg5::Cint)::Cint
end

function SDPConeComputeXV(arg1, arg2, arg3)
    @ccall libdsdp.SDPConeComputeXV(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Ptr{Cint})::Cint
end

function SDPConeAddXVAV(arg1, arg2, arg3, arg4, arg5, arg6)
    @ccall libdsdp.SDPConeAddXVAV(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Ptr{Cdouble}, arg4::Cint, arg5::Ptr{Cdouble}, arg6::Cint)::Cint
end

function SDPConeUseLAPACKForDualMatrix(arg1, arg2)
    @ccall libdsdp.SDPConeUseLAPACKForDualMatrix(arg1::Ptr{Cvoid}, arg2::Cint)::Cint
end

function DSDPSetDualObjective(arg1, arg2, arg3)
    @ccall libdsdp.DSDPSetDualObjective(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Cdouble)::Cint
end

function DSDPAddObjectiveConstant(arg1, arg2)
    @ccall libdsdp.DSDPAddObjectiveConstant(arg1::Ptr{Cvoid}, arg2::Cdouble)::Cint
end

function DSDPGetDObjective(arg1, arg2)
    @ccall libdsdp.DSDPGetDObjective(arg1::Ptr{Cvoid}, arg2::Ptr{Cdouble})::Cint
end

function DSDPGetDDObjective(arg1, arg2)
    @ccall libdsdp.DSDPGetDDObjective(arg1::Ptr{Cvoid}, arg2::Ptr{Cdouble})::Cint
end

function DSDPGetPObjective(arg1, arg2)
    @ccall libdsdp.DSDPGetPObjective(arg1::Ptr{Cvoid}, arg2::Ptr{Cdouble})::Cint
end

function DSDPGetPPObjective(arg1, arg2)
    @ccall libdsdp.DSDPGetPPObjective(arg1::Ptr{Cvoid}, arg2::Ptr{Cdouble})::Cint
end

function DSDPGetDualityGap(arg1, arg2)
    @ccall libdsdp.DSDPGetDualityGap(arg1::Ptr{Cvoid}, arg2::Ptr{Cdouble})::Cint
end

function DSDPGetScale(arg1, arg2)
    @ccall libdsdp.DSDPGetScale(arg1::Ptr{Cvoid}, arg2::Ptr{Cdouble})::Cint
end

function DSDPSetScale(arg1, arg2)
    @ccall libdsdp.DSDPSetScale(arg1::Ptr{Cvoid}, arg2::Cdouble)::Cint
end

function DSDPGetPenaltyParameter(arg1, arg2)
    @ccall libdsdp.DSDPGetPenaltyParameter(arg1::Ptr{Cvoid}, arg2::Ptr{Cdouble})::Cint
end

function DSDPGetPenalty(arg1, arg2)
    @ccall libdsdp.DSDPGetPenalty(arg1::Ptr{Cvoid}, arg2::Ptr{Cdouble})::Cint
end

function DSDPCopyB(arg1, arg2, arg3)
    @ccall libdsdp.DSDPCopyB(arg1::Ptr{Cvoid}, arg2::Ptr{Cdouble}, arg3::Cint)::Cint
end

function DSDPSetR0(arg1, arg2)
    @ccall libdsdp.DSDPSetR0(arg1::Ptr{Cvoid}, arg2::Cdouble)::Cint
end

function DSDPGetR(arg1, arg2)
    @ccall libdsdp.DSDPGetR(arg1::Ptr{Cvoid}, arg2::Ptr{Cdouble})::Cint
end

function DSDPSetRTolerance(arg1, arg2)
    @ccall libdsdp.DSDPSetRTolerance(arg1::Ptr{Cvoid}, arg2::Cdouble)::Cint
end

function DSDPGetRTolerance(arg1, arg2)
    @ccall libdsdp.DSDPGetRTolerance(arg1::Ptr{Cvoid}, arg2::Ptr{Cdouble})::Cint
end

function DSDPSetY0(arg1, arg2, arg3)
    @ccall libdsdp.DSDPSetY0(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Cdouble)::Cint
end

function DSDPGetY(arg1, arg2, arg3)
    @ccall libdsdp.DSDPGetY(arg1::Ptr{Cvoid}, arg2::Ptr{Cdouble}, arg3::Cint)::Cint
end

function DSDPGetYMakeX(arg1, arg2, arg3)
    @ccall libdsdp.DSDPGetYMakeX(arg1::Ptr{Cvoid}, arg2::Ptr{Cdouble}, arg3::Cint)::Cint
end

function DSDPGetDYMakeX(arg1, arg2, arg3)
    @ccall libdsdp.DSDPGetDYMakeX(arg1::Ptr{Cvoid}, arg2::Ptr{Cdouble}, arg3::Cint)::Cint
end

function DSDPGetMuMakeX(arg1, arg2)
    @ccall libdsdp.DSDPGetMuMakeX(arg1::Ptr{Cvoid}, arg2::Ptr{Cdouble})::Cint
end

function DSDPReuseMatrix(arg1, arg2)
    @ccall libdsdp.DSDPReuseMatrix(arg1::Ptr{Cvoid}, arg2::Cint)::Cint
end

function DSDPGetReuseMatrix(arg1, arg2)
    @ccall libdsdp.DSDPGetReuseMatrix(arg1::Ptr{Cvoid}, arg2::Ptr{Cint})::Cint
end

function DSDPGetDimension(arg1, arg2)
    @ccall libdsdp.DSDPGetDimension(arg1::Ptr{Cvoid}, arg2::Ptr{Cdouble})::Cint
end

function DSDPSetMaxIts(arg1, arg2)
    @ccall libdsdp.DSDPSetMaxIts(arg1::Ptr{Cvoid}, arg2::Cint)::Cint
end

function DSDPGetMaxIts(arg1, arg2)
    @ccall libdsdp.DSDPGetMaxIts(arg1::Ptr{Cvoid}, arg2::Ptr{Cint})::Cint
end

function DSDPSetStepTolerance(arg1, arg2)
    @ccall libdsdp.DSDPSetStepTolerance(arg1::Ptr{Cvoid}, arg2::Cdouble)::Cint
end

function DSDPGetStepTolerance(arg1, arg2)
    @ccall libdsdp.DSDPGetStepTolerance(arg1::Ptr{Cvoid}, arg2::Ptr{Cdouble})::Cint
end

function DSDPSetGapTolerance(arg1, arg2)
    @ccall libdsdp.DSDPSetGapTolerance(arg1::Ptr{Cvoid}, arg2::Cdouble)::Cint
end

function DSDPGetGapTolerance(arg1, arg2)
    @ccall libdsdp.DSDPGetGapTolerance(arg1::Ptr{Cvoid}, arg2::Ptr{Cdouble})::Cint
end

function DSDPSetPNormTolerance(arg1, arg2)
    @ccall libdsdp.DSDPSetPNormTolerance(arg1::Ptr{Cvoid}, arg2::Cdouble)::Cint
end

function DSDPGetPNormTolerance(arg1, arg2)
    @ccall libdsdp.DSDPGetPNormTolerance(arg1::Ptr{Cvoid}, arg2::Ptr{Cdouble})::Cint
end

function DSDPSetDualBound(arg1, arg2)
    @ccall libdsdp.DSDPSetDualBound(arg1::Ptr{Cvoid}, arg2::Cdouble)::Cint
end

function DSDPGetDualBound(arg1, arg2)
    @ccall libdsdp.DSDPGetDualBound(arg1::Ptr{Cvoid}, arg2::Ptr{Cdouble})::Cint
end

function DSDPSetPTolerance(arg1, arg2)
    @ccall libdsdp.DSDPSetPTolerance(arg1::Ptr{Cvoid}, arg2::Cdouble)::Cint
end

function DSDPGetPTolerance(arg1, arg2)
    @ccall libdsdp.DSDPGetPTolerance(arg1::Ptr{Cvoid}, arg2::Ptr{Cdouble})::Cint
end

function DSDPGetPInfeasibility(arg1, arg2)
    @ccall libdsdp.DSDPGetPInfeasibility(arg1::Ptr{Cvoid}, arg2::Ptr{Cdouble})::Cint
end

function DSDPSetMaxTrustRadius(arg1, arg2)
    @ccall libdsdp.DSDPSetMaxTrustRadius(arg1::Ptr{Cvoid}, arg2::Cdouble)::Cint
end

function DSDPGetMaxTrustRadius(arg1, arg2)
    @ccall libdsdp.DSDPGetMaxTrustRadius(arg1::Ptr{Cvoid}, arg2::Ptr{Cdouble})::Cint
end

function DSDPStopReason(arg1, arg2)
    @ccall libdsdp.DSDPStopReason(arg1::Ptr{Cvoid}, arg2::Ptr{DSDPTerminationReason})::Cint
end

function DSDPGetSolutionType(arg1, arg2)
    @ccall libdsdp.DSDPGetSolutionType(arg1::Ptr{Cvoid}, arg2::Ptr{DSDPSolutionType})::Cint
end

function DSDPSetPotentialParameter(arg1, arg2)
    @ccall libdsdp.DSDPSetPotentialParameter(arg1::Ptr{Cvoid}, arg2::Cdouble)::Cint
end

function DSDPGetPotentialParameter(arg1, arg2)
    @ccall libdsdp.DSDPGetPotentialParameter(arg1::Ptr{Cvoid}, arg2::Ptr{Cdouble})::Cint
end

function DSDPUseDynamicRho(arg1, arg2)
    @ccall libdsdp.DSDPUseDynamicRho(arg1::Ptr{Cvoid}, arg2::Cint)::Cint
end

function DSDPGetPotential(arg1, arg2)
    @ccall libdsdp.DSDPGetPotential(arg1::Ptr{Cvoid}, arg2::Ptr{Cdouble})::Cint
end

function DSDPUseLAPACKForSchur(arg1, arg2)
    @ccall libdsdp.DSDPUseLAPACKForSchur(arg1::Ptr{Cvoid}, arg2::Cint)::Cint
end

function DSDPGetNumberOfVariables(arg1, arg2)
    @ccall libdsdp.DSDPGetNumberOfVariables(arg1::Ptr{Cvoid}, arg2::Ptr{Cint})::Cint
end

function DSDPGetFinalErrors(arg1, arg2)
    @ccall libdsdp.DSDPGetFinalErrors(arg1::Ptr{Cvoid}, arg2::Ptr{Cdouble})::Cint
end

function DSDPGetGapHistory(arg1, arg2, arg3)
    @ccall libdsdp.DSDPGetGapHistory(arg1::Ptr{Cvoid}, arg2::Ptr{Cdouble}, arg3::Cint)::Cint
end

function DSDPGetRHistory(arg1, arg2, arg3)
    @ccall libdsdp.DSDPGetRHistory(arg1::Ptr{Cvoid}, arg2::Ptr{Cdouble}, arg3::Cint)::Cint
end

function DSDPGetIts(arg1, arg2)
    @ccall libdsdp.DSDPGetIts(arg1::Ptr{Cvoid}, arg2::Ptr{Cint})::Cint
end

function DSDPGetPnorm(arg1, arg2)
    @ccall libdsdp.DSDPGetPnorm(arg1::Ptr{Cvoid}, arg2::Ptr{Cdouble})::Cint
end

function DSDPGetStepLengths(arg1, arg2, arg3)
    @ccall libdsdp.DSDPGetStepLengths(arg1::Ptr{Cvoid}, arg2::Ptr{Cdouble}, arg3::Ptr{Cdouble})::Cint
end

function DSDPSetMonitor(arg1, arg2, arg3)
    @ccall libdsdp.DSDPSetMonitor(arg1::Ptr{Cvoid}, arg2::Ptr{Cvoid}, arg3::Ptr{Cvoid})::Cint
end

function DSDPSetStandardMonitor(arg1, arg2)
    @ccall libdsdp.DSDPSetStandardMonitor(arg1::Ptr{Cvoid}, arg2::Cint)::Cint
end

function DSDPSetFileMonitor(arg1, arg2)
    @ccall libdsdp.DSDPSetFileMonitor(arg1::Ptr{Cvoid}, arg2::Cint)::Cint
end

function DSDPSetPenaltyParameter(arg1, arg2)
    @ccall libdsdp.DSDPSetPenaltyParameter(arg1::Ptr{Cvoid}, arg2::Cdouble)::Cint
end

function DSDPUsePenalty(arg1, arg2)
    @ccall libdsdp.DSDPUsePenalty(arg1::Ptr{Cvoid}, arg2::Cint)::Cint
end

function DSDPPrintLogInfo(arg1)
    @ccall libdsdp.DSDPPrintLogInfo(arg1::Cint)::Cint
end

function DSDPComputeMinimumXEigenvalue(arg1, arg2)
    @ccall libdsdp.DSDPComputeMinimumXEigenvalue(arg1::Ptr{Cvoid}, arg2::Ptr{Cdouble})::Cint
end

function DSDPGetTraceX(dsdp, arg2)
    @ccall libdsdp.DSDPGetTraceX(dsdp::Ptr{Cvoid}, arg2::Ptr{Cdouble})::Cint
end

function DSDPSetZBar(arg1, arg2)
    @ccall libdsdp.DSDPSetZBar(arg1::Ptr{Cvoid}, arg2::Cdouble)::Cint
end

function DSDPSetDualLowerBound(arg1, arg2)
    @ccall libdsdp.DSDPSetDualLowerBound(arg1::Ptr{Cvoid}, arg2::Cdouble)::Cint
end

function DSDPGetDataNorms(arg1, arg2)
    @ccall libdsdp.DSDPGetDataNorms(arg1::Ptr{Cvoid}, arg2::Ptr{Cdouble})::Cint
end

function DSDPGetYMaxNorm(arg1, arg2)
    @ccall libdsdp.DSDPGetYMaxNorm(arg1::Ptr{Cvoid}, arg2::Ptr{Cdouble})::Cint
end

function SDPConeUseFullSymmetricFormat(arg1, arg2)
    @ccall libdsdp.SDPConeUseFullSymmetricFormat(arg1::Ptr{Cvoid}, arg2::Cint)::Cint
end

function SDPConeUsePackedFormat(arg1, arg2)
    @ccall libdsdp.SDPConeUsePackedFormat(arg1::Ptr{Cvoid}, arg2::Cint)::Cint
end

function DSDPSetFixedVariable(arg1, arg2, arg3)
    @ccall libdsdp.DSDPSetFixedVariable(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Cdouble)::Cint
end

function DSDPSetFixedVariables(arg1, arg2, arg3, arg4, arg5)
    @ccall libdsdp.DSDPSetFixedVariables(arg1::Ptr{Cvoid}, arg2::Ptr{Cdouble}, arg3::Ptr{Cdouble}, arg4::Ptr{Cdouble}, arg5::Cint)::Cint
end

function DSDPGetFixedYX(arg1, arg2, arg3)
    @ccall libdsdp.DSDPGetFixedYX(arg1::Ptr{Cvoid}, arg2::Cint, arg3::Ptr{Cdouble})::Cint
end

function DSDPView(arg1)
    @ccall libdsdp.DSDPView(arg1::Ptr{Cvoid})::Cint
end

# no prototype is found for this function at dsdp5.h:206:12, please use with caution
function DSDPPrintOptions()
    @ccall libdsdp.DSDPPrintOptions()::Cint
end

function DSDPPrintData(arg1, arg2, arg3)
    @ccall libdsdp.DSDPPrintData(arg1::Ptr{Cvoid}, arg2::Ptr{Cvoid}, arg3::Ptr{Cvoid})::Cint
end

function DSDPPrintSolution(arg1, arg2, arg3, arg4)
    @ccall libdsdp.DSDPPrintSolution(arg1::Ptr{Libc.FILE}, arg2::Ptr{Cvoid}, arg3::Ptr{Cvoid}, arg4::Ptr{Cvoid})::Cint
end

function DSDPSetOptions(arg1, arg2, arg3)
    @ccall libdsdp.DSDPSetOptions(arg1::Ptr{Cvoid}, arg2::Ptr{Ptr{Cchar}}, arg3::Cint)::Cint
end

function DSDPReadOptions(arg1, arg2)
    @ccall libdsdp.DSDPReadOptions(arg1::Ptr{Cvoid}, arg2::Ptr{Cchar})::Cint
end

function DSDPSetDestroyRoutine(arg1, arg2, arg3)
    @ccall libdsdp.DSDPSetDestroyRoutine(arg1::Ptr{Cvoid}, arg2::Ptr{Cvoid}, arg3::Ptr{Cvoid})::Cint
end
