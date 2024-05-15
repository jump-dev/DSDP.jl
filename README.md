# DSDP.jl

[![Build Status](https://github.com/jump-dev/DSDP.jl/workflows/CI/badge.svg?branch=master)](https://github.com/jump-dev/DSDP.jl/actions?query=workflow%3ACI)
[![codecov](https://codecov.io/gh/jump-dev/DSDP.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/jump-dev/DSDP.jl)

**Important note**: this is still a work on progress. The use of positive semidefinite matrices in linear equality constraints has not been implemented yet so only linear programs can be solved at the moment with DSDP.

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
 * [`MOI.PositiveSemidefiniteConeTriangle`](@ref) (**only** on this PR at the moment: https://github.com/jump-dev/DSDP.jl/pull/29)

List of supported constraint types:

 * [`MOI.ScalarAffineFunction{Float64}`](@ref) in [`MOI.EqualTo{Float64}`](@ref)

List of supported model attributes:

 * [`MOI.ObjectiveSense()`](@ref)

