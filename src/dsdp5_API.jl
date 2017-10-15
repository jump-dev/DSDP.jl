# Julia wrapper for header: include/dsdp5.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function SetConvergenceFlag(dsdp::DSDPT, arg2::DSDPTerminationReason)
    ccall((:DSDPSetConvergenceFlag, libdsdp), Cint, (DSDPT, DSDPTerminationReason), dsdp, arg2)
end

function Create(m::Integer)
    dsdp = Ref{DSDPT}()
    info = ccall((:DSDPCreate, libdsdp), Cint, (Cint, Ref{DSDPT}), m, dsdp)
    @assert iszero(info)
    dsdp[]
end

function Setup(dsdp::DSDPT)
    ccall((:DSDPSetup, libdsdp), Cint, (DSDPT,), dsdp)
end

function Solve(dsdp::DSDPT)
    ccall((:DSDPSolve, libdsdp), Cint, (DSDPT,), dsdp)
end

function ComputeX(dsdp::DSDPT)
    ccall((:DSDPComputeX, libdsdp), Cint, (DSDPT,), dsdp)
end

function ComputeAndFactorS(dsdp::DSDPT, arg2)
    ccall((:DSDPComputeAndFactorS, libdsdp), Cint, (DSDPT, Ptr{DSDPTruth}), dsdp, arg2)
end

function Destroy(dsdp::DSDPT)
    ccall((:DSDPDestroy, libdsdp), Cint, (DSDPT,), dsdp)
end

function CreateBCone(dsdp::DSDPT, arg2)
    ccall((:DSDPCreateBCone, libdsdp), Cint, (DSDPT, Ptr{BCone}), dsdp, arg2)
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

function BoundDualVariables(dsdp::DSDPT, arg2::Cdouble, arg3::Cdouble)
    ccall((:DSDPBoundDualVariables, libdsdp), Cint, (DSDPT, Cdouble, Cdouble), dsdp, arg2, arg3)
end

function SetYBounds(dsdp::DSDPT, arg2::Cdouble, arg3::Cdouble)
    ccall((:DSDPSetYBounds, libdsdp), Cint, (DSDPT, Cdouble, Cdouble), dsdp, arg2, arg3)
end

function GetYBounds(dsdp::DSDPT, arg2, arg3)
    ccall((:DSDPGetYBounds, libdsdp), Cint, (DSDPT, Ptr{Cdouble}, Ptr{Cdouble}), dsdp, arg2, arg3)
end

function CreateLPCone(dsdp::DSDPT, arg2)
    ccall((:DSDPCreateLPCone, libdsdp), Cint, (DSDPT, Ptr{LPCone}), dsdp, arg2)
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

function CreateSDPCone(dsdp::DSDPT, n::Integer)
    sdpcone = Ref{SDPCone}()
    info = ccall((:DSDPCreateSDPCone, libdsdp), Cint, (DSDPT, Cint, Ref{SDPCone}), dsdp, n, sdpcone)
    @assert iszero(info)
    sdpcone[]
end
function CreateSDPCone(dsdp::DSDPT, arg2::Integer, arg3)
    ccall((:DSDPCreateSDPCone, libdsdp), Cint, (DSDPT, Cint, Ptr{SDPCone}), dsdp, arg2, arg3)
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

function SDPConeXVMultiply(sdpcone::SDPCone, arg2::Integer, arg3::Vector, arg4::Vector)
    n = length(arg3)
    @assert n == length(arg4)
    ccall((:SDPConeXVMultiply, libdsdp), Cint, (SDPCone, Cint, Ptr{Cdouble}, Ptr{Cdouble}, Cint), sdpcone, arg2, pointer(arg3), pointer(arg4), n)
end

function SDPConeComputeXV(sdpcone::SDPCone, arg2::Integer)
    derror = Ref{Cint}()
    ccall((:SDPConeComputeXV, libdsdp), Cint, (SDPCone, Cint, Ref{Cint}), sdpcone, arg2, derror)
    derror[]
end

function SDPConeAddXVAV(arg1::SDPCone, arg2::Integer, arg3::Vector, arg5::Vector)
    ccall((:SDPConeAddXVAV, libdsdp), Cint, (SDPCone, Cint, Ptr{Cdouble}, Cint, Ptr{Cdouble}, Cint), arg1, arg2, pointer(arg3), length(arg3), pointer(arg5), length(arg5))
end

function SDPConeUseLAPACKForDualMatrix(arg1::SDPCone, arg2::Integer)
    ccall((:SDPConeUseLAPACKForDualMatrix, libdsdp), Cint, (SDPCone, Cint), arg1, arg2)
end

function SetDualObjective(dsdp::DSDPT, arg2::Integer, arg3::Cdouble)
    ccall((:DSDPSetDualObjective, libdsdp), Cint, (DSDPT, Cint, Cdouble), dsdp, arg2, arg3)
end

function AddObjectiveConstant(dsdp::DSDPT, arg2::Cdouble)
    ccall((:DSDPAddObjectiveConstant, libdsdp), Cint, (DSDPT, Cdouble), dsdp, arg2)
end

function GetDObjective(dsdp::DSDPT)
    dobj = Ref{Cdouble}()
    ccall((:DSDPGetDObjective, libdsdp), Cint, (DSDPT, Ref{Cdouble}), dsdp, dobj)
    dobj[]
end

function GetDDObjective(dsdp::DSDPT)
    ddobj = Ref{Cdouble}()
    ccall((:DSDPGetDDObjective, libdsdp), Cint, (DSDPT, Ref{Cdouble}), dsdp, ddobj)
    ddobj[]
end

function GetPObjective(dsdp::DSDPT)
    pobj = Ref{Cdouble}()
    ccall((:DSDPGetPObjective, libdsdp), Cint, (DSDPT, Ptr{Cdouble}), dsdp, pobj)
    pobj[]
end

function GetPPObjective(dsdp::DSDPT)
    ppobj = Ref{Cdouble}()
    ccall((:DSDPGetPPObjective, libdsdp), Cint, (DSDPT, Ptr{Cdouble}), dsdp, ppobj)
    ppobj[]
end

function GetDualityGap(dsdp::DSDPT)
    dgap = Ref{Cdouble}()
    ccall((:DSDPGetDualityGap, libdsdp), Cint, (DSDPT, Ptr{Cdouble}), dsdp, dgap)
    dgap[]
end

function GetScale(dsdp::DSDPT, arg2)
    ccall((:DSDPGetScale, libdsdp), Cint, (DSDPT, Ptr{Cdouble}), dsdp, arg2)
end

function SetScale(dsdp::DSDPT, arg2::Cdouble)
    ccall((:DSDPSetScale, libdsdp), Cint, (DSDPT, Cdouble), dsdp, arg2)
end

function GetPenaltyParameter(dsdp::DSDPT, arg2)
    ccall((:DSDPGetPenaltyParameter, libdsdp), Cint, (DSDPT, Ptr{Cdouble}), dsdp, arg2)
end

function GetPenalty(dsdp::DSDPT, arg2)
    ccall((:DSDPGetPenalty, libdsdp), Cint, (DSDPT, Ptr{Cdouble}), dsdp, arg2)
end

function CopyB(dsdp::DSDPT, arg2, arg3::Integer)
    ccall((:DSDPCopyB, libdsdp), Cint, (DSDPT, Ptr{Cdouble}, Cint), dsdp, arg2, arg3)
end

function SetR0(dsdp::DSDPT, arg2::Cdouble)
    ccall((:DSDPSetR0, libdsdp), Cint, (DSDPT, Cdouble), dsdp, arg2)
end

function GetR(dsdp::DSDPT, arg2)
    ccall((:DSDPGetR, libdsdp), Cint, (DSDPT, Ptr{Cdouble}), dsdp, arg2)
end

function SetRTolerance(dsdp::DSDPT, arg2::Cdouble)
    ccall((:DSDPSetRTolerance, libdsdp), Cint, (DSDPT, Cdouble), dsdp, arg2)
end

function GetRTolerance(dsdp::DSDPT, arg2)
    ccall((:DSDPGetRTolerance, libdsdp), Cint, (DSDPT, Ptr{Cdouble}), dsdp, arg2)
end

function SetY0(dsdp::DSDPT, arg2::Integer, arg3::Cdouble)
    ccall((:DSDPSetY0, libdsdp), Cint, (DSDPT, Cint, Cdouble), dsdp, arg2, arg3)
end

function GetY(dsdp::DSDPT, arg2, arg3::Integer)
    ccall((:DSDPGetY, libdsdp), Cint, (DSDPT, Ptr{Cdouble}, Cint), dsdp, arg2, arg3)
end

function GetYMakeX(dsdp::DSDPT, arg2, arg3::Integer)
    ccall((:DSDPGetYMakeX, libdsdp), Cint, (DSDPT, Ptr{Cdouble}, Cint), dsdp, arg2, arg3)
end

function GetDYMakeX(dsdp::DSDPT, arg2, arg3::Integer)
    ccall((:DSDPGetDYMakeX, libdsdp), Cint, (DSDPT, Ptr{Cdouble}, Cint), dsdp, arg2, arg3)
end

function GetMuMakeX(dsdp::DSDPT, arg2)
    ccall((:DSDPGetMuMakeX, libdsdp), Cint, (DSDPT, Ptr{Cdouble}), dsdp, arg2)
end

function GetBarrierParameter(dsdp::DSDPT, arg2)
    ccall((:DSDPGetBarrierParameter, libdsdp), Cint, (DSDPT, Ptr{Cdouble}), dsdp, arg2)
end

function SetBarrierParameter(dsdp::DSDPT, arg2::Cdouble)
    ccall((:DSDPSetBarrierParameter, libdsdp), Cint, (DSDPT, Cdouble), dsdp, arg2)
end

function ReuseMatrix(dsdp::DSDPT, arg2::Integer)
    ccall((:DSDPReuseMatrix, libdsdp), Cint, (DSDPT, Cint), dsdp, arg2)
end

function GetReuseMatrix(dsdp::DSDPT, arg2)
    ccall((:DSDPGetReuseMatrix, libdsdp), Cint, (DSDPT, Ptr{Cint}), dsdp, arg2)
end

function GetDimension(dsdp::DSDPT, arg2)
    ccall((:DSDPGetDimension, libdsdp), Cint, (DSDPT, Ptr{Cdouble}), dsdp, arg2)
end

function SetMaxIts(dsdp::DSDPT, arg2::Integer)
    ccall((:DSDPSetMaxIts, libdsdp), Cint, (DSDPT, Cint), dsdp, arg2)
end

function GetMaxIts(dsdp::DSDPT, arg2)
    ccall((:DSDPGetMaxIts, libdsdp), Cint, (DSDPT, Ptr{Cint}), dsdp, arg2)
end

function SetStepTolerance(dsdp::DSDPT, arg2::Cdouble)
    ccall((:DSDPSetStepTolerance, libdsdp), Cint, (DSDPT, Cdouble), dsdp, arg2)
end

function GetStepTolerance(dsdp::DSDPT, arg2)
    ccall((:DSDPGetStepTolerance, libdsdp), Cint, (DSDPT, Ptr{Cdouble}), dsdp, arg2)
end

function SetGapTolerance(dsdp::DSDPT, arg2::Cdouble)
    ccall((:DSDPSetGapTolerance, libdsdp), Cint, (DSDPT, Cdouble), dsdp, arg2)
end

function GetGapTolerance(dsdp::DSDPT, arg2)
    ccall((:DSDPGetGapTolerance, libdsdp), Cint, (DSDPT, Ptr{Cdouble}), dsdp, arg2)
end

function SetPNormTolerance(dsdp::DSDPT, arg2::Real)
    ccall((:DSDPSetPNormTolerance, libdsdp), Cint, (DSDPT, Cdouble), dsdp, arg2)
end

function GetPNormTolerance(dsdp::DSDPT, arg2)
    ccall((:DSDPGetPNormTolerance, libdsdp), Cint, (DSDPT, Ptr{Cdouble}), dsdp, arg2)
end

function SetDualBound(dsdp::DSDPT, arg2::Cdouble)
    ccall((:DSDPSetDualBound, libdsdp), Cint, (DSDPT, Cdouble), dsdp, arg2)
end

function GetDualBound(dsdp::DSDPT, arg2)
    ccall((:DSDPGetDualBound, libdsdp), Cint, (DSDPT, Ptr{Cdouble}), dsdp, arg2)
end

function SetPTolerance(dsdp::DSDPT, arg2::Cdouble)
    ccall((:DSDPSetPTolerance, libdsdp), Cint, (DSDPT, Cdouble), dsdp, arg2)
end

function GetPTolerance(dsdp::DSDPT, arg2)
    ccall((:DSDPGetPTolerance, libdsdp), Cint, (DSDPT, Ptr{Cdouble}), dsdp, arg2)
end

function GetPInfeasibility(dsdp::DSDPT, arg2)
    ccall((:DSDPGetPInfeasibility, libdsdp), Cint, (DSDPT, Ptr{Cdouble}), dsdp, arg2)
end

function SetMaxTrustRadius(dsdp::DSDPT, arg2::Cdouble)
    ccall((:DSDPSetMaxTrustRadius, libdsdp), Cint, (DSDPT, Cdouble), dsdp, arg2)
end

function GetMaxTrustRadius(dsdp::DSDPT, arg2)
    ccall((:DSDPGetMaxTrustRadius, libdsdp), Cint, (DSDPT, Ptr{Cdouble}), dsdp, arg2)
end

function StopReason(dsdp::DSDPT)
    stop = Ref{DSDPTerminationReason}()
    ccall((:DSDPStopReason, libdsdp), Cint, (DSDPT, Ref{DSDPTerminationReason}), dsdp, stop)
    stop[]
end

function GetSolutionType(dsdp::DSDPT, arg2)
    ccall((:DSDPGetSolutionType, libdsdp), Cint, (DSDPT, Ptr{DSDPSolutionType}), dsdp, arg2)
end

function SetPotentialParameter(dsdp::DSDPT, arg2::Real)
    ccall((:DSDPSetPotentialParameter, libdsdp), Cint, (DSDPT, Cdouble), dsdp, arg2)
end

function GetPotentialParameter(dsdp::DSDPT, arg2)
    ccall((:DSDPGetPotentialParameter, libdsdp), Cint, (DSDPT, Ptr{Cdouble}), dsdp, arg2)
end

function UseDynamicRho(dsdp::DSDPT, arg2::Integer)
    ccall((:DSDPUseDynamicRho, libdsdp), Cint, (DSDPT, Cint), dsdp, arg2)
end

function GetPotential(dsdp::DSDPT, arg2)
    ccall((:DSDPGetPotential, libdsdp), Cint, (DSDPT, Ptr{Cdouble}), dsdp, arg2)
end

function UseLAPACKForSchur(dsdp::DSDPT, arg2::Integer)
    ccall((:DSDPUseLAPACKForSchur, libdsdp), Cint, (DSDPT, Cint), dsdp, arg2)
end

function GetNumberOfVariables(dsdp::DSDPT, arg2)
    ccall((:DSDPGetNumberOfVariables, libdsdp), Cint, (DSDPT, Ptr{Cint}), dsdp, arg2)
end

function GetFinalErrors(dsdp::DSDPT, arg2::NTuple{6, Cdouble})
    ccall((:DSDPGetFinalErrors, libdsdp), Cint, (DSDPT, NTuple{6, Cdouble}), dsdp, arg2)
end

function GetGapHistory(dsdp::DSDPT, arg2, arg3::Integer)
    ccall((:DSDPGetGapHistory, libdsdp), Cint, (DSDPT, Ptr{Cdouble}, Cint), dsdp, arg2, arg3)
end

function GetRHistory(dsdp::DSDPT, arg2, arg3::Integer)
    ccall((:DSDPGetRHistory, libdsdp), Cint, (DSDPT, Ptr{Cdouble}, Cint), dsdp, arg2, arg3)
end

function GetIts(dsdp::DSDPT, arg2)
    ccall((:DSDPGetIts, libdsdp), Cint, (DSDPT, Ptr{Cint}), dsdp, arg2)
end

function GetPnorm(dsdp::DSDPT, arg2)
    ccall((:DSDPGetPnorm, libdsdp), Cint, (DSDPT, Ptr{Cdouble}), dsdp, arg2)
end

function GetStepLengths(dsdp::DSDPT, arg2, arg3)
    ccall((:DSDPGetStepLengths, libdsdp), Cint, (DSDPT, Ptr{Cdouble}, Ptr{Cdouble}), dsdp, arg2, arg3)
end

function SetMonitor(dsdp::DSDPT, arg2, arg3)
    ccall((:DSDPSetMonitor, libdsdp), Cint, (DSDPT, DSDPT, DSDPT), dsdp, arg2, arg3)
end

function SetStandardMonitor(dsdp::DSDPT, arg2::Integer)
    ccall((:DSDPSetStandardMonitor, libdsdp), Cint, (DSDPT, Cint), dsdp, arg2)
end

function SetFileMonitor(dsdp::DSDPT, arg2::Integer)
    ccall((:DSDPSetFileMonitor, libdsdp), Cint, (DSDPT, Cint), dsdp, arg2)
end

function SetPenaltyParameter(dsdp::DSDPT, arg2::Cdouble)
    ccall((:DSDPSetPenaltyParameter, libdsdp), Cint, (DSDPT, Cdouble), dsdp, arg2)
end

function UsePenalty(dsdp::DSDPT, arg2::Integer)
    ccall((:DSDPUsePenalty, libdsdp), Cint, (DSDPT, Cint), dsdp, arg2)
end

function PrintLogInfo(arg1::Integer)
    ccall((:DSDPPrintLogInfo, libdsdp), Cint, (Cint,), arg1)
end

function ComputeMinimumXEigenvalue(dsdp::DSDPT, arg2)
    ccall((:DSDPComputeMinimumXEigenvalue, libdsdp), Cint, (DSDPT, Ptr{Cdouble}), dsdp, arg2)
end

function GetTraceX(dsdp::DSDPT, arg1)
    ccall((:DSDPGetTraceX, libdsdp), Cint, (DSDPT, Ptr{Cdouble}), dsdp, arg1)
end

function SetZBar(dsdp::DSDPT, arg2::Cdouble)
    ccall((:DSDPSetZBar, libdsdp), Cint, (DSDPT, Cdouble), dsdp, arg2)
end

function SetDualLowerBound(dsdp::DSDPT, arg2::Cdouble)
    ccall((:DSDPSetDualLowerBound, libdsdp), Cint, (DSDPT, Cdouble), dsdp, arg2)
end

function GetDataNorms(dsdp::DSDPT, arg2::NTuple{3, Cdouble})
    ccall((:DSDPGetDataNorms, libdsdp), Cint, (DSDPT, NTuple{3, Cdouble}), dsdp, arg2)
end

function GetYMaxNorm(dsdp::DSDPT, arg2)
    ccall((:DSDPGetYMaxNorm, libdsdp), Cint, (DSDPT, Ptr{Cdouble}), dsdp, arg2)
end

function SDPConeUseFullSymmetricFormat(arg1::SDPCone, arg2::Integer)
    ccall((:SDPConeUseFullSymmetricFormat, libdsdp), Cint, (SDPCone, Cint), arg1, arg2)
end

function SDPConeUsePackedFormat(arg1::SDPCone, arg2::Integer)
    ccall((:SDPConeUsePackedFormat, libdsdp), Cint, (SDPCone, Cint), arg1, arg2)
end

function SetFixedVariable(dsdp::DSDPT, arg2::Integer, arg3::Cdouble)
    ccall((:DSDPSetFixedVariable, libdsdp), Cint, (DSDPT, Cint, Cdouble), dsdp, arg2, arg3)
end

function SetFixedVariables(dsdp::DSDPT, arg2, arg3, arg4, arg5::Integer)
    ccall((:DSDPSetFixedVariables, libdsdp), Cint, (DSDPT, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cint), dsdp, arg2, arg3, arg4, arg5)
end

function GetFixedYX(dsdp::DSDPT, arg2::Integer, arg3)
    ccall((:DSDPGetFixedYX, libdsdp), Cint, (DSDPT, Cint, Ptr{Cdouble}), dsdp, arg2, arg3)
end

function View(dsdp::DSDPT)
    ccall((:DSDPView, libdsdp), Cint, (DSDPT,), dsdp)
end

function PrintOptions()
    ccall((:DSDPPrintOptions, libdsdp), Cint, ())
end

function PrintData(dsdp::DSDPT, arg2::SDPCone, arg3::LPCone)
    ccall((:DSDPPrintData, libdsdp), Cint, (DSDPT, SDPCone, LPCone), dsdp, arg2, arg3)
end

#function PrintSolution(arg1, arg2::DSDPT, arg3::SDPCone, arg4::LPCone)
#    ccall((:DSDPPrintSolution, libdsdp), Cint, (Ptr{FILE}, DSDP, SDPCone, LPCone), arg1, arg2, arg3, arg4)
#end

function SetOptions(dsdp::DSDPT, arg2, arg3::Integer)
    ccall((:DSDPSetOptions, libdsdp), Cint, (DSDPT, Ptr{Cstring}, Cint), dsdp, arg2, arg3)
end

function ReadOptions(dsdp::DSDPT, arg2)
    ccall((:DSDPReadOptions, libdsdp), Cint, (DSDPT, Ptr{UInt8}), dsdp, arg2)
end

function SetDestroyRoutine(dsdp::DSDPT, arg2, arg3)
    ccall((:DSDPSetDestroyRoutine, libdsdp), Cint, (DSDPT, DSDPT, DSDPT), dsdp, arg2, arg3)
end
