# StrTables:
## Support for creating packed tables of strings and save/load simple tables with values

[pkg-url]: https://github.com/JuliaString/StrTables.jl.git

[julia-url]:    https://github.com/JuliaLang/Julia
[julia-release]:https://img.shields.io/github/release/JuliaLang/julia.svg

[release]:      https://img.shields.io/github/release/JuliaString/StrTables.jl.svg
[release-date]: https://img.shields.io/github/release-date/JuliaString/StrTables.jl.svg

[license-img]:  http://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat
[license-url]:  LICENSE.md

[gitter-img]:   https://badges.gitter.im/Join%20Chat.svg
[gitter-url]:   https://gitter.im/JuliaString/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge

[travis-url]:   https://travis-ci.org/JuliaString/StrTables.jl
[travis-s-img]: https://travis-ci.org/JuliaString/StrTables.jl.svg
[travis-m-img]: https://travis-ci.org/JuliaString/StrTables.jl.svg?branch=master

[codecov-url]:  https://codecov.io/gh/JuliaString/StrTables.jl
[codecov-img]:  https://codecov.io/gh/JuliaString/StrTables.jl/branch/master/graph/badge.svg

[contrib]:    https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat

[![][release]][pkg-url] [![][release-date]][pkg-url] [![][license-img]][license-url] [![contributions welcome][contrib]](https://github.com/JuliaString/StrTables.jl/issues)

| **Julia Version** | **Unit Tests** | **Coverage** |
|:------------------:|:------------------:|:---------------------:|
| [![][julia-release]][julia-url] | [![][travis-s-img]][travis-url] | [![][codecov-img]][codecov-url]
| Julia Latest | [![][travis-m-img]][travis-url] | [![][codecov-img]][codecov-url]

This is used to build compact tables that can be used to create things like entity mappings
It also provides simple load/save functions to save and then load string tables along with
other simple types (UInt8..UInt64, Int8..Int64, Float32, Float64, vectors of those types,
and String) to/from a file.

Doing so can eliminate a lot of JITing time needed just to parse and then create a table from
Julia source, and when Julia can be used to build executables, allows the tables to be updated
without recompiling the executable.
