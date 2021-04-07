@testset "Test building text for topic modelling" begin
    nd = root(parsexml("<div n=\"comment\"><p><persName n=\"urn:cite2:hmt:pers:pers16\"><choice><abbr>Ἀρισταρχ</abbr><expan>Ἀρίσταρχος</expan></choice></persName> νεμεσσηθεῶμεν δια του <rs type=\"waw\">θε</rs>⁑</p></div>"))
    tmed = HmtArchive.editedTMtext(nd)
    wordlist = split(tmed, " ")
    @test wordlist[1] == "abbr:pers.pers16"
end

@testset "Test identification of TEI elements used for named entities" begin
    @test HmtArchive.isnamedentity("persName")
    @test HmtArchive.isnamedentity("div") == false
end


@testset "Test building node for topic modelling" begin
    txt = "<div n=\"comment\"><p><persName n=\"urn:cite2:hmt:pers:pers16\"><choice><abbr>Ἀρισταρχ</abbr><expan>Ἀρίσταρχος</expan></choice></persName> νεμεσσηθεῶμεν δια του <rs type=\"waw\">θε</rs>⁑</p></div>"
    urn = CtsUrn("urn:cts:greekLit:tlg5026.msAim.hmt:24.B3.comment")
    cn = CitableNode(urn, txt)

    bldr = HmtArchive.tmbuilder()
    tmed = editednode(bldr, cn)
    wordlist = split(tmed.text, " ")
    @test wordlist[1] == "abbr:pers.pers16"
end