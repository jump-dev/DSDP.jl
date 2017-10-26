export LPCone

module LPCone

import ..@dsdp_ccall
const LPConeT = Ptr{Void}

function buildlp(nvars, lpdvars, lpdrows, lpcoefs)
    @assert length(lpdvars) == length(lpdrows) == length(lpcoefs)
    nzin = zeros(Cint, nvars)
    n = length(lpdvars)
    for var in lpdvars
        nzin[var] += 1
    end
    nnzin = [zero(Cint); cumsum(nzin)]
    @assert nnzin[end] == n
    idx = map(var -> Int[], 1:nvars)
    for (i, var) in enumerate(lpdvars)
        push!(idx[var], i)
    end
    row = Vector{Cint}(n)
    aval = Vector{Cdouble}(n)
    for var in 1:nvars
        sort!(idx[var], by=i->lpdrows[i])
        row[(nnzin[var]+1):(nnzin[var+1])] = lpdrows[idx[var]]
        aval[(nnzin[var]+1):(nnzin[var+1])] = lpcoefs[idx[var]]
    end
    nnzin, row, aval
end

# This function is not part of DSDP API
function SetDataSparse(lpcone::LPConeT, n::Integer, nvars, lpdvars, lpdrows, lpcoefs)
    SetData(lpcone, n, buildlp(nvars, lpdvars, lpdrows, lpcoefs)...)
end

function SetData(lpcone::LPConeT, n::Integer, nnzin::Vector{Cint}, row::Vector{Cint}, aval::Vector{Cdouble})
    @assert length(row) == length(aval)
    @dsdp_ccall LPConeSetData (LPConeT, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}) lpcone n nnzin row aval
end

function SetData2(arg1::LPConeT, arg2::Integer, arg3, arg4, arg5)
    @dsdp_ccall LPConeSetData2 (LPConeT, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}) arg1 arg2 arg3 arg4 arg5
end

function GetData(arg1::LPConeT, arg2::Integer, arg3, arg4::Integer)
    @dsdp_ccall LPConeGetData (LPConeT, Cint, Ptr{Cdouble}, Cint) arg1 arg2 arg3 arg4
end

function ScaleBarrier(arg1::LPConeT, arg2::Cdouble)
    @dsdp_ccall LPConeScaleBarrier (LPConeT, Cdouble) arg1 arg2
end

function GetXArray(lpcone::LPConeT)
    xout = Ref{Ptr{Cdouble}}()
    n = Ref{Cint}()
    @dsdp_ccall LPConeGetXArray (LPConeT, Ptr{Ptr{Cdouble}}, Ptr{Cint}) lpcone xout n
    unsafe_wrap(Array, xout[], n[])
end

function GetSArray(lpcone::LPConeT)
    sout = Ref{Ptr{Cdouble}}()
    n = Ref{Cint}()
    @dsdp_ccall LPConeGetSArray (LPConeT, Ref{Ptr{Cdouble}}, Ref{Cint}) lpcone sout n
    unsafe_wrap(Array, sout[], n[])
end

function GetDimension(arg1::LPConeT, arg2)
    @dsdp_ccall LPConeGetDimension (LPConeT, Ptr{Cint}) arg1 arg2
end

function View(lpcone::LPConeT)
    @dsdp_ccall LPConeView (LPConeT,) lpcone
end

function View2(lpcone::LPConeT)
    @dsdp_ccall LPConeView2 (LPConeT,) lpcone
end

function CopyS(arg1::LPConeT, arg2, arg3::Integer)
    @dsdp_ccall LPConeCopyS (LPConeT, Ptr{Cdouble}, Cint) arg1 arg2 arg3
end

end
