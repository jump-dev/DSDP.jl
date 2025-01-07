# Copyright (c) 2022: Joey Huchette, Benoît Legat, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

@testset "LPConeSetData doc example" begin
    lpdvars =    Cint[ 3, 3, 2, 2, 1, 3,  1,  1]
    lpdrows =    Cint[ 2, 0, 1, 0, 0, 1,  1,  2]
    lpcoefs = Cdouble[-1, 2, 3, 4, 6, 7, 10, 12]
    nnzin, row, aval = LPCone.buildlp(3, lpdvars, lpdrows, lpcoefs)
    @test nnzin isa Vector{Cint}
    @test nnzin == [0, 3, 5, 8]
    @test row isa Vector{Cint}
    @test row == [0, 1, 2, 0, 1, 0, 1, 2]
    @test aval isa Vector{Cdouble}
    @test aval == [6, 10, 12, 4, 3, 2, 7, -1]
end
