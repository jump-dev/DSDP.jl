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

function GetTraceX(dsdp::DSDPT, sdpcone)
    @dsdp_ccall DSDPGetTraceX (DSDPT, Ptr{Cdouble}) dsdp sdpcone
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

function BoundDualVariables(dsdp::DSDPT, arg2::Cdouble, arg3::Cdouble)
    @dsdp_ccall DSDPBoundDualVariables (DSDPT, Cdouble, Cdouble) dsdp arg2 arg3
end

function SetYBounds(dsdp::DSDPT, arg2::Cdouble, arg3::Cdouble)
    @dsdp_ccall DSDPSetYBounds (DSDPT, Cdouble, Cdouble) dsdp arg2 arg3
end

function GetYBounds(dsdp::DSDPT, arg2, arg3)
    @dsdp_ccall DSDPGetYBounds (DSDPT, Ptr{Cdouble}, Ptr{Cdouble}) dsdp arg2 arg3
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

function SetOptions(dsdp::DSDPT, arg2, arg3::Integer)
    @dsdp_ccall DSDPSetOptions (DSDPT, Ptr{Cstring}, Cint) dsdp arg2 arg3
end

function ReadOptions(dsdp::DSDPT, arg2)
    @dsdp_ccall DSDPReadOptions (DSDPT, Ptr{UInt8}) dsdp arg2
end

function SetDestroyRoutine(dsdp::DSDPT, arg2, arg3)
    @dsdp_ccall DSDPSetDestroyRoutine (DSDPT, DSDPT, DSDPT) dsdp arg2 arg3
end
