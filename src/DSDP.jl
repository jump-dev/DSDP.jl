module DSDP
using Libdl

if isfile(joinpath(dirname(@__FILE__), "..", "deps", "deps.jl"))
    include("../deps/deps.jl")
else
    error("DSDP not properly installed. Please run Pkg.build(\"DSDP\")")
end

macro dsdp_ccall(f, args...)
    quote
        # QuoteNode prevents the interpretion of the symbol
        # and leave it as a symbol
        info = ccall(($(QuoteNode(f)), libdsdp), Cint, $(esc.(args)...))
        if !iszero(info)
            error("DSDP call $($(QuoteNode(f))) returned nonzero status $info.")
        end
    end
end

const DSDPT = Ptr{Nothing}

include("dsdp5_enums.jl")
include("dsdp5_API.jl")

include("lpcone.jl")
function CreateLPCone(dsdp::DSDPT)
    lpcone = Ref{LPCone.LPConeT}()
    @dsdp_ccall DSDPCreateLPCone (DSDPT, Ref{LPCone.LPConeT}) dsdp lpcone
    lpcone[]
end

include("sdpcone.jl")
function CreateSDPCone(dsdp::DSDPT, n::Integer)
    sdpcone = Ref{SDPCone.SDPConeT}()
    @dsdp_ccall DSDPCreateSDPCone (DSDPT, Cint, Ref{SDPCone.SDPConeT}) dsdp n sdpcone
    sdpcone[]
end

include("bcone.jl")
function CreateBCone(dsdp::DSDPT)
    bcone = Ref{BCone.BConeT}()
    @dsdp_ccall DSDPCreateBCone (DSDPT, Ref{BCone.BConeT}) dsdp bcone
    bcone[]
end

function PrintData(dsdp::DSDPT, sdpcone::SDPCone.SDPConeT, lpcone::LPCone.LPConeT)
    @dsdp_ccall DSDPPrintData (DSDPT, SDPCone.SDPConeT, LPCone.LPConeT) dsdp sdpcone lpcone
end

#function PrintSolution(arg1, arg2::DSDPT, arg3::SDPCone.SDPConeT, arg4::LPCone.LPConeT)
#    @dsdp_ccall DSDPPrintSolution (Ptr{FILE}, DSDP, SDPCone.SDPConeT, LPCone.LPConeT) arg1 arg2 arg3 arg4
#end

include("MOI_wrapper.jl")

end
