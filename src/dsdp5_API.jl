# Julia wrapper for header: include/dsdp5.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function SetConvergenceFlag(dsdp::DSDPT, arg2::DSDPTerminationReason)
    @dsdp_ccall DSDPSetConvergenceFlag (DSDPT, DSDPTerminationReason) dsdp arg2
end

function Create(m::Integer)
    dsdp = Ref{DSDPT}()
    @dsdp_ccall DSDPCreate (Cint, Ref{DSDPT}) m dsdp
    dsdp[]
end

function Setup(dsdp::DSDPT)
    @dsdp_ccall DSDPSetup (DSDPT,) dsdp
end

function Solve(dsdp::DSDPT)
    @dsdp_ccall DSDPSolve (DSDPT,) dsdp
end

function ComputeX(dsdp::DSDPT)
    @dsdp_ccall DSDPComputeX (DSDPT,) dsdp
end

function ComputeAndFactorS(dsdp::DSDPT, arg2)
    @dsdp_ccall DSDPComputeAndFactorS (DSDPT, Ptr{DSDPTruth}) dsdp arg2
end

function Destroy(dsdp::DSDPT)
    @dsdp_ccall DSDPDestroy (DSDPT,) dsdp
end

function CreateBCone(dsdp::DSDPT)
    bcone = Ref{BCone}()
    @dsdp_ccall DSDPCreateBCone (DSDPT, Ref{BCone}) dsdp bcone
    bcone[]
end

function BConeAllocateBounds(arg1::BCone, arg2::Integer)
    @dsdp_ccall BConeAllocateBounds (BCone, Cint) arg1 arg2
end

function BConeSetLowerBound(arg1::BCone, arg2::Integer, arg3::Cdouble)
    @dsdp_ccall BConeSetLowerBound (BCone, Cint, Cdouble) arg1 arg2 arg3
end

function BConeSetUpperBound(arg1::BCone, arg2::Integer, arg3::Cdouble)
    @dsdp_ccall BConeSetUpperBound (BCone, Cint, Cdouble) arg1 arg2 arg3
end

function BConeSetPSlackVariable(arg1::BCone, arg2::Integer)
    @dsdp_ccall BConeSetPSlackVariable (BCone, Cint) arg1 arg2
end

function BConeSetPSurplusVariable(arg1::BCone, arg2::Integer)
    @dsdp_ccall BConeSetPSurplusVariable (BCone, Cint) arg1 arg2
end

function BConeScaleBarrier(arg1::BCone, arg2::Cdouble)
    @dsdp_ccall BConeScaleBarrier (BCone, Cdouble) arg1 arg2
end

function BConeView(arg1::BCone)
    @dsdp_ccall BConeView (BCone,) arg1
end

function BConeSetXArray(arg1::BCone, arg2, arg3::Integer)
    @dsdp_ccall BConeSetXArray (BCone, Ptr{Cdouble}, Cint) arg1 arg2 arg3
end

function BConeCopyX(arg1::BCone, arg2, arg3, arg4::Integer)
    @dsdp_ccall BConeCopyX (BCone, Ptr{Cdouble}, Ptr{Cdouble}, Cint) arg1 arg2 arg3 arg4
end

function BoundDualVariables(dsdp::DSDPT, arg2::Cdouble, arg3::Cdouble)
    @dsdp_ccall DSDPBoundDualVariables (DSDPT, Cdouble, Cdouble) dsdp arg2 arg3
end

function SetYBounds(dsdp::DSDPT, arg2::Cdouble, arg3::Cdouble)
    @dsdp_ccall DSDPSetYBounds (DSDPT, Cdouble, Cdouble) dsdp arg2 arg3
end

function GetYBounds(dsdp::DSDPT, arg2, arg3)
    @dsdp_ccall DSDPGetYBounds (DSDPT, Ptr{Cdouble}, Ptr{Cdouble}) dsdp arg2 arg3
end

function CreateLPCone(dsdp::DSDPT, arg2)
    @dsdp_ccall DSDPCreateLPCone (DSDPT, Ptr{LPCone}) dsdp arg2
end

function LPConeSetData(arg1::LPCone, arg2::Integer, arg3, arg4, arg5)
    @dsdp_ccall LPConeSetData (LPCone, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}) arg1 arg2 arg3 arg4 arg5
end

function LPConeSetData2(arg1::LPCone, arg2::Integer, arg3, arg4, arg5)
    @dsdp_ccall LPConeSetData2 (LPCone, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}) arg1 arg2 arg3 arg4 arg5
end

function LPConeGetData(arg1::LPCone, arg2::Integer, arg3, arg4::Integer)
    @dsdp_ccall LPConeGetData (LPCone, Cint, Ptr{Cdouble}, Cint) arg1 arg2 arg3 arg4
end

function LPConeScaleBarrier(arg1::LPCone, arg2::Cdouble)
    @dsdp_ccall LPConeScaleBarrier (LPCone, Cdouble) arg1 arg2
end

function LPConeGetXArray(arg1::LPCone, arg2, arg3)
    @dsdp_ccall LPConeGetXArray (LPCone, Ptr{Ptr{Cdouble}}, Ptr{Cint}) arg1 arg2 arg3
end

function LPConeGetSArray(arg1::LPCone, arg2, arg3)
    @dsdp_ccall LPConeGetSArray (LPCone, Ptr{Ptr{Cdouble}}, Ptr{Cint}) arg1 arg2 arg3
end

function LPConeGetDimension(arg1::LPCone, arg2)
    @dsdp_ccall LPConeGetDimension (LPCone, Ptr{Cint}) arg1 arg2
end

function LPConeView(lpcone::LPCone)
    @dsdp_ccall LPConeView (LPCone,) lpcone
end

function LPConeView2(lpcone::LPCone)
    @dsdp_ccall LPConeView2 (LPCone,) lpcone
end

function LPConeCopyS(arg1::LPCone, arg2, arg3::Integer)
    @dsdp_ccall LPConeCopyS (LPCone, Ptr{Cdouble}, Cint) arg1 arg2 arg3
end

function CreateSDPCone(dsdp::DSDPT, n::Integer)
    sdpcone = Ref{SDPCone}()
    @dsdp_ccall DSDPCreateSDPCone (DSDPT, Cint, Ref{SDPCone}) dsdp n sdpcone
    sdpcone[]
end
function CreateSDPCone(dsdp::DSDPT, arg2::Integer, arg3)
    @dsdp_ccall DSDPCreateSDPCone (DSDPT, Cint, Ptr{SDPCone}) dsdp arg2 arg3
end

function SDPConeSetBlockSize(sdpcone::SDPCone, i::Integer, j::Integer)
    @dsdp_ccall SDPConeSetBlockSize (SDPCone, Cint, Cint) sdpcone i j
end

function SDPConeGetBlockSize(arg1::SDPCone, arg2::Integer, arg3)
    @dsdp_ccall SDPConeGetBlockSize (SDPCone, Cint, Ptr{Cint}) arg1 arg2 arg3
end

function SDPConeSetStorageFormat(arg1::SDPCone, arg2::Integer, arg3::UInt8)
    @dsdp_ccall SDPConeSetStorageFormat (SDPCone, Cint, UInt8) arg1 arg2 arg3
end

function SDPConeGetStorageFormat(arg1::SDPCone, arg2::Integer, arg3)
    @dsdp_ccall SDPConeGetStorageFormat (SDPCone, Cint, Cstring) arg1 arg2 arg3
end

function SDPConeCheckStorageFormat(arg1::SDPCone, arg2::Integer, arg3::UInt8)
    @dsdp_ccall SDPConeCheckStorageFormat (SDPCone, Cint, UInt8) arg1 arg2 arg3
end

function SDPConeSetSparsity(arg1::SDPCone, arg2::Integer, arg3::Integer)
    @dsdp_ccall SDPConeSetSparsity (SDPCone, Cint, Cint) arg1 arg2 arg3
end

function SDPConeView(arg1::SDPCone)
    @dsdp_ccall SDPConeView (SDPCone,) arg1
end

function SDPConeView2(arg1::SDPCone)
    @dsdp_ccall SDPConeView2 (SDPCone,) arg1
end

function SDPConeView3(arg1::SDPCone)
    @dsdp_ccall SDPConeView3 (SDPCone,) arg1
end

function SDPConeSetASparseVecMat(arg1::SDPCone, arg2::Integer, arg3::Integer, arg4::Integer, arg5::Cdouble, arg6::Integer, arg7, arg8, arg9::Integer)
    @dsdp_ccall SDPConeSetASparseVecMat (SDPCone, Cint, Cint, Cint, Cdouble, Cint, Ptr{Cint}, Ptr{Cdouble}, Cint) arg1 arg2 arg3 arg4 arg5 arg6 arg7 arg8 arg9
end

function SDPConeSetADenseVecMat(arg1::SDPCone, arg2::Integer, arg3::Integer, arg4::Integer, arg5::Cdouble, arg6, arg7::Integer)
    @dsdp_ccall SDPConeSetADenseVecMat (SDPCone, Cint, Cint, Cint, Cdouble, Ptr{Cdouble}, Cint) arg1 arg2 arg3 arg4 arg5 arg6 arg7
end

function SDPConeSetARankOneMat(arg1::SDPCone, arg2::Integer, arg3::Integer, arg4::Integer, arg5::Cdouble, arg6::Integer, arg7, arg8, arg9::Integer)
    @dsdp_ccall SDPConeSetARankOneMat (SDPCone, Cint, Cint, Cint, Cdouble, Cint, Ptr{Cint}, Ptr{Cdouble}, Cint) arg1 arg2 arg3 arg4 arg5 arg6 arg7 arg8 arg9
end

function SDPConeSetConstantMat(arg1::SDPCone, arg2::Integer, arg3::Integer, arg4::Integer, arg5::Cdouble)
    @dsdp_ccall SDPConeSetConstantMat (SDPCone, Cint, Cint, Cint, Cdouble) arg1 arg2 arg3 arg4 arg5
end

function SDPConeSetZeroMat(arg1::SDPCone, arg2::Integer, arg3::Integer, arg4::Integer)
    @dsdp_ccall SDPConeSetZeroMat (SDPCone, Cint, Cint, Cint) arg1 arg2 arg3 arg4
end

function SDPConeSetIdentity(arg1::SDPCone, arg2::Integer, arg3::Integer, arg4::Integer, arg5::Cdouble)
    @dsdp_ccall SDPConeSetIdentity (SDPCone, Cint, Cint, Cint, Cdouble) arg1 arg2 arg3 arg4 arg5
end

function SDPConeViewDataMatrix(arg1::SDPCone, arg2::Integer, arg3::Integer)
    @dsdp_ccall SDPConeViewDataMatrix (SDPCone, Cint, Cint) arg1 arg2 arg3
end

function SDPConeMatrixView(arg1::SDPCone, arg2::Integer)
    @dsdp_ccall SDPConeMatrixView (SDPCone, Cint) arg1 arg2
end

function SDPConeAddASparseVecMat(arg1::SDPCone, arg2::Integer, arg3::Integer, arg4::Integer, arg5::Cdouble, arg6::Integer, arg7, arg8, arg9::Integer)
    @dsdp_ccall SDPConeAddASparseVecMat (SDPCone, Cint, Cint, Cint, Cdouble, Cint, Ptr{Cint}, Ptr{Cdouble}, Cint) arg1 arg2 arg3 arg4 arg5 arg6 arg7 arg8 arg9
end

function SDPConeAddADenseVecMat(arg1::SDPCone, arg2::Integer, arg3::Integer, arg4::Integer, arg5::Cdouble, arg6, arg7::Integer)
    @dsdp_ccall SDPConeAddADenseVecMat (SDPCone, Cint, Cint, Cint, Cdouble, Ptr{Cdouble}, Cint) arg1 arg2 arg3 arg4 arg5 arg6 arg7
end

function SDPConeAddConstantMat(arg1::SDPCone, arg2::Integer, arg3::Integer, arg4::Integer, arg5::Cdouble)
    @dsdp_ccall SDPConeAddConstantMat (SDPCone, Cint, Cint, Cint, Cdouble) arg1 arg2 arg3 arg4 arg5
end

function SDPConeAddIdentity(arg1::SDPCone, arg2::Integer, arg3::Integer, arg4::Integer, arg5::Cdouble)
    @dsdp_ccall SDPConeAddIdentity (SDPCone, Cint, Cint, Cint, Cdouble) arg1 arg2 arg3 arg4 arg5
end

function SDPConeAddARankOneMat(arg1::SDPCone, arg2::Integer, arg3::Integer, arg4::Integer, arg5::Cdouble, arg6::Integer, arg7, arg8, arg9::Integer)
    @dsdp_ccall SDPConeAddARankOneMat (SDPCone, Cint, Cint, Cint, Cdouble, Cint, Ptr{Cint}, Ptr{Cdouble}, Cint) arg1 arg2 arg3 arg4 arg5 arg6 arg7 arg8 arg9
end

function SDPConeAddSparseVecMat(arg1::SDPCone, arg2::Integer, arg3::Integer, arg4::Integer, arg5::Integer, arg6, arg7, arg8::Integer)
    @dsdp_ccall SDPConeAddSparseVecMat (SDPCone, Cint, Cint, Cint, Cint, Ptr{Cint}, Ptr{Cdouble}, Cint) arg1 arg2 arg3 arg4 arg5 arg6 arg7 arg8
end

function SDPConeAddDenseVecMat(arg1::SDPCone, arg2::Integer, arg3::Integer, arg4::Integer, arg5, arg6::Integer)
    @dsdp_ccall SDPConeAddDenseVecMat (SDPCone, Cint, Cint, Cint, Ptr{Cdouble}, Cint) arg1 arg2 arg3 arg4 arg5 arg6
end

function SDPConeSetSparseVecMat(arg1::SDPCone, arg2::Integer, arg3::Integer, arg4::Integer, arg5::Integer, arg6, arg7, arg8::Integer)
    @dsdp_ccall SDPConeSetSparseVecMat (SDPCone, Cint, Cint, Cint, Cint, Ptr{Cint}, Ptr{Cdouble}, Cint) arg1 arg2 arg3 arg4 arg5 arg6 arg7 arg8
end

function SDPConeSetDenseVecMat(arg1::SDPCone, arg2::Integer, arg3::Integer, arg4::Integer, arg5, arg6::Integer)
    @dsdp_ccall SDPConeSetDenseVecMat (SDPCone, Cint, Cint, Cint, Ptr{Cdouble}, Cint) arg1 arg2 arg3 arg4 arg5 arg6
end

function SDPConeSetXMat(arg1::SDPCone, arg2::Integer, arg3::Integer)
    @dsdp_ccall SDPConeSetXMat (SDPCone, Cint, Cint) arg1 arg2 arg3
end

function SDPConeSetXArray(arg1::SDPCone, arg2::Integer, arg3::Integer, arg4, arg5::Integer)
    @dsdp_ccall SDPConeSetXArray (SDPCone, Cint, Cint, Ptr{Cdouble}, Cint) arg1 arg2 arg3 arg4 arg5
end

function SDPConeGetXArray(arg1::SDPCone, arg2::Integer, arg3, arg4)
    @dsdp_ccall SDPConeGetXArray (SDPCone, Cint, Ptr{Ptr{Cdouble}}, Ptr{Cint}) arg1 arg2 arg3 arg4
end

function SDPConeRestoreXArray(arg1::SDPCone, arg2::Integer, arg3, arg4)
    @dsdp_ccall SDPConeRestoreXArray (SDPCone, Cint, Ptr{Ptr{Cdouble}}, Ptr{Cint}) arg1 arg2 arg3 arg4
end

function SDPConeCheckData(arg1::SDPCone)
    @dsdp_ccall SDPConeCheckData (SDPCone,) arg1
end

function SDPConeRemoveDataMatrix(arg1::SDPCone, arg2::Integer, arg3::Integer)
    @dsdp_ccall SDPConeRemoveDataMatrix (SDPCone, Cint, Cint) arg1 arg2 arg3
end

function SDPConeGetNumberOfBlocks(arg1::SDPCone, arg2)
    @dsdp_ccall SDPConeGetNumberOfBlocks (SDPCone, Ptr{Cint}) arg1 arg2
end

function SDPConeComputeS(arg1::SDPCone, arg2::Integer, arg3::Cdouble, arg4, arg5::Integer, arg6::Cdouble, arg7::Integer, arg8, arg9::Integer)
    @dsdp_ccall SDPConeComputeS (SDPCone, Cint, Cdouble, Ptr{Cdouble}, Cint, Cdouble, Cint, Ptr{Cdouble}, Cint) arg1 arg2 arg3 arg4 arg5 arg6 arg7 arg8 arg9
end

function SDPConeComputeX(arg1::SDPCone, arg2::Integer, arg3::Integer, arg4, arg5::Integer)
    @dsdp_ccall SDPConeComputeX (SDPCone, Cint, Cint, Ptr{Cdouble}, Cint) arg1 arg2 arg3 arg4 arg5
end

function SDPConeAddADotX(arg1::SDPCone, arg2::Integer, arg3::Cdouble, arg4, arg5::Integer, arg6, arg7::Integer)
    @dsdp_ccall SDPConeAddADotX (SDPCone, Cint, Cdouble, Ptr{Cdouble}, Cint, Ptr{Cdouble}, Cint) arg1 arg2 arg3 arg4 arg5 arg6 arg7
end

function SDPConeViewX(arg1::SDPCone, arg2::Integer, arg3::Integer, arg4, arg5::Integer)
    @dsdp_ccall SDPConeViewX (SDPCone, Cint, Cint, Ptr{Cdouble}, Cint) arg1 arg2 arg3 arg4 arg5
end

function SDPConeSetLanczosIterations(arg1::SDPCone, arg2::Integer)
    @dsdp_ccall SDPConeSetLanczosIterations (SDPCone, Cint) arg1 arg2
end

function SDPConeScaleBarrier(arg1::SDPCone, arg2::Integer, arg3::Cdouble)
    @dsdp_ccall SDPConeScaleBarrier (SDPCone, Cint, Cdouble) arg1 arg2 arg3
end

function SDPConeXVMultiply(sdpcone::SDPCone, arg2::Integer, arg3::Vector, arg4::Vector)
    n = length(arg3)
    @assert n == length(arg4)
    @dsdp_ccall SDPConeXVMultiply (SDPCone, Cint, Ptr{Cdouble}, Ptr{Cdouble}, Cint) sdpcone arg2 pointer(arg3) pointer(arg4) n
end

function SDPConeComputeXV(sdpcone::SDPCone, arg2::Integer)
    derror = Ref{Cint}()
    @dsdp_ccall SDPConeComputeXV (SDPCone, Cint, Ref{Cint}) sdpcone arg2 derror
    derror[]
end

function SDPConeAddXVAV(arg1::SDPCone, arg2::Integer, arg3::Vector, arg5::Vector)
    @dsdp_ccall SDPConeAddXVAV (SDPCone, Cint, Ptr{Cdouble}, Cint, Ptr{Cdouble}, Cint) arg1 arg2 pointer(arg3) length(arg3) pointer(arg5) length(arg5)
end

function SDPConeUseLAPACKForDualMatrix(arg1::SDPCone, arg2::Integer)
    @dsdp_ccall SDPConeUseLAPACKForDualMatrix (SDPCone, Cint) arg1 arg2
end

function SetDualObjective(dsdp::DSDPT, arg2::Integer, arg3::Cdouble)
    @dsdp_ccall DSDPSetDualObjective (DSDPT, Cint, Cdouble) dsdp arg2 arg3
end

function AddObjectiveConstant(dsdp::DSDPT, arg2::Cdouble)
    @dsdp_ccall DSDPAddObjectiveConstant (DSDPT, Cdouble) dsdp arg2
end

function GetDObjective(dsdp::DSDPT)
    dobj = Ref{Cdouble}()
    @dsdp_ccall DSDPGetDObjective (DSDPT, Ref{Cdouble}) dsdp dobj
    dobj[]
end

function GetDDObjective(dsdp::DSDPT)
    ddobj = Ref{Cdouble}()
    @dsdp_ccall DSDPGetDDObjective (DSDPT, Ref{Cdouble}) dsdp ddobj
    ddobj[]
end

function GetPObjective(dsdp::DSDPT)
    pobj = Ref{Cdouble}()
    @dsdp_ccall DSDPGetPObjective (DSDPT, Ptr{Cdouble}) dsdp pobj
    pobj[]
end

function GetPPObjective(dsdp::DSDPT)
    ppobj = Ref{Cdouble}()
    @dsdp_ccall DSDPGetPPObjective (DSDPT, Ptr{Cdouble}) dsdp ppobj
    ppobj[]
end

function GetDualityGap(dsdp::DSDPT)
    dgap = Ref{Cdouble}()
    @dsdp_ccall DSDPGetDualityGap (DSDPT, Ptr{Cdouble}) dsdp dgap
    dgap[]
end

function GetScale(dsdp::DSDPT, arg2)
    @dsdp_ccall DSDPGetScale (DSDPT, Ptr{Cdouble}) dsdp arg2
end

function SetScale(dsdp::DSDPT, arg2::Cdouble)
    @dsdp_ccall DSDPSetScale (DSDPT, Cdouble) dsdp arg2
end

function GetPenaltyParameter(dsdp::DSDPT, arg2)
    @dsdp_ccall DSDPGetPenaltyParameter (DSDPT, Ptr{Cdouble}) dsdp arg2
end

function GetPenalty(dsdp::DSDPT, arg2)
    @dsdp_ccall DSDPGetPenalty (DSDPT, Ptr{Cdouble}) dsdp arg2
end

function CopyB(dsdp::DSDPT, arg2, arg3::Integer)
    @dsdp_ccall DSDPCopyB (DSDPT, Ptr{Cdouble}, Cint) dsdp arg2 arg3
end

function SetR0(dsdp::DSDPT, arg2::Cdouble)
    @dsdp_ccall DSDPSetR0 (DSDPT, Cdouble) dsdp arg2
end

function GetR(dsdp::DSDPT, arg2)
    @dsdp_ccall DSDPGetR (DSDPT, Ptr{Cdouble}) dsdp arg2
end

function SetRTolerance(dsdp::DSDPT, arg2::Cdouble)
    @dsdp_ccall DSDPSetRTolerance (DSDPT, Cdouble) dsdp arg2
end

function GetRTolerance(dsdp::DSDPT, arg2)
    @dsdp_ccall DSDPGetRTolerance (DSDPT, Ptr{Cdouble}) dsdp arg2
end

function SetY0(dsdp::DSDPT, arg2::Integer, arg3::Cdouble)
    @dsdp_ccall DSDPSetY0 (DSDPT, Cint, Cdouble) dsdp arg2 arg3
end

function GetY(dsdp::DSDPT, arg2, arg3::Integer)
    @dsdp_ccall DSDPGetY (DSDPT, Ptr{Cdouble}, Cint) dsdp arg2 arg3
end

function GetYMakeX(dsdp::DSDPT, arg2, arg3::Integer)
    @dsdp_ccall DSDPGetYMakeX (DSDPT, Ptr{Cdouble}, Cint) dsdp arg2 arg3
end

function GetDYMakeX(dsdp::DSDPT, arg2, arg3::Integer)
    @dsdp_ccall DSDPGetDYMakeX (DSDPT, Ptr{Cdouble}, Cint) dsdp arg2 arg3
end

function GetMuMakeX(dsdp::DSDPT, arg2)
    @dsdp_ccall DSDPGetMuMakeX (DSDPT, Ptr{Cdouble}) dsdp arg2
end

function GetBarrierParameter(dsdp::DSDPT, arg2)
    @dsdp_ccall DSDPGetBarrierParameter (DSDPT, Ptr{Cdouble}) dsdp arg2
end

function SetBarrierParameter(dsdp::DSDPT, arg2::Cdouble)
    @dsdp_ccall DSDPSetBarrierParameter (DSDPT, Cdouble) dsdp arg2
end

function ReuseMatrix(dsdp::DSDPT, arg2::Integer)
    @dsdp_ccall DSDPReuseMatrix (DSDPT, Cint) dsdp arg2
end

function GetReuseMatrix(dsdp::DSDPT, arg2)
    @dsdp_ccall DSDPGetReuseMatrix (DSDPT, Ptr{Cint}) dsdp arg2
end

function GetDimension(dsdp::DSDPT, arg2)
    @dsdp_ccall DSDPGetDimension (DSDPT, Ptr{Cdouble}) dsdp arg2
end

function SetMaxIts(dsdp::DSDPT, arg2::Integer)
    @dsdp_ccall DSDPSetMaxIts (DSDPT, Cint) dsdp arg2
end

function GetMaxIts(dsdp::DSDPT, arg2)
    @dsdp_ccall DSDPGetMaxIts (DSDPT, Ptr{Cint}) dsdp arg2
end

function SetStepTolerance(dsdp::DSDPT, arg2::Cdouble)
    @dsdp_ccall DSDPSetStepTolerance (DSDPT, Cdouble) dsdp arg2
end

function GetStepTolerance(dsdp::DSDPT, arg2)
    @dsdp_ccall DSDPGetStepTolerance (DSDPT, Ptr{Cdouble}) dsdp arg2
end

function SetGapTolerance(dsdp::DSDPT, arg2::Cdouble)
    @dsdp_ccall DSDPSetGapTolerance (DSDPT, Cdouble) dsdp arg2
end

function GetGapTolerance(dsdp::DSDPT, arg2)
    @dsdp_ccall DSDPGetGapTolerance (DSDPT, Ptr{Cdouble}) dsdp arg2
end

function SetPNormTolerance(dsdp::DSDPT, arg2::Real)
    @dsdp_ccall DSDPSetPNormTolerance (DSDPT, Cdouble) dsdp arg2
end

function GetPNormTolerance(dsdp::DSDPT, arg2)
    @dsdp_ccall DSDPGetPNormTolerance (DSDPT, Ptr{Cdouble}) dsdp arg2
end

function SetDualBound(dsdp::DSDPT, arg2::Cdouble)
    @dsdp_ccall DSDPSetDualBound (DSDPT, Cdouble) dsdp arg2
end

function GetDualBound(dsdp::DSDPT, arg2)
    @dsdp_ccall DSDPGetDualBound (DSDPT, Ptr{Cdouble}) dsdp arg2
end

function SetPTolerance(dsdp::DSDPT, arg2::Cdouble)
    @dsdp_ccall DSDPSetPTolerance (DSDPT, Cdouble) dsdp arg2
end

function GetPTolerance(dsdp::DSDPT, arg2)
    @dsdp_ccall DSDPGetPTolerance (DSDPT, Ptr{Cdouble}) dsdp arg2
end

function GetPInfeasibility(dsdp::DSDPT, arg2)
    @dsdp_ccall DSDPGetPInfeasibility (DSDPT, Ptr{Cdouble}) dsdp arg2
end

function SetMaxTrustRadius(dsdp::DSDPT, arg2::Cdouble)
    @dsdp_ccall DSDPSetMaxTrustRadius (DSDPT, Cdouble) dsdp arg2
end

function GetMaxTrustRadius(dsdp::DSDPT, arg2)
    @dsdp_ccall DSDPGetMaxTrustRadius (DSDPT, Ptr{Cdouble}) dsdp arg2
end

function StopReason(dsdp::DSDPT)
    stop = Ref{DSDPTerminationReason}()
    @dsdp_ccall DSDPStopReason (DSDPT, Ref{DSDPTerminationReason}) dsdp stop
    stop[]
end

function GetSolutionType(dsdp::DSDPT, arg2)
    @dsdp_ccall DSDPGetSolutionType (DSDPT, Ptr{DSDPSolutionType}) dsdp arg2
end

function SetPotentialParameter(dsdp::DSDPT, arg2::Real)
    @dsdp_ccall DSDPSetPotentialParameter (DSDPT, Cdouble) dsdp arg2
end

function GetPotentialParameter(dsdp::DSDPT, arg2)
    @dsdp_ccall DSDPGetPotentialParameter (DSDPT, Ptr{Cdouble}) dsdp arg2
end

function UseDynamicRho(dsdp::DSDPT, arg2::Integer)
    @dsdp_ccall DSDPUseDynamicRho (DSDPT, Cint) dsdp arg2
end

function GetPotential(dsdp::DSDPT, arg2)
    @dsdp_ccall DSDPGetPotential (DSDPT, Ptr{Cdouble}) dsdp arg2
end

function UseLAPACKForSchur(dsdp::DSDPT, arg2::Integer)
    @dsdp_ccall DSDPUseLAPACKForSchur (DSDPT, Cint) dsdp arg2
end

function GetNumberOfVariables(dsdp::DSDPT, arg2)
    @dsdp_ccall DSDPGetNumberOfVariables (DSDPT, Ptr{Cint}) dsdp arg2
end

function GetFinalErrors(dsdp::DSDPT, arg2::NTuple{6, Cdouble})
    @dsdp_ccall DSDPGetFinalErrors (DSDPT, NTuple{6, Cdouble}) dsdp arg2
end

function GetGapHistory(dsdp::DSDPT, arg2, arg3::Integer)
    @dsdp_ccall DSDPGetGapHistory (DSDPT, Ptr{Cdouble}, Cint) dsdp arg2 arg3
end

function GetRHistory(dsdp::DSDPT, arg2, arg3::Integer)
    @dsdp_ccall DSDPGetRHistory (DSDPT, Ptr{Cdouble}, Cint) dsdp arg2 arg3
end

function GetIts(dsdp::DSDPT, arg2)
    @dsdp_ccall DSDPGetIts (DSDPT, Ptr{Cint}) dsdp arg2
end

function GetPnorm(dsdp::DSDPT, arg2)
    @dsdp_ccall DSDPGetPnorm (DSDPT, Ptr{Cdouble}) dsdp arg2
end

function GetStepLengths(dsdp::DSDPT, arg2, arg3)
    @dsdp_ccall DSDPGetStepLengths (DSDPT, Ptr{Cdouble}, Ptr{Cdouble}) dsdp arg2 arg3
end

function SetMonitor(dsdp::DSDPT, arg2, arg3)
    @dsdp_ccall DSDPSetMonitor (DSDPT, DSDPT, DSDPT) dsdp arg2 arg3
end

function SetStandardMonitor(dsdp::DSDPT, arg2::Integer)
    @dsdp_ccall DSDPSetStandardMonitor (DSDPT, Cint) dsdp arg2
end

function SetFileMonitor(dsdp::DSDPT, arg2::Integer)
    @dsdp_ccall DSDPSetFileMonitor (DSDPT, Cint) dsdp arg2
end

function SetPenaltyParameter(dsdp::DSDPT, arg2::Cdouble)
    @dsdp_ccall DSDPSetPenaltyParameter (DSDPT, Cdouble) dsdp arg2
end

function UsePenalty(dsdp::DSDPT, arg2::Integer)
    @dsdp_ccall DSDPUsePenalty (DSDPT, Cint) dsdp arg2
end

function PrintLogInfo(arg1::Integer)
    @dsdp_ccall DSDPPrintLogInfo (Cint,) arg1
end

function ComputeMinimumXEigenvalue(dsdp::DSDPT, arg2)
    @dsdp_ccall DSDPComputeMinimumXEigenvalue (DSDPT, Ptr{Cdouble}) dsdp arg2
end

function GetTraceX(dsdp::DSDPT, arg1)
    @dsdp_ccall DSDPGetTraceX (DSDPT, Ptr{Cdouble}) dsdp arg1
end

function SetZBar(dsdp::DSDPT, arg2::Cdouble)
    @dsdp_ccall DSDPSetZBar (DSDPT, Cdouble) dsdp arg2
end

function SetDualLowerBound(dsdp::DSDPT, arg2::Cdouble)
    @dsdp_ccall DSDPSetDualLowerBound (DSDPT, Cdouble) dsdp arg2
end

function GetDataNorms(dsdp::DSDPT, arg2::NTuple{3, Cdouble})
    @dsdp_ccall DSDPGetDataNorms (DSDPT, NTuple{3, Cdouble}) dsdp arg2
end

function GetYMaxNorm(dsdp::DSDPT, arg2)
    @dsdp_ccall DSDPGetYMaxNorm (DSDPT, Ptr{Cdouble}) dsdp arg2
end

function SDPConeUseFullSymmetricFormat(arg1::SDPCone, arg2::Integer)
    @dsdp_ccall SDPConeUseFullSymmetricFormat (SDPCone, Cint) arg1 arg2
end

function SDPConeUsePackedFormat(arg1::SDPCone, arg2::Integer)
    @dsdp_ccall SDPConeUsePackedFormat (SDPCone, Cint) arg1 arg2
end

function SetFixedVariable(dsdp::DSDPT, arg2::Integer, arg3::Cdouble)
    @dsdp_ccall DSDPSetFixedVariable (DSDPT, Cint, Cdouble) dsdp arg2 arg3
end

function SetFixedVariables(dsdp::DSDPT, arg2, arg3, arg4, arg5::Integer)
    @dsdp_ccall DSDPSetFixedVariables (DSDPT, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cint) dsdp arg2 arg3 arg4 arg5
end

function GetFixedYX(dsdp::DSDPT, arg2::Integer, arg3)
    @dsdp_ccall DSDPGetFixedYX (DSDPT, Cint, Ptr{Cdouble}) dsdp arg2 arg3
end

function View(dsdp::DSDPT)
    @dsdp_ccall DSDPView (DSDPT,) dsdp
end

function PrintOptions()
    ccall((:DSDPPrintOptions, libdsdp), Cint, ())
end

function PrintData(dsdp::DSDPT, arg2::SDPCone, arg3::LPCone)
    @dsdp_ccall DSDPPrintData (DSDPT, SDPCone, LPCone) dsdp arg2 arg3
end

#function PrintSolution(arg1, arg2::DSDPT, arg3::SDPCone, arg4::LPCone)
#    @dsdp_ccall DSDPPrintSolution (Ptr{FILE}, DSDP, SDPCone, LPCone) arg1 arg2 arg3 arg4
#end

function SetOptions(dsdp::DSDPT, arg2, arg3::Integer)
    @dsdp_ccall DSDPSetOptions (DSDPT, Ptr{Cstring}, Cint) dsdp arg2 arg3
end

function ReadOptions(dsdp::DSDPT, arg2)
    @dsdp_ccall DSDPReadOptions (DSDPT, Ptr{UInt8}) dsdp arg2
end

function SetDestroyRoutine(dsdp::DSDPT, arg2, arg3)
    @dsdp_ccall DSDPSetDestroyRoutine (DSDPT, DSDPT, DSDPT) dsdp arg2 arg3
end
