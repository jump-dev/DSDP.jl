module DSDP

if isfile(joinpath(Pkg.dir("DSDP"),"deps","deps.jl"))
    include("../deps/deps.jl")
else
    error("DSDP not properly installed. Please run Pkg.build(\"DSDP\")")
end

const SDPCone = Ptr{Void}
const BCone = Ptr{Void}
const LPCone = Ptr{Void}

include("dsdp5_enums.jl")
include("dsdp5_API.jl")

end
