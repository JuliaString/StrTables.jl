__precompile__()
"""
Simple String Table and load/save functions

Author:     Scott Paul Jones
Copyright:  2017 Gandalf Software, Inc (and any future contributors)
License:    MIT (see https://github.com/JuliaString/StrTables.jl/blob/master/LICENSE.md)

## Public API:

# Exported:
* StrTable takes a Vector of some `AbstractString` type
  and returns a compact string table, that acts as a `AbstractVector{String}`

# Not exported:
* matchfirst takes a sorted string table and a string,
  returns a vector of elements that start with the string
* matchfirstrng takes a sorted string table and a string,
  returns the range of indexes of elements start with the string
* save takes a filename and a collection (of simple types) and
  saves them to the file in a simple format
* load takes a filename and returns a Vector of the values stored by save in the file
"""
module StrTables
export StrTable

"""
Compact string table
Designed to save memory compared to a `Vector{String}`
Allows for fast lookup of ranges when input was sorted
Can be saved/loaded to/from a file quickly
"""
immutable StrTable{T} <: AbstractVector{String}
    offsetvec::Vector{T}
    namtab::Vector{UInt8}
end

"""Make a single table of a vector of strings"""
function StrTable{T<:AbstractString}(strvec::Vector{T})
    # convert names into a vector of UInt8 and vector of UInt16 offsets
    namvec = Vector{UInt8}()
    offvec = Vector{UInt16}(length(strvec)+1)
    offvec[1] = 0x0000
    offset = 0x0000
    for (i,str) in enumerate(strvec)
        offset += sizeof(str)
        offvec[i+1] = offset
        append!(namvec, Vector{UInt8}(str))
    end
    StrTable{UInt16}(offvec, namvec)
end

Base.getindex(str::StrTable, ind::Integer) =
    String(str.namtab[str.offsetvec[ind]+1:str.offsetvec[ind+1]])
Base.size(str::StrTable) = (length(str.offsetvec)-1,)
Base.linearindexing(::Type{StrTable}) = Base.LinearFast()
Base.start(str::StrTable) = 1
Base.next(str::StrTable, state) = (getindex(str, state), state+1)
Base.done(str::StrTable, state) = state == length(str.offsetvec)

# Get all indices that start with a string

"""Return true if this string matches the beginning at a particular index"""
@inline function _cmpsub(str::String, tab::StrTable, i)
    len = sizeof(str)
    off = tab.offsetvec[i]+1
    (tab.offsetvec[i+1] - off + 1) < len && return false
    ccall(:memcmp, Int32, (Ptr{UInt8}, Ptr{UInt8}, UInt), str, pointer(tab.namtab, off), len) == 0
end

"""Return the range of indices of values that whose beginning matches the string"""
matchfirstrng(tab::StrTable, str::AbstractString) = matchfirstrng(b, string(str))
function matchfirstrng(tab::StrTable, str::String)
    pos = searchsortedfirst(tab, str)
    len = length(tab)
    pos > len && return pos:pos-1
    beg = pos
    while pos <= len && _cmpsub(str, tab, pos)
        pos += 1
    end
    beg:pos-1
end

"""Return a vector of values that whose beginning matches the string"""
matchfirst(tab::StrTable, str::AbstractString) = tab[matchfirstrng(tab, str)]
    
# Support for saving and loading

# This use a simple format to store single Unsigned values (UInt8-UInt64),
# Vectors of Unsigned values, and StrTable values

const STRTAB_CODE = 0x0
const STRING_CODE = 0x1
const type_tab = (UInt8, UInt16, UInt32, UInt64, UInt128,
                  Int8, Int16, Int32, Int64, Int128,
                  Float16, Float32, Float64)
const SupTypes = Union{type_tab...}

_get_code(::Type{StrTable}) = STRTAB_CODE
_get_code(::Type{String})   = STRING_CODE
for (i, typ) in enumerate(type_tab)
    @eval _get_code(::Type{$typ})  = $((i+STRING_CODE)%UInt8)
end

const MAX_CODE = (length(type_tab)+1)%UInt8

const VER = 0x00000000

write_value{T<:SupTypes}(io::IO, val::T) =
    write(io, _get_code(T), val)
write_value{T<:AbstractString}(io::IO, val::T) = write_value(io, String(val))
write_value(io::IO, str::String) =
    write(io, _get_code(String), sizeof(str)%UInt16, str)
write_value{T<:SupTypes}(io::IO, val::Vector{T}) =
    (write(io, _get_code(T) | 0x80, length(val)%UInt16, val))
write_value(io::IO, tab::StrTable) =
    (write(io, STRTAB_CODE) ; write_value(io, tab.offsetvec) ; write_value(io, tab.namtab))

"""Save a collection of values (StrTable, String, Float*, UInt*, Int*) into an IO object"""
function save(io::IO, values)
    write(io, VER)
    for val in values
        write_value(io, val)
    end
end

"""Save a collection of values (StrTable, String, Float*, UInt*, Int*) into a file"""
function save(filename::AbstractString, values)
    open(filename, "w") do io
        save(io, values)
    end
end

"""Read a single StrTable, String, UInt, or Vector of UInt value from the io device"""
function read_value(io::IO)
    typ = read(io, UInt8)
    # Check for vector
    if (STRING_CODE|0x80) < typ <= (MAX_CODE|0x80)
        len = read(io, UInt16)
        res = read(io, type_tab[typ-0x81], len)
    elseif typ == STRTAB_CODE
        off = read_value(io)
        nam = read_value(io)
        res = StrTable(off, nam)
    elseif typ == STRING_CODE
        len = read(io, UInt16)
        res = String(read(io, len))
    elseif typ <= MAX_CODE
        res = read(io, type_tab[typ-1])
    else
        error("Unsupported type code $typ")
    end
end

"""Return a Vector{Any} with data tables loaded from IO"""
function load(io::IO)
    res = Vector{Any}()
    ver = read(io, UInt32)
    ver != VER && error("File version $ver doesn't match current version $VER")
    while !eof(io)
        push!(res, read_value(io))
    end
    res
end

"""Return a Vector{Any} with data tables loaded from file"""
function load(filename::AbstractString)
    open(filename) do io
        load(io)
    end
end

end # module
