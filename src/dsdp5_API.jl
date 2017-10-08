# Julia wrapper for header: include/dsdp5.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function SetConvergenceFlag(arg1::Ptr{Void}, arg2::DSDPTerminationReason)
    ccall((:DSDPSetConvergenceFlag, libdsdp), Cint, (Ptr{Void}, DSDPTerminationReason), arg1, arg2)
end

function Create(m::Integer)
    dsdp = Ref{Ptr{Void}}()
    info = ccall((:DSDPCreate, libdsdp), Cint, (Cint, Ref{Ptr{Void}}), m, dsdp)
    @assert iszero(info)
    dsdp[]
end

function Setup(dsdp::Ptr{Void})
    ccall((:DSDPSetup, libdsdp), Cint, (Ptr{Void},), dsdp)
end

function Solve(dsdp::Ptr{Void})
    ccall((:DSDPSolve, libdsdp), Cint, (Ptr{Void},), dsdp)
end

function ComputeX(arg1::Ptr{Void})
    ccall((:DSDPComputeX, libdsdp), Cint, (Ptr{Void},), arg1)
end

function ComputeAndFactorS(arg1::Ptr{Void}, arg2)
    ccall((:DSDPComputeAndFactorS, libdsdp), Cint, (Ptr{Void}, Ptr{DSDPTruth}), arg1, arg2)
end

function Destroy(arg1::Ptr{Void})
    ccall((:DSDPDestroy, libdsdp), Cint, (Ptr{Void},), arg1)
end

function CreateBCone(arg1::Ptr{Void}, arg2)
    ccall((:DSDPCreateBCone, libdsdp), Cint, (Ptr{Void}, Ptr{BCone}), arg1, arg2)
end

function BConeAllocateBounds(arg1::BCone, arg2::Integer)
    ccall((:BConeAllocateBounds, libdsdp), Cint, (BCone, Cint), arg1, arg2)
end

function BConeSetLowerBound(arg1::BCone, arg2::Integer, arg3::Cdouble)
    ccall((:BConeSetLowerBound, libdsdp), Cint, (BCone, Cint, Cdouble), arg1, arg2, arg3)
end

function BConeSetUpperBound(arg1::BCone, arg2::Integer, arg3::Cdouble)
    ccall((:BConeSetUpperBound, libdsdp), Cint, (BCone, Cint, Cdouble), arg1, arg2, arg3)
end

function BConeSetPSlackVariable(arg1::BCone, arg2::Integer)
    ccall((:BConeSetPSlackVariable, libdsdp), Cint, (BCone, Cint), arg1, arg2)
end

function BConeSetPSurplusVariable(arg1::BCone, arg2::Integer)
    ccall((:BConeSetPSurplusVariable, libdsdp), Cint, (BCone, Cint), arg1, arg2)
end

function BConeScaleBarrier(arg1::BCone, arg2::Cdouble)
    ccall((:BConeScaleBarrier, libdsdp), Cint, (BCone, Cdouble), arg1, arg2)
end

function BConeView(arg1::BCone)
    ccall((:BConeView, libdsdp), Cint, (BCone,), arg1)
end

function BConeSetXArray(arg1::BCone, arg2, arg3::Integer)
    ccall((:BConeSetXArray, libdsdp), Cint, (BCone, Ptr{Cdouble}, Cint), arg1, arg2, arg3)
end

function BConeCopyX(arg1::BCone, arg2, arg3, arg4::Integer)
    ccall((:BConeCopyX, libdsdp), Cint, (BCone, Ptr{Cdouble}, Ptr{Cdouble}, Cint), arg1, arg2, arg3, arg4)
end

function BoundDualVariables(arg1::Ptr{Void}, arg2::Cdouble, arg3::Cdouble)
    ccall((:DSDPBoundDualVariables, libdsdp), Cint, (Ptr{Void}, Cdouble, Cdouble), arg1, arg2, arg3)
end

function SetYBounds(arg1::Ptr{Void}, arg2::Cdouble, arg3::Cdouble)
    ccall((:DSDPSetYBounds, libdsdp), Cint, (Ptr{Void}, Cdouble, Cdouble), arg1, arg2, arg3)
end

function GetYBounds(arg1::Ptr{Void}, arg2, arg3)
    ccall((:DSDPGetYBounds, libdsdp), Cint, (Ptr{Void}, Ptr{Cdouble}, Ptr{Cdouble}), arg1, arg2, arg3)
end

function CreateLPCone(arg1::Ptr{Void}, arg2)
    ccall((:DSDPCreateLPCone, libdsdp), Cint, (Ptr{Void}, Ptr{LPCone}), arg1, arg2)
end

function LPConeSetData(arg1::LPCone, arg2::Integer, arg3, arg4, arg5)
    ccall((:LPConeSetData, libdsdp), Cint, (LPCone, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), arg1, arg2, arg3, arg4, arg5)
end

function LPConeSetData2(arg1::LPCone, arg2::Integer, arg3, arg4, arg5)
    ccall((:LPConeSetData2, libdsdp), Cint, (LPCone, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), arg1, arg2, arg3, arg4, arg5)
end

function LPConeGetData(arg1::LPCone, arg2::Integer, arg3, arg4::Integer)
    ccall((:LPConeGetData, libdsdp), Cint, (LPCone, Cint, Ptr{Cdouble}, Cint), arg1, arg2, arg3, arg4)
end

function LPConeScaleBarrier(arg1::LPCone, arg2::Cdouble)
    ccall((:LPConeScaleBarrier, libdsdp), Cint, (LPCone, Cdouble), arg1, arg2)
end

function LPConeGetXArray(arg1::LPCone, arg2, arg3)
    ccall((:LPConeGetXArray, libdsdp), Cint, (LPCone, Ptr{Ptr{Cdouble}}, Ptr{Cint}), arg1, arg2, arg3)
end

function LPConeGetSArray(arg1::LPCone, arg2, arg3)
    ccall((:LPConeGetSArray, libdsdp), Cint, (LPCone, Ptr{Ptr{Cdouble}}, Ptr{Cint}), arg1, arg2, arg3)
end

function LPConeGetDimension(arg1::LPCone, arg2)
    ccall((:LPConeGetDimension, libdsdp), Cint, (LPCone, Ptr{Cint}), arg1, arg2)
end

function LPConeView(lpcone::LPCone)
    ccall((:LPConeView, libdsdp), Cint, (LPCone,), lpcone)
end

function LPConeView2(lpcone::LPCone)
    ccall((:LPConeView2, libdsdp), Cint, (LPCone,), lpcone)
end

function LPConeCopyS(arg1::LPCone, arg2, arg3::Integer)
    ccall((:LPConeCopyS, libdsdp), Cint, (LPCone, Ptr{Cdouble}, Cint), arg1, arg2, arg3)
end

function CreateSDPCone(dsdp::Ptr{Void}, n::Integer)
    sdpcone = Ref{SDPCone}()
    info = ccall((:DSDPCreateSDPCone, libdsdp), Cint, (Ptr{Void}, Cint, Ref{SDPCone}), dsdp, n, sdpcone)
    @assert iszero(info)
    sdpcone[]
end
function CreateSDPCone(arg1::Ptr{Void}, arg2::Integer, arg3)
    ccall((:DSDPCreateSDPCone, libdsdp), Cint, (Ptr{Void}, Cint, Ptr{SDPCone}), arg1, arg2, arg3)
end

function SDPConeSetBlockSize(sdpcone::SDPCone, i::Integer, j::Integer)
    info = ccall((:SDPConeSetBlockSize, libdsdp), Cint, (SDPCone, Cint, Cint), sdpcone, i, j)
    @assert iszero(info)
end

function SDPConeGetBlockSize(arg1::SDPCone, arg2::Integer, arg3)
    ccall((:SDPConeGetBlockSize, libdsdp), Cint, (SDPCone, Cint, Ptr{Cint}), arg1, arg2, arg3)
end

function SDPConeSetStorageFormat(arg1::SDPCone, arg2::Integer, arg3::UInt8)
    ccall((:SDPConeSetStorageFormat, libdsdp), Cint, (SDPCone, Cint, UInt8), arg1, arg2, arg3)
end

function SDPConeGetStorageFormat(arg1::SDPCone, arg2::Integer, arg3)
    ccall((:SDPConeGetStorageFormat, libdsdp), Cint, (SDPCone, Cint, Cstring), arg1, arg2, arg3)
end

function SDPConeCheckStorageFormat(arg1::SDPCone, arg2::Integer, arg3::UInt8)
    ccall((:SDPConeCheckStorageFormat, libdsdp), Cint, (SDPCone, Cint, UInt8), arg1, arg2, arg3)
end

function SDPConeSetSparsity(arg1::SDPCone, arg2::Integer, arg3::Integer)
    ccall((:SDPConeSetSparsity, libdsdp), Cint, (SDPCone, Cint, Cint), arg1, arg2, arg3)
end

function SDPConeView(arg1::SDPCone)
    ccall((:SDPConeView, libdsdp), Cint, (SDPCone,), arg1)
end

function SDPConeView2(arg1::SDPCone)
    ccall((:SDPConeView2, libdsdp), Cint, (SDPCone,), arg1)
end

function SDPConeView3(arg1::SDPCone)
    ccall((:SDPConeView3, libdsdp), Cint, (SDPCone,), arg1)
end

function SDPConeSetASparseVecMat(arg1::SDPCone, arg2::Integer, arg3::Integer, arg4::Integer, arg5::Cdouble, arg6::Integer, arg7, arg8, arg9::Integer)
    ccall((:SDPConeSetASparseVecMat, libdsdp), Cint, (SDPCone, Cint, Cint, Cint, Cdouble, Cint, Ptr{Cint}, Ptr{Cdouble}, Cint), arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end

function SDPConeSetADenseVecMat(arg1::SDPCone, arg2::Integer, arg3::Integer, arg4::Integer, arg5::Cdouble, arg6, arg7::Integer)
    ccall((:SDPConeSetADenseVecMat, libdsdp), Cint, (SDPCone, Cint, Cint, Cint, Cdouble, Ptr{Cdouble}, Cint), arg1, arg2, arg3, arg4, arg5, arg6, arg7)
end

function SDPConeSetARankOneMat(arg1::SDPCone, arg2::Integer, arg3::Integer, arg4::Integer, arg5::Cdouble, arg6::Integer, arg7, arg8, arg9::Integer)
    ccall((:SDPConeSetARankOneMat, libdsdp), Cint, (SDPCone, Cint, Cint, Cint, Cdouble, Cint, Ptr{Cint}, Ptr{Cdouble}, Cint), arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end

function SDPConeSetConstantMat(arg1::SDPCone, arg2::Integer, arg3::Integer, arg4::Integer, arg5::Cdouble)
    ccall((:SDPConeSetConstantMat, libdsdp), Cint, (SDPCone, Cint, Cint, Cint, Cdouble), arg1, arg2, arg3, arg4, arg5)
end

function SDPConeSetZeroMat(arg1::SDPCone, arg2::Integer, arg3::Integer, arg4::Integer)
    ccall((:SDPConeSetZeroMat, libdsdp), Cint, (SDPCone, Cint, Cint, Cint), arg1, arg2, arg3, arg4)
end

function SDPConeSetIdentity(arg1::SDPCone, arg2::Integer, arg3::Integer, arg4::Integer, arg5::Cdouble)
    ccall((:SDPConeSetIdentity, libdsdp), Cint, (SDPCone, Cint, Cint, Cint, Cdouble), arg1, arg2, arg3, arg4, arg5)
end

function SDPConeViewDataMatrix(arg1::SDPCone, arg2::Integer, arg3::Integer)
    ccall((:SDPConeViewDataMatrix, libdsdp), Cint, (SDPCone, Cint, Cint), arg1, arg2, arg3)
end

function SDPConeMatrixView(arg1::SDPCone, arg2::Integer)
    ccall((:SDPConeMatrixView, libdsdp), Cint, (SDPCone, Cint), arg1, arg2)
end

function SDPConeAddASparseVecMat(arg1::SDPCone, arg2::Integer, arg3::Integer, arg4::Integer, arg5::Cdouble, arg6::Integer, arg7, arg8, arg9::Integer)
    ccall((:SDPConeAddASparseVecMat, libdsdp), Cint, (SDPCone, Cint, Cint, Cint, Cdouble, Cint, Ptr{Cint}, Ptr{Cdouble}, Cint), arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end

function SDPConeAddADenseVecMat(arg1::SDPCone, arg2::Integer, arg3::Integer, arg4::Integer, arg5::Cdouble, arg6, arg7::Integer)
    ccall((:SDPConeAddADenseVecMat, libdsdp), Cint, (SDPCone, Cint, Cint, Cint, Cdouble, Ptr{Cdouble}, Cint), arg1, arg2, arg3, arg4, arg5, arg6, arg7)
end

function SDPConeAddConstantMat(arg1::SDPCone, arg2::Integer, arg3::Integer, arg4::Integer, arg5::Cdouble)
    ccall((:SDPConeAddConstantMat, libdsdp), Cint, (SDPCone, Cint, Cint, Cint, Cdouble), arg1, arg2, arg3, arg4, arg5)
end

function SDPConeAddIdentity(arg1::SDPCone, arg2::Integer, arg3::Integer, arg4::Integer, arg5::Cdouble)
    ccall((:SDPConeAddIdentity, libdsdp), Cint, (SDPCone, Cint, Cint, Cint, Cdouble), arg1, arg2, arg3, arg4, arg5)
end

function SDPConeAddARankOneMat(arg1::SDPCone, arg2::Integer, arg3::Integer, arg4::Integer, arg5::Cdouble, arg6::Integer, arg7, arg8, arg9::Integer)
    ccall((:SDPConeAddARankOneMat, libdsdp), Cint, (SDPCone, Cint, Cint, Cint, Cdouble, Cint, Ptr{Cint}, Ptr{Cdouble}, Cint), arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end

function SDPConeAddSparseVecMat(arg1::SDPCone, arg2::Integer, arg3::Integer, arg4::Integer, arg5::Integer, arg6, arg7, arg8::Integer)
    ccall((:SDPConeAddSparseVecMat, libdsdp), Cint, (SDPCone, Cint, Cint, Cint, Cint, Ptr{Cint}, Ptr{Cdouble}, Cint), arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
end

function SDPConeAddDenseVecMat(arg1::SDPCone, arg2::Integer, arg3::Integer, arg4::Integer, arg5, arg6::Integer)
    ccall((:SDPConeAddDenseVecMat, libdsdp), Cint, (SDPCone, Cint, Cint, Cint, Ptr{Cdouble}, Cint), arg1, arg2, arg3, arg4, arg5, arg6)
end

function SDPConeSetSparseVecMat(arg1::SDPCone, arg2::Integer, arg3::Integer, arg4::Integer, arg5::Integer, arg6, arg7, arg8::Integer)
    ccall((:SDPConeSetSparseVecMat, libdsdp), Cint, (SDPCone, Cint, Cint, Cint, Cint, Ptr{Cint}, Ptr{Cdouble}, Cint), arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
end

function SDPConeSetDenseVecMat(arg1::SDPCone, arg2::Integer, arg3::Integer, arg4::Integer, arg5, arg6::Integer)
    ccall((:SDPConeSetDenseVecMat, libdsdp), Cint, (SDPCone, Cint, Cint, Cint, Ptr{Cdouble}, Cint), arg1, arg2, arg3, arg4, arg5, arg6)
end

function SDPConeSetXMat(arg1::SDPCone, arg2::Integer, arg3::Integer)
    ccall((:SDPConeSetXMat, libdsdp), Cint, (SDPCone, Cint, Cint), arg1, arg2, arg3)
end

function SDPConeSetXArray(arg1::SDPCone, arg2::Integer, arg3::Integer, arg4, arg5::Integer)
    ccall((:SDPConeSetXArray, libdsdp), Cint, (SDPCone, Cint, Cint, Ptr{Cdouble}, Cint), arg1, arg2, arg3, arg4, arg5)
end

function SDPConeGetXArray(arg1::SDPCone, arg2::Integer, arg3, arg4)
    ccall((:SDPConeGetXArray, libdsdp), Cint, (SDPCone, Cint, Ptr{Ptr{Cdouble}}, Ptr{Cint}), arg1, arg2, arg3, arg4)
end

function SDPConeRestoreXArray(arg1::SDPCone, arg2::Integer, arg3, arg4)
    ccall((:SDPConeRestoreXArray, libdsdp), Cint, (SDPCone, Cint, Ptr{Ptr{Cdouble}}, Ptr{Cint}), arg1, arg2, arg3, arg4)
end

function SDPConeCheckData(arg1::SDPCone)
    ccall((:SDPConeCheckData, libdsdp), Cint, (SDPCone,), arg1)
end

function SDPConeRemoveDataMatrix(arg1::SDPCone, arg2::Integer, arg3::Integer)
    ccall((:SDPConeRemoveDataMatrix, libdsdp), Cint, (SDPCone, Cint, Cint), arg1, arg2, arg3)
end

function SDPConeGetNumberOfBlocks(arg1::SDPCone, arg2)
    ccall((:SDPConeGetNumberOfBlocks, libdsdp), Cint, (SDPCone, Ptr{Cint}), arg1, arg2)
end

function SDPConeComputeS(arg1::SDPCone, arg2::Integer, arg3::Cdouble, arg4, arg5::Integer, arg6::Cdouble, arg7::Integer, arg8, arg9::Integer)
    ccall((:SDPConeComputeS, libdsdp), Cint, (SDPCone, Cint, Cdouble, Ptr{Cdouble}, Cint, Cdouble, Cint, Ptr{Cdouble}, Cint), arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end

function SDPConeComputeX(arg1::SDPCone, arg2::Integer, arg3::Integer, arg4, arg5::Integer)
    ccall((:SDPConeComputeX, libdsdp), Cint, (SDPCone, Cint, Cint, Ptr{Cdouble}, Cint), arg1, arg2, arg3, arg4, arg5)
end

function SDPConeAddADotX(arg1::SDPCone, arg2::Integer, arg3::Cdouble, arg4, arg5::Integer, arg6, arg7::Integer)
    ccall((:SDPConeAddADotX, libdsdp), Cint, (SDPCone, Cint, Cdouble, Ptr{Cdouble}, Cint, Ptr{Cdouble}, Cint), arg1, arg2, arg3, arg4, arg5, arg6, arg7)
end

function SDPConeViewX(arg1::SDPCone, arg2::Integer, arg3::Integer, arg4, arg5::Integer)
    ccall((:SDPConeViewX, libdsdp), Cint, (SDPCone, Cint, Cint, Ptr{Cdouble}, Cint), arg1, arg2, arg3, arg4, arg5)
end

function SDPConeSetLanczosIterations(arg1::SDPCone, arg2::Integer)
    ccall((:SDPConeSetLanczosIterations, libdsdp), Cint, (SDPCone, Cint), arg1, arg2)
end

function SDPConeScaleBarrier(arg1::SDPCone, arg2::Integer, arg3::Cdouble)
    ccall((:SDPConeScaleBarrier, libdsdp), Cint, (SDPCone, Cint, Cdouble), arg1, arg2, arg3)
end

function SDPConeXVMultiply(arg1::SDPCone, arg2::Integer, arg3, arg4, arg5::Integer)
    ccall((:SDPConeXVMultiply, libdsdp), Cint, (SDPCone, Cint, Ptr{Cdouble}, Ptr{Cdouble}, Cint), arg1, arg2, arg3, arg4, arg5)
end

function SDPConeComputeXV(arg1::SDPCone, arg2::Integer, arg3)
    ccall((:SDPConeComputeXV, libdsdp), Cint, (SDPCone, Cint, Ptr{Cint}), arg1, arg2, arg3)
end

function SDPConeAddXVAV(arg1::SDPCone, arg2::Integer, arg3, arg4::Integer, arg5, arg6::Integer)
    ccall((:SDPConeAddXVAV, libdsdp), Cint, (SDPCone, Cint, Ptr{Cdouble}, Cint, Ptr{Cdouble}, Cint), arg1, arg2, arg3, arg4, arg5, arg6)
end

function SDPConeUseLAPACKForDualMatrix(arg1::SDPCone, arg2::Integer)
    ccall((:SDPConeUseLAPACKForDualMatrix, libdsdp), Cint, (SDPCone, Cint), arg1, arg2)
end

function SetDualObjective(arg1::Ptr{Void}, arg2::Integer, arg3::Cdouble)
    ccall((:DSDPSetDualObjective, libdsdp), Cint, (Ptr{Void}, Cint, Cdouble), arg1, arg2, arg3)
end

function AddObjectiveConstant(arg1::Ptr{Void}, arg2::Cdouble)
    ccall((:DSDPAddObjectiveConstant, libdsdp), Cint, (Ptr{Void}, Cdouble), arg1, arg2)
end

function GetDObjective(arg1::Ptr{Void}, arg2)
    ccall((:DSDPGetDObjective, libdsdp), Cint, (Ptr{Void}, Ptr{Cdouble}), arg1, arg2)
end

function GetDDObjective(arg1::Ptr{Void}, arg2)
    ccall((:DSDPGetDDObjective, libdsdp), Cint, (Ptr{Void}, Ptr{Cdouble}), arg1, arg2)
end

function GetPObjective(arg1::Ptr{Void}, arg2)
    ccall((:DSDPGetPObjective, libdsdp), Cint, (Ptr{Void}, Ptr{Cdouble}), arg1, arg2)
end

function GetPPObjective(arg1::Ptr{Void}, arg2)
    ccall((:DSDPGetPPObjective, libdsdp), Cint, (Ptr{Void}, Ptr{Cdouble}), arg1, arg2)
end

function GetDualityGap(arg1::Ptr{Void}, arg2)
    ccall((:DSDPGetDualityGap, libdsdp), Cint, (Ptr{Void}, Ptr{Cdouble}), arg1, arg2)
end

function GetScale(arg1::Ptr{Void}, arg2)
    ccall((:DSDPGetScale, libdsdp), Cint, (Ptr{Void}, Ptr{Cdouble}), arg1, arg2)
end

function SetScale(arg1::Ptr{Void}, arg2::Cdouble)
    ccall((:DSDPSetScale, libdsdp), Cint, (Ptr{Void}, Cdouble), arg1, arg2)
end

function GetPenaltyParameter(arg1::Ptr{Void}, arg2)
    ccall((:DSDPGetPenaltyParameter, libdsdp), Cint, (Ptr{Void}, Ptr{Cdouble}), arg1, arg2)
end

function GetPenalty(arg1::Ptr{Void}, arg2)
    ccall((:DSDPGetPenalty, libdsdp), Cint, (Ptr{Void}, Ptr{Cdouble}), arg1, arg2)
end

function CopyB(arg1::Ptr{Void}, arg2, arg3::Integer)
    ccall((:DSDPCopyB, libdsdp), Cint, (Ptr{Void}, Ptr{Cdouble}, Cint), arg1, arg2, arg3)
end

function SetR0(arg1::Ptr{Void}, arg2::Cdouble)
    ccall((:DSDPSetR0, libdsdp), Cint, (Ptr{Void}, Cdouble), arg1, arg2)
end

function GetR(arg1::Ptr{Void}, arg2)
    ccall((:DSDPGetR, libdsdp), Cint, (Ptr{Void}, Ptr{Cdouble}), arg1, arg2)
end

function SetRTolerance(arg1::Ptr{Void}, arg2::Cdouble)
    ccall((:DSDPSetRTolerance, libdsdp), Cint, (Ptr{Void}, Cdouble), arg1, arg2)
end

function GetRTolerance(arg1::Ptr{Void}, arg2)
    ccall((:DSDPGetRTolerance, libdsdp), Cint, (Ptr{Void}, Ptr{Cdouble}), arg1, arg2)
end

function SetY0(arg1::Ptr{Void}, arg2::Integer, arg3::Cdouble)
    ccall((:DSDPSetY0, libdsdp), Cint, (Ptr{Void}, Cint, Cdouble), arg1, arg2, arg3)
end

function GetY(arg1::Ptr{Void}, arg2, arg3::Integer)
    ccall((:DSDPGetY, libdsdp), Cint, (Ptr{Void}, Ptr{Cdouble}, Cint), arg1, arg2, arg3)
end

function GetYMakeX(arg1::Ptr{Void}, arg2, arg3::Integer)
    ccall((:DSDPGetYMakeX, libdsdp), Cint, (Ptr{Void}, Ptr{Cdouble}, Cint), arg1, arg2, arg3)
end

function GetDYMakeX(arg1::Ptr{Void}, arg2, arg3::Integer)
    ccall((:DSDPGetDYMakeX, libdsdp), Cint, (Ptr{Void}, Ptr{Cdouble}, Cint), arg1, arg2, arg3)
end

function GetMuMakeX(arg1::Ptr{Void}, arg2)
    ccall((:DSDPGetMuMakeX, libdsdp), Cint, (Ptr{Void}, Ptr{Cdouble}), arg1, arg2)
end

function GetBarrierParameter(arg1::Ptr{Void}, arg2)
    ccall((:DSDPGetBarrierParameter, libdsdp), Cint, (Ptr{Void}, Ptr{Cdouble}), arg1, arg2)
end

function SetBarrierParameter(arg1::Ptr{Void}, arg2::Cdouble)
    ccall((:DSDPSetBarrierParameter, libdsdp), Cint, (Ptr{Void}, Cdouble), arg1, arg2)
end

function ReuseMatrix(arg1::Ptr{Void}, arg2::Integer)
    ccall((:DSDPReuseMatrix, libdsdp), Cint, (Ptr{Void}, Cint), arg1, arg2)
end

function GetReuseMatrix(arg1::Ptr{Void}, arg2)
    ccall((:DSDPGetReuseMatrix, libdsdp), Cint, (Ptr{Void}, Ptr{Cint}), arg1, arg2)
end

function GetDimension(arg1::Ptr{Void}, arg2)
    ccall((:DSDPGetDimension, libdsdp), Cint, (Ptr{Void}, Ptr{Cdouble}), arg1, arg2)
end

function SetMaxIts(arg1::Ptr{Void}, arg2::Integer)
    ccall((:DSDPSetMaxIts, libdsdp), Cint, (Ptr{Void}, Cint), arg1, arg2)
end

function GetMaxIts(arg1::Ptr{Void}, arg2)
    ccall((:DSDPGetMaxIts, libdsdp), Cint, (Ptr{Void}, Ptr{Cint}), arg1, arg2)
end

function SetStepTolerance(arg1::Ptr{Void}, arg2::Cdouble)
    ccall((:DSDPSetStepTolerance, libdsdp), Cint, (Ptr{Void}, Cdouble), arg1, arg2)
end

function GetStepTolerance(arg1::Ptr{Void}, arg2)
    ccall((:DSDPGetStepTolerance, libdsdp), Cint, (Ptr{Void}, Ptr{Cdouble}), arg1, arg2)
end

function SetGapTolerance(arg1::Ptr{Void}, arg2::Cdouble)
    ccall((:DSDPSetGapTolerance, libdsdp), Cint, (Ptr{Void}, Cdouble), arg1, arg2)
end

function GetGapTolerance(arg1::Ptr{Void}, arg2)
    ccall((:DSDPGetGapTolerance, libdsdp), Cint, (Ptr{Void}, Ptr{Cdouble}), arg1, arg2)
end

function SetPNormTolerance(dsdp::Ptr{Void}, arg2::Real)
    ccall((:DSDPSetPNormTolerance, libdsdp), Cint, (Ptr{Void}, Cdouble), dsdp, arg2)
end

function GetPNormTolerance(arg1::Ptr{Void}, arg2)
    ccall((:DSDPGetPNormTolerance, libdsdp), Cint, (Ptr{Void}, Ptr{Cdouble}), arg1, arg2)
end

function SetDualBound(arg1::Ptr{Void}, arg2::Cdouble)
    ccall((:DSDPSetDualBound, libdsdp), Cint, (Ptr{Void}, Cdouble), arg1, arg2)
end

function GetDualBound(arg1::Ptr{Void}, arg2)
    ccall((:DSDPGetDualBound, libdsdp), Cint, (Ptr{Void}, Ptr{Cdouble}), arg1, arg2)
end

function SetPTolerance(arg1::Ptr{Void}, arg2::Cdouble)
    ccall((:DSDPSetPTolerance, libdsdp), Cint, (Ptr{Void}, Cdouble), arg1, arg2)
end

function GetPTolerance(arg1::Ptr{Void}, arg2)
    ccall((:DSDPGetPTolerance, libdsdp), Cint, (Ptr{Void}, Ptr{Cdouble}), arg1, arg2)
end

function GetPInfeasibility(arg1::Ptr{Void}, arg2)
    ccall((:DSDPGetPInfeasibility, libdsdp), Cint, (Ptr{Void}, Ptr{Cdouble}), arg1, arg2)
end

function SetMaxTrustRadius(arg1::Ptr{Void}, arg2::Cdouble)
    ccall((:DSDPSetMaxTrustRadius, libdsdp), Cint, (Ptr{Void}, Cdouble), arg1, arg2)
end

function GetMaxTrustRadius(arg1::Ptr{Void}, arg2)
    ccall((:DSDPGetMaxTrustRadius, libdsdp), Cint, (Ptr{Void}, Ptr{Cdouble}), arg1, arg2)
end

function StopReason(dsdp::Ptr{Void})
    stop = Ref{DSDPTerminationReason}()
    ccall((:DSDPStopReason, libdsdp), Cint, (Ptr{Void}, Ref{DSDPTerminationReason}), dsdp, stop)
    stop[]
end

function GetSolutionType(arg1::Ptr{Void}, arg2)
    ccall((:DSDPGetSolutionType, libdsdp), Cint, (Ptr{Void}, Ptr{DSDPSolutionType}), arg1, arg2)
end

function SetPotentialParameter(arg1::Ptr{Void}, arg2::Real)
    ccall((:DSDPSetPotentialParameter, libdsdp), Cint, (Ptr{Void}, Cdouble), arg1, arg2)
end

function GetPotentialParameter(arg1::Ptr{Void}, arg2)
    ccall((:DSDPGetPotentialParameter, libdsdp), Cint, (Ptr{Void}, Ptr{Cdouble}), arg1, arg2)
end

function UseDynamicRho(arg1::Ptr{Void}, arg2::Integer)
    ccall((:DSDPUseDynamicRho, libdsdp), Cint, (Ptr{Void}, Cint), arg1, arg2)
end

function GetPotential(arg1::Ptr{Void}, arg2)
    ccall((:DSDPGetPotential, libdsdp), Cint, (Ptr{Void}, Ptr{Cdouble}), arg1, arg2)
end

function UseLAPACKForSchur(arg1::Ptr{Void}, arg2::Integer)
    ccall((:DSDPUseLAPACKForSchur, libdsdp), Cint, (Ptr{Void}, Cint), arg1, arg2)
end

function GetNumberOfVariables(arg1::Ptr{Void}, arg2)
    ccall((:DSDPGetNumberOfVariables, libdsdp), Cint, (Ptr{Void}, Ptr{Cint}), arg1, arg2)
end

function GetFinalErrors(arg1::Ptr{Void}, arg2::NTuple{6, Cdouble})
    ccall((:DSDPGetFinalErrors, libdsdp), Cint, (Ptr{Void}, NTuple{6, Cdouble}), arg1, arg2)
end

function GetGapHistory(arg1::Ptr{Void}, arg2, arg3::Integer)
    ccall((:DSDPGetGapHistory, libdsdp), Cint, (Ptr{Void}, Ptr{Cdouble}, Cint), arg1, arg2, arg3)
end

function GetRHistory(arg1::Ptr{Void}, arg2, arg3::Integer)
    ccall((:DSDPGetRHistory, libdsdp), Cint, (Ptr{Void}, Ptr{Cdouble}, Cint), arg1, arg2, arg3)
end

function GetIts(arg1::Ptr{Void}, arg2)
    ccall((:DSDPGetIts, libdsdp), Cint, (Ptr{Void}, Ptr{Cint}), arg1, arg2)
end

function GetPnorm(arg1::Ptr{Void}, arg2)
    ccall((:DSDPGetPnorm, libdsdp), Cint, (Ptr{Void}, Ptr{Cdouble}), arg1, arg2)
end

function GetStepLengths(arg1::Ptr{Void}, arg2, arg3)
    ccall((:DSDPGetStepLengths, libdsdp), Cint, (Ptr{Void}, Ptr{Cdouble}, Ptr{Cdouble}), arg1, arg2, arg3)
end

function SetMonitor(arg1::Ptr{Void}, arg2, arg3)
    ccall((:DSDPSetMonitor, libdsdp), Cint, (Ptr{Void}, Ptr{Void}, Ptr{Void}), arg1, arg2, arg3)
end

function SetStandardMonitor(dsdp::Ptr{Void}, arg2::Integer)
    ccall((:DSDPSetStandardMonitor, libdsdp), Cint, (Ptr{Void}, Cint), dsdp, arg2)
end

function SetFileMonitor(arg1::Ptr{Void}, arg2::Integer)
    ccall((:DSDPSetFileMonitor, libdsdp), Cint, (Ptr{Void}, Cint), arg1, arg2)
end

function SetPenaltyParameter(arg1::Ptr{Void}, arg2::Cdouble)
    ccall((:DSDPSetPenaltyParameter, libdsdp), Cint, (Ptr{Void}, Cdouble), arg1, arg2)
end

function UsePenalty(arg1::Ptr{Void}, arg2::Integer)
    ccall((:DSDPUsePenalty, libdsdp), Cint, (Ptr{Void}, Cint), arg1, arg2)
end

function PrintLogInfo(arg1::Integer)
    ccall((:DSDPPrintLogInfo, libdsdp), Cint, (Cint,), arg1)
end

function ComputeMinimumXEigenvalue(arg1::Ptr{Void}, arg2)
    ccall((:DSDPComputeMinimumXEigenvalue, libdsdp), Cint, (Ptr{Void}, Ptr{Cdouble}), arg1, arg2)
end

function GetTraceX(dsdp::Ptr{Void}, arg1)
    ccall((:DSDPGetTraceX, libdsdp), Cint, (Ptr{Void}, Ptr{Cdouble}), dsdp, arg1)
end

function SetZBar(arg1::Ptr{Void}, arg2::Cdouble)
    ccall((:DSDPSetZBar, libdsdp), Cint, (Ptr{Void}, Cdouble), arg1, arg2)
end

function SetDualLowerBound(arg1::Ptr{Void}, arg2::Cdouble)
    ccall((:DSDPSetDualLowerBound, libdsdp), Cint, (Ptr{Void}, Cdouble), arg1, arg2)
end

function GetDataNorms(arg1::Ptr{Void}, arg2::NTuple{3, Cdouble})
    ccall((:DSDPGetDataNorms, libdsdp), Cint, (Ptr{Void}, NTuple{3, Cdouble}), arg1, arg2)
end

function GetYMaxNorm(arg1::Ptr{Void}, arg2)
    ccall((:DSDPGetYMaxNorm, libdsdp), Cint, (Ptr{Void}, Ptr{Cdouble}), arg1, arg2)
end

function SDPConeUseFullSymmetricFormat(arg1::SDPCone, arg2::Integer)
    ccall((:SDPConeUseFullSymmetricFormat, libdsdp), Cint, (SDPCone, Cint), arg1, arg2)
end

function SDPConeUsePackedFormat(arg1::SDPCone, arg2::Integer)
    ccall((:SDPConeUsePackedFormat, libdsdp), Cint, (SDPCone, Cint), arg1, arg2)
end

function SetFixedVariable(arg1::Ptr{Void}, arg2::Integer, arg3::Cdouble)
    ccall((:DSDPSetFixedVariable, libdsdp), Cint, (Ptr{Void}, Cint, Cdouble), arg1, arg2, arg3)
end

function SetFixedVariables(arg1::Ptr{Void}, arg2, arg3, arg4, arg5::Integer)
    ccall((:DSDPSetFixedVariables, libdsdp), Cint, (Ptr{Void}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cint), arg1, arg2, arg3, arg4, arg5)
end

function GetFixedYX(arg1::Ptr{Void}, arg2::Integer, arg3)
    ccall((:DSDPGetFixedYX, libdsdp), Cint, (Ptr{Void}, Cint, Ptr{Cdouble}), arg1, arg2, arg3)
end

function View(arg1::Ptr{Void})
    ccall((:DSDPView, libdsdp), Cint, (Ptr{Void},), arg1)
end

function PrintOptions()
    ccall((:DSDPPrintOptions, libdsdp), Cint, ())
end

function PrintData(arg1::Ptr{Void}, arg2::SDPCone, arg3::LPCone)
    ccall((:DSDPPrintData, libdsdp), Cint, (Ptr{Void}, SDPCone, LPCone), arg1, arg2, arg3)
end

#function PrintSolution(arg1, arg2::Ptr{Void}, arg3::SDPCone, arg4::LPCone)
#    ccall((:DSDPPrintSolution, libdsdp), Cint, (Ptr{FILE}, DSDP, SDPCone, LPCone), arg1, arg2, arg3, arg4)
#end

function SetOptions(arg1::Ptr{Void}, arg2, arg3::Integer)
    ccall((:DSDPSetOptions, libdsdp), Cint, (Ptr{Void}, Ptr{Cstring}, Cint), arg1, arg2, arg3)
end

function ReadOptions(arg1::Ptr{Void}, arg2)
    ccall((:DSDPReadOptions, libdsdp), Cint, (Ptr{Void}, Ptr{UInt8}), arg1, arg2)
end

function SetDestroyRoutine(arg1::Ptr{Void}, arg2, arg3)
    ccall((:DSDPSetDestroyRoutine, libdsdp), Cint, (Ptr{Void}, Ptr{Void}, Ptr{Void}), arg1, arg2, arg3)
end
