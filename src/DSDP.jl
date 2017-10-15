module DSDP

if isfile(joinpath(Pkg.dir("DSDP"),"deps","deps.jl"))
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
            error("DSDP call $f returned nonzero status $info.")
        end
    end
end


const DSDPT = Ptr{Void}
const SDPCone = Ptr{Void}
const BCone = Ptr{Void}
const LPCone = Ptr{Void}

include("dsdp5_enums.jl")
include("dsdp5_API.jl")

end
