# Copyright (c) 2019 Mathieu Besançon, Oscar Dowson, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

import Clang
import DSDP_jll

dir = joinpath(DSDP_jll.artifact_dir, "include")
Clang.Generators.create_context(
    joinpath.(dir, ["dsdp5.h"]),
    [Clang.Generators.get_default_args(); "-I$dir"],
    Clang.Generators.load_options(joinpath(@__DIR__, "generate.toml")),
) |> Clang.Generators.build!

filename = joinpath(@__DIR__, "..", "src", "libdsdp.jl")
contents = read(filename, String)
for cone in ["DSDP", "SDPCone", "LPCone", "BCone"]
    global contents = replace(
        contents,
        "const $(cone)_C = Cvoid\n\n" => "",
        "const $(cone) = Ptr{$(cone)_C}\n\n" => "",
        "::$(cone)," => "::Ptr{Cvoid},",
        "::$(cone))" => "::Ptr{Cvoid})",
        "{$(cone)}" => "{Ptr{Cvoid}}",
    )
end
contents = replace(contents, r"const .+?\n\n" => "")
contents = replace(contents, r"# Skipping.+" => "")
for _ in 1:10
    global contents = replace(contents, "\n\n\n" => "\n\n")
end
write(filename, contents)
