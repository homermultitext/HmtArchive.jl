@testset "Test SCS function" begin
    # Test bounds conditions:
    s1 = split("Now is the time.", "")
    s2 = split("This is the time, now.","")

    @test_broken HAA.scs(s1, s2) == "??"
end