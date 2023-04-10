@testset "Test composition of summary tables" begin
    f = joinpath(pwd(), "data", "hmt-2022l-modified.cex")
    src = read(f) |> String

    codd = hmt_codices(src)
    pagestable = coltbl_pagecounts(codd)
    @test pagestable.ms |> length == 7
    @test pagestable.pages |> length == 7


    imgs = hmt_images(src)
    imagestable = coltbl_imagecounts(imgs)
    @test imagestable.collection |> length == 10
    @test imagestable.count |> length == 10
end