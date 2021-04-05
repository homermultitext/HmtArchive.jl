
@testset "Test building archive from download" begin
    hmt = localcopy()
    @test isa(hmt, Archive)
end