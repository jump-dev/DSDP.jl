# DSDP

| **Build Status** |
|:----------------:|
| [![Build Status][build-img]][build-url] |
| [![Coveralls branch][coveralls-img]][coveralls-url] [![Codecov branch][codecov-img]][codecov-url] |

Julia wrapper for the [DSDP](http://www.mcs.anl.gov/hs/software/DSDP/) semidefinite programming solver.

## Installation

You can install DSDP.jl as follows:
```julia
julia> Pkg.add("https://github.com/joehuchette/DSDP.jl.git")
julia> Pkg.build("DSDP")
```

The `Pkg.build` command will compile SDPA from source, you will need to install the following dependencies for the compilation to work.

### Ubuntu
```sh
$ sudo apt-get install build-essential liblapack-dev libopenblas-dev
```

### Windows
Windows support is still a work in progress.

[build-img]: https://travis-ci.org/joehuchette/DSDP.jl.svg?branch=master
[build-url]: https://travis-ci.org/joehuchette/DSDP.jl
[coveralls-img]: https://coveralls.io/repos/joehuchette/DSDP.jl/badge.svg?branch=master&service=github
[coveralls-url]: https://coveralls.io/github/joehuchette/DSDP.jl?branch=master
[codecov-img]: http://codecov.io/github/joehuchette/DSDP.jl/coverage.svg?branch=master
[codecov-url]: http://codecov.io/github/joehuchette/DSDP.jl?branch=master
