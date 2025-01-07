# Copyright (c) 2022: Joey Huchette, Benoît Legat, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

module DSDP

import DSDP_jll

using LinearAlgebra

macro dsdp_ccall(f, args...)
    quote
        # QuoteNode prevents the interpretion of the symbol
        # and leave it as a symbol
        info = ccall(($(QuoteNode(f)), DSDP_jll.libdsdp), Cint, $(esc.(args)...))
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

# Writes to `input.sdpa`
function PrintData(dsdp::DSDPT, sdpcone::SDPCone.SDPConeT, lpcone::LPCone.LPConeT)
    @dsdp_ccall DSDPPrintData (DSDPT, SDPCone.SDPConeT, LPCone.LPConeT) dsdp sdpcone lpcone
end

function PrintSolution(fp::Libc.FILE,dsdp::DSDPT,sdpcone::SDPCone.SDPConeT,lpcone::LPCone.LPConeT)
    @dsdp_ccall DSDPPrintSolution (Ptr{Cvoid}, DSDPT, SDPCone.SDPConeT, LPCone.LPConeT) fp dsdp sdpcone lpcone
end

function PrintSolution(dsdp::DSDPT,sdpcone::SDPCone.SDPConeT,lpcone::LPCone.LPConeT)
    # See https://discourse.julialang.org/t/access-c-stdout-in-julia/24187/2
    stdout = Libc.FILE(Libc.RawFD(1), "w")
    return PrintSolution(stdout, dsdp, sdpcone, lpcone)
end

#function PrintSolution(arg1, arg2::DSDPT, arg3::SDPCone.SDPConeT, arg4::LPCone.LPConeT)
#    @dsdp_ccall DSDPPrintSolution (Ptr{FILE}, DSDP, SDPCone.SDPConeT, LPCone.LPConeT) arg1 arg2 arg3 arg4
#end

include("MOI_wrapper.jl")

end
