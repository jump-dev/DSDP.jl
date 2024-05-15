# Julia wrapper for header: include/dsdp5.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function LogInfoAllow(i::Integer)
    @dsdp_ccall DSDPLogInfoAllow (Cint, Ptr{Cchar}) i C_NULL
end

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

function ComputeAndFactorS(dsdp::DSDPT)
    psdefinite = Ref{DSDPTruth}()
    GC.@preserve psdefinite dsdp begin
        @dsdp_ccall DSDPComputeAndFactorS (DSDPT, Ref{DSDPTruth}) dsdp psdefinite
        return psdefinite[]
    end
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

function GetScale(dsdp::DSDPT)
    scale = Ref{Cdouble}()
    @dsdp_ccall DSDPGetScale (DSDPT, Ref{Cdouble}) dsdp scale
    scale[]
end

function SetScale(dsdp::DSDPT, scale::Cdouble)
    @dsdp_ccall DSDPSetScale (DSDPT, Cdouble) dsdp scale
end

function GetPenaltyParameter(dsdp::DSDPT)
    pp = Ref{Cdouble}()
    @dsdp_ccall DSDPGetPenaltyParameter (DSDPT, Ref{Cdouble}) dsdp pp
    pp[]
end

function GetPenalty(dsdp::DSDPT, arg2::Vector{Cdouble})
    @dsdp_ccall DSDPGetPenalty (DSDPT, Ptr{Cdouble}) dsdp arg2
end

function CopyB(dsdp::DSDPT, arg2::Vector{Cdouble}, arg3::Integer)
    @dsdp_ccall DSDPCopyB (DSDPT, Ptr{Cdouble}, Cint) dsdp arg2 arg3
end

function SetR0(dsdp::DSDPT, arg2::Cdouble)
    @dsdp_ccall DSDPSetR0 (DSDPT, Cdouble) dsdp arg2
end

function GetR(dsdp::DSDPT, arg2::Vector{Cdouble})
    @dsdp_ccall DSDPGetR (DSDPT, Ptr{Cdouble}) dsdp arg2
end

function SetRTolerance(dsdp::DSDPT, arg2::Cdouble)
    @dsdp_ccall DSDPSetRTolerance (DSDPT, Cdouble) dsdp arg2
end

function GetRTolerance(dsdp::DSDPT)
    rtol = Ref{Cdouble}()
    @dsdp_ccall DSDPGetRTolerance (DSDPT, Ref{Cdouble}) dsdp rtol
    rtol[]
end

function SetY0(dsdp::DSDPT, arg2::Integer, arg3::Cdouble)
    @dsdp_ccall DSDPSetY0 (DSDPT, Cint, Cdouble) dsdp arg2 arg3
end

function GetY(dsdp::DSDPT, y::Vector{Cdouble})
    @dsdp_ccall DSDPGetY (DSDPT, Ptr{Cdouble}, Cint) dsdp pointer(y) length(y)
end

function GetYMakeX(dsdp::DSDPT, arg2, arg3::Integer)
    @dsdp_ccall DSDPGetYMakeX (DSDPT, Ptr{Cdouble}, Cint) dsdp arg2 arg3
end

function GetDYMakeX(dsdp::DSDPT, arg2, arg3::Integer)
    @dsdp_ccall DSDPGetDYMakeX (DSDPT, Ptr{Cdouble}, Cint) dsdp arg2 arg3
end

function GetMuMakeX(dsdp::DSDPT, arg2::Vector{Cdouble})
    @dsdp_ccall DSDPGetMuMakeX (DSDPT, Ptr{Cdouble}) dsdp arg2
end

function GetBarrierParameter(dsdp::DSDPT)
    bp = Ref{Cdouble}()
    @dsdp_ccall DSDPGetBarrierParameter (DSDPT, Ptr{Cdouble}) dsdp bp
    bp[]
end

function SetBarrierParameter(dsdp::DSDPT, arg2::Cdouble)
    @dsdp_ccall DSDPSetBarrierParameter (DSDPT, Cdouble) dsdp arg2
end

function SetReuseMatrix(dsdp::DSDPT, arg2::Integer)
    @dsdp_ccall DSDPReuseMatrix (DSDPT, Cint) dsdp arg2
end

function GetReuseMatrix(dsdp::DSDPT)
    reuse = Ref{Cint}()
    @dsdp_ccall DSDPGetReuseMatrix (DSDPT, Ref{Cint}) dsdp reuse
    reuse[]
end

function GetDimension(dsdp::DSDPT, arg2::Vector{Cdouble})
    @dsdp_ccall DSDPGetDimension (DSDPT, Ptr{Cdouble}) dsdp arg2
end

function SetMaxIts(dsdp::DSDPT, arg2::Integer)
    @dsdp_ccall DSDPSetMaxIts (DSDPT, Cint) dsdp arg2
end

function GetMaxIts(dsdp::DSDPT)
    maxits = Ref{Cint}()
    @dsdp_ccall DSDPGetMaxIts (DSDPT, Ref{Cint}) dsdp maxits
    maxits[]
end

function SetStepTolerance(dsdp::DSDPT, steptol::Cdouble)
    @assert steptol > 0
    @dsdp_ccall DSDPSetStepTolerance (DSDPT, Cdouble) dsdp arg2
end

function GetStepTolerance(dsdp::DSDPT)
    steptol = Ref{Cdouble}()
    @dsdp_ccall DSDPGetStepTolerance (DSDPT, Ref{Cdouble}) dsdp steptol
    steptol[]
end

function SetGapTolerance(dsdp::DSDPT, arg2::Cdouble)
    @dsdp_ccall DSDPSetGapTolerance (DSDPT, Cdouble) dsdp arg2
end

function GetGapTolerance(dsdp::DSDPT)
    gaptol = Ref{Cdouble}()
    @dsdp_ccall DSDPGetGapTolerance (DSDPT, Ref{Cdouble}) dsdp gaptol
    gaptol[]
end

function SetPNormTolerance(dsdp::DSDPT, pnormtol::Real)
    @assert pnormtol > 0
    @dsdp_ccall DSDPSetPNormTolerance (DSDPT, Cdouble) dsdp pnormtol
end

function GetPNormTolerance(dsdp::DSDPT)
    pnormtol = Ref{Cdouble}()
    @dsdp_ccall DSDPGetPNormTolerance (DSDPT, Ref{Cdouble}) dsdp pnormtol
    pnormtol[]
end

function SetDualBound(dsdp::DSDPT, arg2::Cdouble)
    @dsdp_ccall DSDPSetDualBound (DSDPT, Cdouble) dsdp arg2
end

function GetDualBound(dsdp::DSDPT)
    dualb = Ref{Cdouble}()
    @dsdp_ccall DSDPGetDualBound (DSDPT, Ref{Cdouble}) dsdp dualb
    dualb[]
end

function SetPTolerance(dsdp::DSDPT, arg2::Cdouble)
    @dsdp_ccall DSDPSetPTolerance (DSDPT, Cdouble) dsdp arg2
end

function GetPTolerance(dsdp::DSDPT)
    ptol = Ref{Cdouble}()
    @dsdp_ccall DSDPGetPTolerance (DSDPT, Ref{Cdouble}) dsdp ptol
    ptol[]
end

function GetPInfeasibility(dsdp::DSDPT, arg2::Vector{Cdouble})
    @dsdp_ccall DSDPGetPInfeasibility (DSDPT, Ptr{Cdouble}) dsdp arg2
end

function SetMaxTrustRadius(dsdp::DSDPT, maxtrust::Cdouble)
    @dsdp_ccall DSDPSetMaxTrustRadius (DSDPT, Cdouble) dsdp maxtrust
end

function GetMaxTrustRadius(dsdp::DSDPT)
    maxtrust = Ref{Cdouble}()
    @dsdp_ccall DSDPGetMaxTrustRadius (DSDPT, Ptr{Cdouble}) dsdp maxtrust
    maxtrust[]
end

function StopReason(dsdp::DSDPT)
    stop = Ref{DSDPTerminationReason}()
    @dsdp_ccall DSDPStopReason (DSDPT, Ref{DSDPTerminationReason}) dsdp stop
    stop[]
end

function GetSolutionType(dsdp::DSDPT)
    sol = Ref{DSDPSolutionType}()
    @dsdp_ccall DSDPGetSolutionType (DSDPT, Ref{DSDPSolutionType}) dsdp sol
    sol[]
end

function SetPotentialParameter(dsdp::DSDPT, pp::Real)
    @dsdp_ccall DSDPSetPotentialParameter (DSDPT, Cdouble) dsdp pp
end

function GetPotentialParameter(dsdp::DSDPT)
    pp = Ref{Cdouble}()
    @dsdp_ccall DSDPGetPotentialParameter (DSDPT, Ref{Cdouble}) dsdp pp
    pp[]
end

function UseDynamicRho(dsdp::DSDPT, arg2::Integer)
    @dsdp_ccall DSDPUseDynamicRho (DSDPT, Cint) dsdp arg2
end

function GetPotential(dsdp::DSDPT, arg2::Vector{Cdouble})
    @dsdp_ccall DSDPGetPotential (DSDPT, Ptr{Cdouble}) dsdp arg2
end

function UseLAPACKForSchur(dsdp::DSDPT, arg2::Integer)
    @dsdp_ccall DSDPUseLAPACKForSchur (DSDPT, Cint) dsdp arg2
end

function GetNumberOfVariables(dsdp::DSDPT, arg2::Vector{Cint})
    @dsdp_ccall DSDPGetNumberOfVariables (DSDPT, Ptr{Cint}) dsdp arg2
end

function GetFinalErrors(dsdp::DSDPT)
    err = zeros(Cdouble, 6)
    @dsdp_ccall DSDPGetFinalErrors (DSDPT, Ptr{Cdouble}) dsdp err
    return err
end

function GetGapHistory(dsdp::DSDPT, arg2::Vector{Cdouble}, arg3::Integer)
    @dsdp_ccall DSDPGetGapHistory (DSDPT, Ptr{Cdouble}, Cint) dsdp arg2 arg3
end

function GetRHistory(dsdp::DSDPT, arg2::Vector{Cdouble}, arg3::Integer)
    @dsdp_ccall DSDPGetRHistory (DSDPT, Ptr{Cdouble}, Cint) dsdp arg2 arg3
end

function GetIts(dsdp::DSDPT)
    its = Ref{Cint}()
    @dsdp_ccall DSDPGetIts (DSDPT, Ptr{Cint}) dsdp its
    return its[]
end

function GetPnorm(dsdp::DSDPT, arg2::Vector{Cdouble})
    @dsdp_ccall DSDPGetPnorm (DSDPT, Ptr{Cdouble}) dsdp arg2
end

function GetStepLengths(dsdp::DSDPT, arg2::Vector{Cdouble}, arg3::Vector{Cdouble})
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

function ComputeMinimumXEigenvalue(dsdp::DSDPT, arg2::Vector{Cdouble})
    @dsdp_ccall DSDPComputeMinimumXEigenvalue (DSDPT, Ptr{Cdouble}) dsdp arg2
end

function GetTraceX(dsdp::DSDPT, sdpcone::Vector{Cdouble})
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

function GetYMaxNorm(dsdp::DSDPT, arg2::Vector{Cdouble})
    @dsdp_ccall DSDPGetYMaxNorm (DSDPT, Ptr{Cdouble}) dsdp arg2
end

function BoundDualVariables(dsdp::DSDPT, arg2::Cdouble, arg3::Cdouble)
    @dsdp_ccall DSDPBoundDualVariables (DSDPT, Cdouble, Cdouble) dsdp arg2 arg3
end

function SetYBounds(dsdp::DSDPT, ylow::Cdouble, yhigh::Cdouble)
    @dsdp_ccall DSDPSetYBounds (DSDPT, Cdouble, Cdouble) dsdp ylow yhigh
end

function GetYBounds(dsdp::DSDPT)
    ylow = Ref{Cdouble}()
    yhigh = Ref{Cdouble}()
    @dsdp_ccall DSDPGetYBounds (DSDPT, Ref{Cdouble}, Ref{Cdouble}) dsdp ylow yhigh
    ylow[], yhigh[]
end

function SetFixedVariable(dsdp::DSDPT, arg2::Integer, arg3::Cdouble)
    @dsdp_ccall DSDPSetFixedVariable (DSDPT, Cint, Cdouble) dsdp arg2 arg3
end

function SetFixedVariables(dsdp::DSDPT, arg2::Vector{Cdouble}, arg3::Vector{Cdouble}, arg4::Vector{Cdouble}, arg5::Integer)
    @dsdp_ccall DSDPSetFixedVariables (DSDPT, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cint) dsdp arg2 arg3 arg4 arg5
end

function GetFixedYX(dsdp::DSDPT, arg2::Integer, arg3::Vector{Cdouble})
    @dsdp_ccall DSDPGetFixedYX (DSDPT, Cint, Ptr{Cdouble}) dsdp arg2 arg3
end

function View(dsdp::DSDPT)
    @dsdp_ccall DSDPView (DSDPT,) dsdp
end

function PrintOptions()
    ccall((:DSDPPrintOptions, libdsdp), Cint, ())
end

function SetOptions(dsdp::DSDPT, arg2::Vector{Cstring}, arg3::Integer)
    @dsdp_ccall DSDPSetOptions (DSDPT, Ptr{Cstring}, Cint) dsdp arg2 arg3
end

function ReadOptions(dsdp::DSDPT, arg2::Vector{UInt8})
    @dsdp_ccall DSDPReadOptions (DSDPT, Ptr{UInt8}) dsdp arg2
end

function SetDestroyRoutine(dsdp::DSDPT, arg2, arg3)
    @dsdp_ccall DSDPSetDestroyRoutine (DSDPT, DSDPT, DSDPT) dsdp arg2 arg3
end
