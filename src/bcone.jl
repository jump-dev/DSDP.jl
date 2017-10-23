export BCone

module BCone

import ..@dsdp_ccall
const BConeT = Ptr{Void}

function AllocateBounds(bcone::BConeT, arg2::Integer)
    @dsdp_ccall BConeAllocateBounds (BConeT, Cint) bcone arg2
end

function SetLowerBound(bcone::BConeT, arg2::Integer, arg3::Cdouble)
    @dsdp_ccall BConeSetLowerBound (BConeT, Cint, Cdouble) bcone arg2 arg3
end

function SetUpperBound(bcone::BConeT, arg2::Integer, arg3::Cdouble)
    @dsdp_ccall BConeSetUpperBound (BConeT, Cint, Cdouble) bcone arg2 arg3
end

function SetPSlackVariable(bcone::BConeT, arg2::Integer)
    @dsdp_ccall BConeSetPSlackVariable (BConeT, Cint) bcone arg2
end

function SetPSurplusVariable(bcone::BConeT, arg2::Integer)
    @dsdp_ccall BConeSetPSurplusVariable (BConeT, Cint) bcone arg2
end

function ScaleBarrier(bcone::BConeT, arg2::Cdouble)
    @dsdp_ccall BConeScaleBarrier (BConeT, Cdouble) bcone arg2
end

function View(bcone::BConeT)
    @dsdp_ccall BConeView (BConeT,) bcone
end

function SetXArray(bcone::BConeT, arg2, arg3::Integer)
    @dsdp_ccall BConeSetXArray (BConeT, Ptr{Cdouble}, Cint) bcone arg2 arg3
end

function CopyX(bcone::BConeT, arg2, arg3, arg4::Integer)
    @dsdp_ccall BConeCopyX (BConeT, Ptr{Cdouble}, Ptr{Cdouble}, Cint) bcone arg2 arg3 arg4
end

end
