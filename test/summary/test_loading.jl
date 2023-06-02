@testset "Test loading archive from CEX source" begin
    f = joinpath(pwd(), "data", "hmt-2022l-modified.cex")
    src = read(f) |> String

    @test hmt_releaseinfo(src) == "Homer Multitext project, release 2022l"

    imgcolls = hmt_images(src)
    @test length(imgcolls) == 10

    codices = hmt_codices(src)
    @test length(codices) == 7
    
    textcat = hmt_textcatalog(src)
    @test length(textcat) == 15

    dsesets = hmt_dse(src)
    @test length(dsesets[1]) == 25388

    dipl = hmt_diplomatic(src)
    @test length(dipl) == 39746

    normed = hmt_normalized(src)
    @test length(normed) == 39746

    iliadindices = hmt_pageindex(src)
    @test_broken length(iliadindices) == 3
end