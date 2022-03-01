
@testset "Test LCS function" begin
 
    @test HmtArchive.Analysis.lcs([1,2,3], [2,3,4]) == [2,3]
  
    @test HAA.lcs([1,2,3,5], [1,2,3,4,5]) ==  [1,2,3,5]
end




@testset "Test SCS function" begin
    v1 = [1,2,3]
    v2 = [2,3,4]
    #@test HAA.scs(v1,v2) = [1,2,3,4]
    


    # Test bounds conditions:
    s1 = split("Now is the time.")
    s2 = split("This is the time, now.")

    
end
