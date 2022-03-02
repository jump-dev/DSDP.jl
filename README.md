# DSDP

| **Build Status** |
|:----------------:|
| [![Build Status][build-img]][build-url] |
| [![Codecov branch][codecov-img]][codecov-url] |

**Important note**: this is still a work on progress. The use of semidefinite matrices in linear equality constraints has not been implemented yet so only linear programs can be solved at the moment with DSDP.

Julia wrapper for the [DSDP](http://www.mcs.anl.gov/hs/software/DSDP/) semidefinite programming solver.

## Installation

You can install DSDP.jl as follows:
```julia
julia> Pkg.add("https://github.com/joehuchette/DSDP.jl.git")
julia> Pkg.build("DSDP")
```

The `Pkg.build` command will compile DSDP from source, you will need to install the following dependencies for the compilation to work.

### Ubuntu
```sh
$ sudo apt-get install build-essential liblapack-dev libopenblas-dev
```

### Windows
Windows support is still a work in progress.

[build-img]: https://github.com/jump-dev/DSDP.jl/workflows/CI/badge.svg?branch=master
[build-url]: https://github.com/jump-dev/DSDP.jl/actions?query=workflow%3ACI
[codecov-img]: http://codecov.io/github/jump-dev/DSDP.jl/coverage.svg?branch=master
[codecov-url]: http://codecov.io/github/jump-dev/DSDP.jl?branch=master
