@testset "Test loading archive from CEX source" begin
    f = joinpath(pwd(), "data", "hmt-2022l.cex")
    src = read(f) |> String

    @test hmt_releaseinfo(src) == "Homer Multitext project, release 2022l"

    imgcolls = hmt_images(src)
    @test length(imgcolls) == 10
end