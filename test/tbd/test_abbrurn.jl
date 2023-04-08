
@testset "Test abbreviated URNs" begin
    aristarchus = Cite2Urn("urn:cite2:hmt:pers.v1:pers16")
    # From the CitableParserBuilder package:
    @test abbreviate(aristarchus) == "pers.pers16"

    aristarchusshort = HmtAbbreviation("pers.pers16")
    @test aristarchusshort == abbreviate(aristarchus) |> HmtAbbreviation
    @test expandabbr(aristarchusshort) == aristarchus
end