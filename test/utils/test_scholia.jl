@testset "Test working with scholia" begin
    f = joinpath(pwd(), "data", "hmt-2024c.cex")
    src = read(f, String)
    normed = hmt_normalized(src)


    # Intermarginal scholion with no lemma:
    nolemma = CtsUrn("urn:cts:greekLit:tlg5026.msAint.hmt:1.27")
    (lemm, comm) = scholion(nolemma, normed)
    
    @test isempty(text(lemm))
    @test isempty(lemma_text(nolemma, normed))

    expectedtext =  "δασύνεται τὸ ξυνἕηκε⁑"
    @test text(comm) == expectedtext
    @test scholion_text(nolemma, normed) == expectedtext
    @test scholion_text_md(nolemma, normed) ==  expectedtext

    

    haslemma = CtsUrn("urn:cts:greekLit:tlg5026.msA.hmt:1.4")
    (lemm2, comm2) = scholion(haslemma, normed)

    expectedlemma = "θεά"
    @test text(lemm2) == expectedlemma
    @test lemma_text(haslemma, normed) == expectedlemma

    expectedcomment = "οὕτως εἴωθε τὴν Μοῦσαν καλεῖν: ἀμέλει καὶ ἐν Ὀδυσσεία : ἄνδρα μοι ἔννεπε Μοῦσα ⁑"
    @test text(comm2) == expectedcomment
    @test comment_text(haslemma, normed) == expectedcomment
    
    @test scholion_text(haslemma, normed) == "θεά οὕτως εἴωθε τὴν Μοῦσαν καλεῖν: ἀμέλει καὶ ἐν Ὀδυσσεία : ἄνδρα μοι ἔννεπε Μοῦσα ⁑"


    @test scholion_text_md(haslemma, normed) =="**θεά** οὕτως εἴωθε τὴν Μοῦσαν καλεῖν: ἀμέλει καὶ ἐν Ὀδυσσεία : ἄνδρα μοι ἔννεπε Μοῦσα ⁑"
end