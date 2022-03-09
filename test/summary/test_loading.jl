@testset "Test loading archive from CEX source" begin
    f = joinpath(pwd(), "data", "hmt-2022l.cex")
    src = read(f) |> String

    imgcolls = hmt_images(src)
    @test length(imgs) == 10
end