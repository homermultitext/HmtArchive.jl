@testset "Test SCS function" begin
    s1 = split("Now is the time.", "")
    s2 = split("This is the time, now.","")

    println(scs(s1, s2))
    
end