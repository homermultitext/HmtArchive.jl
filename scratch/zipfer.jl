
using EditionBuilders
using CitableText
using FreqTables
using ManuscriptOrthography
using Orthography

sch = scholianormed(hmt)
comments = filter(cn -> endswith(passagecomponent(cn.urn), "comment"), sch.corpus)

#Use MS orthography and tokenize corpus
ortho = msGreek()
tkns = map(cn -> tokenize(ortho, cn.text), comments) |> Iterators.flatten |> collect


function histfornodes(tknlist)
    # Select lexical tokens, and extract text content:
    lex = filter(t ->  t.tokencategory == LexicalToken(), tknlist)
    tstrs = map(l -> l.text, lex)
    hist = sort(freqtable(tstrs); rev=true)
    hist
end


avglen = length(lex) ÷ length(comments)

function writefreqs(histo, outfile)
    output = []
    for n in names(histo)[1]
        push!(output, string(n,"|", hist[n]))
    end
    open(outfile,"w")  do io
        println(io, join(output, "\n"))
    end
end


bk8urn = CtsUrn("urn:cts:greekLit:tlg5026:8")
bk9urn = CtsUrn("urn:cts:greekLit:tlg5026:9")
bk10urn = CtsUrn("urn:cts:greekLit:tlg5026:10")


bk8 = filter(cn -> urncontains(bk8urn, cn.urn), comments) |> CitableCorpus
bk9 = filter(cn -> urncontains(bk9urn, cn.urn), comments) |> CitableCorpus
bk10 = filter(cn -> urncontains(bk10urn, cn.urn), comments) |> CitableCorpus

bks = composite_array([bk8, bk9, bk10])

bkstkns = map(cn -> tokenize(ortho, cn.text), bks.corpus) |> Iterators.flatten |> collect
