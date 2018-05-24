# StrTables

| **Info** | **Package Status** | **Package Evaluator** | **Coverage** |
|:------------------:|:------------------:|:---------------------:|:-----------------:|
| [![License](http://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat)](LICENSE.md) | [![Build Status](https://travis-ci.org/JuliaString/StrFormat.jl.svg?branch=master)](https://travis-ci.org/JuliaString/StrFormat.jl) | [![StrFormat](http://pkg.julialang.org/badges/StrFormat_0.6.svg)](http://pkg.julialang.org/?pkg=StrFormat) | [![Coverage Status](https://coveralls.io/repos/github/JuliaString/StrFormat.jl/badge.svg?branch=master)](https://coveralls.io/github/JuliaString/StrFormat.jl?branch=master) |
| [![Gitter Chat](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/JuliaString/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge) | | [![StrFormat](http://pkg.julialang.org/badges/StrFormat_0.7.svg)](http://pkg.julialang.org/?pkg=StrFormat) | [![codecov.io](http://codecov.io/github/JuliaString/StrFormat.jl/coverage.svg?branch=master)](http://codecov.io/github/JuliaString/StrFormat.jl?branch=master) |

StrTables.jl: Support for creating packed tables of strings and save/load simple tables with values
====================================================================

This is used to build compact tables that can be used to create things like entity mappings
It also provides simple load/save functions to save and then load string tables along with
other simple types (UInt8..UInt64, Int8..Int64, Float32, Float64, vectors of those types,
and String) to/from a file.

Doing so can eliminate a lot of JITing time needed just to parse and then create a table from
Julia source, and when Julia can be used to build executables, allows the tables to be updated
without recompiling the executable.
