using StrTables
using Base.Test

ST = StrTables

const testfile = joinpath(Pkg.dir("StrTables"), "test", "test.dat")

teststrs = sort(["AA", "AAAAA",
                 "JuliaLang", "Julia", "JuliaIO", "JuliaDB", "JuliaString",
                 "Scott", "Zulima", "David", "Alex", "Jules", "Gandalf",
                 "\U1f596 Spock Hands"])
stab     = StrTable(teststrs)
testbin  = [Vector{UInt8}(s) for s in stab]
btab     = PackedTable(testbin)

@testset "StrTables" begin
    @test length(stab) == length(teststrs)
    @test stab == teststrs
    @test stab[1] == "AA"
    @test stab[end] == "\U1f596 Spock Hands"
    @test ST.matchfirstrng(stab, "A") == 1:3
    @test ST.matchfirstrng(stab, "Julia") == 7:11
    @test ST.matchfirstrng(stab, SubString("My name is Julia", 12)) == 7:11
    @test ST.matchfirst(stab, "A") == ["AA", "AAAAA", "Alex"]
    @test ST.matchfirst(stab, "Julia") ==
        ["Julia", "JuliaDB", "JuliaIO", "JuliaLang", "JuliaString"]
end

@testset "PackedTable" begin
    @test length(btab) == length(testbin)
    @test btab == testbin
    @test btab[1] == b"AA"
    @test btab[end] == b"\U1f596 Spock Hands"
    @test ST.matchfirstrng(btab, b"A") == 1:3
    @test ST.matchfirstrng(btab, b"Julia") == 7:11
    @test ST.matchfirst(btab, b"A") == [b"AA", b"AAAAA", b"Alex"]
    @test ST.matchfirst(btab, b"Julia") ==
        [b"Julia", b"JuliaDB", b"JuliaIO", b"JuliaLang", b"JuliaString"]
end

medstr = String(rand(Char,300))
bigstr = repeat("abcdefgh",8200)
testout = [stab, btab,
           0x1, 2%UInt16, 3%UInt32, 4%UInt64, 5%UInt128,
           6%Int8, 7%Int16, 8%Int32, 9%Int64, 10%Int128,
           Float32(9.87654321), 1.23456789,
           "Test case",
           "† \U1f596",
           SubString("My name is Spock", 12),
           medstr,
           bigstr]

@testset "Read/write values" begin
    io = IOBuffer(b"\x7f")
    @test_throws ErrorException ST.read_value(io)
    @static if sizeof(Int) > 4
        x = IOBuffer(2^32) ; x.size = 2^32
        @test_throws ErrorException ST.write_value(io, String(x))
    end
end

@testset "Save/Load tables" begin
    ST.save(testfile, testout)
    @test ST.load(testfile) == testout
end
