
@testset "Test building archive from download" begin
    hmt = HmtArchive.localcopy()
    @test isa(hmt, Archive)
end