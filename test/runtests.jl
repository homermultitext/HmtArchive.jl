using HmtArchive
using Test
using CitableText
using EzXML

@testset "Test building node for topic modelling" begin
    nd = root(parsexml("<div n=\"comment\"><p><persName n=\"urn:cite2:hmt:pers:pers16\"><choice><abbr>Ἀρισταρχ</abbr><expan>Ἀρίσταρχος</expan></choice></persName> νεμεσσηθεῶμεν δια του <rs type=\"waw\">θε</rs>⁑</p></div>"))
    tmed = HmtArchive.editedTMtext(nd)
    println(tmed)
end