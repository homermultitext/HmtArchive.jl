
@testset "Test LCS function" begin
    @test HAA.lcs([1,2,3], [2,3,4]) = [2,3]
  
    @test_broken HAA.lcs([1,2,3,5], [1,2,3,4,5]) ==  [1,2,3,5]
end




@testset "Test SCS function" begin
    @test HAA.scs([1,2,3], [2,3,4]) = [1,2,3,4]
    


    # Test bounds conditions:
    s1 = split("Now is the time.")
    s2 = split("This is the time, now.")

    
end
