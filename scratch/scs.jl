f = joinpath("..", "hmt-archive", "releases-cex", "hmt-current.cex")

using CitableBase
using CitableText
using CitableCorpus
c = fromcex(f, CitableTextCorpus, FileReader)
i10 = CtsUrn("urn:cts:greekLit:tlg0012.tlg001:10")

all10 = filter(p -> urncontains(i10, urn(p)), c.passages)
norm10 = filter(p -> exemplarid(urn(p)) == "normalized", all10)
urns10 = map(p -> urn(p), norm10)


aurns = filter(u -> versionid(u) == "msA", urns10)
burns = filter(u -> versionid(u) == "msB", urns10)
e3urns = filter(u -> versionid(u) == "e3", ururns10ns9)

astr = join(aurns)
bstr = join(burns)
e3str = join(e3urns)