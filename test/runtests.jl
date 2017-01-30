using StrTables
using Base.Test

ST = StrTables

const testfile = joinpath(Pkg.dir("StrTables"), "test", "test.dat")

@testset "StrTables" begin
    teststrs = sort(["AA", "AAAAA",
                     "JuliaLang", "Julia", "JuliaIO", "JuliaDB", "JuliaString",
                     "Scott", "Zulima", "David", "Alex", "Jules", "Gandalf",
                     "\U1f596 Spock Hands"])
    stab = StrTable(teststrs)

    @test length(stab) == length(teststrs)
    @test stab == teststrs
    @test stab[1] == "AA"
    @test stab[end] == "\U1f596 Spock Hands"
    @test ST.matchfirstrng(stab, "A") == 1:3
    @test ST.matchfirstrng(stab, "Julia") == 7:11
    @test ST.matchfirst(stab, "A") == ["AA", "AAAAA", "Alex"]
    @test ST.matchfirst(stab, "Julia") ==
        ["Julia", "JuliaDB", "JuliaIO", "JuliaLang", "JuliaString"]
    testout = [stab, 0x1, 2%UInt16, 3%UInt32, 4%UInt64,
               5%Int8, 6%Int16, 7%Int32, 8%Int64,
               Float32(9.87654321), 1.23456789,
               "Test case",
               "† \U1f596"]
    ST.save(testfile, testout)
    @test ST.load(testfile) == testout
end
@testset "PackedTable" begin
    teststrs = [b"AA", b"AAAAA", b"Alex", b"David", b"Gandalf",
                b"Jules", b"Julia", b"JuliaDB", b"JuliaIO", b"JuliaLang", b"JuliaString",
                b"Scott", b"Zulima", b"\U1f596 Spock Hands"]
    stab = PackedTable(teststrs)

    @test length(stab) == length(teststrs)
    @test stab == teststrs
    @test stab[1] == b"AA"
    @test stab[end] == b"\U1f596 Spock Hands"
    @test ST.matchfirstrng(stab, b"A") == 1:3
    @test ST.matchfirstrng(stab, b"Julia") == 7:11
    @test ST.matchfirst(stab, b"A") == [b"AA", b"AAAAA", b"Alex"]
    @test ST.matchfirst(stab, b"Julia") ==
        [b"Julia", b"JuliaDB", b"JuliaIO", b"JuliaLang", b"JuliaString"]
    testout = [stab, 0x1, 2%UInt16, 3%UInt32, 4%UInt64,
               5%Int8, 6%Int16, 7%Int32, 8%Int64,
               Float32(9.87654321), 1.23456789,
               "New test",
               "† \U1f595"]
#    ST.save(testfile, testout)
#    @test ST.load(testfile) == testout
end
