# StrTables

[![Build Status](https://travis-ci.org/JuliaString/StrTables.jl.svg?branch=master)](https://travis-ci.org/JuliaString/StrTables.jl)

[![Coverage Status](https://coveralls.io/repos/JuliaString/StrTables.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/JuliaString/StrTables.jl?branch=master)

[![codecov.io](http://codecov.io/github/JuliaString/StrTables.jl/coverage.svg?branch=master)](http://codecov.io/github/JuliaString/StrTables.jl?branch=master)

StrTables.jl: Support for creating packed tables of strings and save/load simple tables with values
====================================================================

This is used to build compact tables that can be used to create things like entity mappings
It also provides simple load/save functions to save and then load string tables along with
other simple types (UInt8..UInt64, Int8..Int64, Float32, Float64, vectors of those types,
and String) to/from a file.

Doing so can eliminate a lot of JITing time needed just to parse and then create a table from
Julia source, and when Julia can be used to build executables, allows the tables to be updated
without recompiling the executable.
