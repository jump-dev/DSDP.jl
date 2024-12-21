# DSDP.jl

[![Build Status](https://github.com/jump-dev/DSDP.jl/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/jump-dev/DSDP.jl/actions?query=workflow%3ACI)
[![codecov](https://codecov.io/gh/jump-dev/DSDP.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/jump-dev/DSDP.jl)

[DSDP.jl](https://github.com/jump-dev/DSDP.jl) is a wrapper for the
[DSDP](http://www.mcs.anl.gov/hs/software/DSDP/) solver.

It has two components:

 - a thin wrapper around the complete C API
 - an interface to [MathOptInterface](https://github.com/jump-dev/MathOptInterface.jl)

## Affiliation

This wrapper is maintained by the JuMP community and is not an official project
of the DSDP developers.

## Getting help

If you need help, please ask a question on the [JuMP community forum](https://jump.dev/forum).

If you have a reproducible example of a bug, please [open a GitHub issue](https://github.com/jump-dev/DSDP.jl/issues/new).

## Installation

Install DSDP as follows:
```julia
import Pkg
Pkg.add("DSDP")
```

In addition to installing the DSDP.jl package, this will also download and
install the DSDP binaries. You do not need to install DSDP separately.

To use a custom binary, read the [Custom solver binaries](https://jump.dev/JuMP.jl/stable/developers/custom_solver_binaries/)
section of the JuMP documentation.

## Use with JuMP

To use DSDP with JuMP, use `DSDP.Optimizer`:
```julia
using JuMP, DSDP
model = Model(DSDP.Optimizer)
```

## MathOptInterface API

The DSDP optimizer supports the following constraints and attributes.

List of supported objective functions:

 * [`MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Float64}}`](@ref)

List of supported variable types:

 * [`MOI.Nonnegatives`](@ref)
 * [`MOI.PositiveSemidefiniteConeTriangle`](@ref)

List of supported constraint types:

 * [`MOI.ScalarAffineFunction{Float64}`](@ref) in [`MOI.EqualTo{Float64}`](@ref)

List of supported model attributes:

 * [`MOI.ObjectiveSense()`](@ref)

## Compile your own binaries

In order to compile your own `libdsdp.so` to be used of DSDP.jl, use the following
```sh
OB_DIR=$(julia --project=. -e 'import OpenBLAS32_jll; println(OpenBLAS32_jll.OpenBLAS32_jll.artifact_dir)')
OB="-L${LIBOB_DIR}/lib -lopenblas"
make DSDPCFLAGS="-g -Wall -fPIC -DPIC" LAPACKBLAS="$OB" dsdplibrary
make DSDPCFLAGS="-g -Wall -fPIC -DPIC" LAPACKBLAS="$OB" SH_LD="${CC} ${CFLAGS} -Wall -fPIC -DPIC -shared $OB" oshared
```
