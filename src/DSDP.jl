# Copyright (c) 2022: Joey Huchette, Benoît Legat, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

module DSDP

using CEnum: @cenum
using DSDP_jll: libdsdp
import LinearAlgebra
import MathOptInterface as MOI

include("libdsdp.jl")

# This one is named poorly in the upstream C API
const DSDPSetReuseMatrix = DSDPReuseMatrix

include("MOI_wrapper.jl")

end
