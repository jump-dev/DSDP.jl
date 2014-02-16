module DSDP

if isfile(joinpath(Pkg.dir("DSDP"),"deps","deps.jl"))
    include("../deps/deps.jl")
else
    error("DSDP not properly installed. Please run Pkg.build(\"DSDP\")")
end

end
