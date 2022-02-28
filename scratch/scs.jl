f = joinpath("..", "hmt-archive", "releases-cex", "hmt-current.cex")

using CitableBase
using CitableText
using CitableCorpus
c = fromcex(f, CitableTextCorpus, FileReader)
i9 = CtsUrn("urn:cts:greekLit:tlg0012.tlg001:9")
all9 = filter(p -> urncontains(i9, urn(p)), c.passages)
norm9 = filter(p -> exemplarid(urn(p)) == "normalized", all9)
urns9 = map(p -> urn(p), norm9)


aurns = filter(u -> versionid(u) == "msA", urns9)
burns = filter(u -> versionid(u) == "msB", urns9)
e3urns = filter(u -> versionid(u) == "e3", urns9)

astr = join(aurns)
bstr = join(burns)
e3str = join(e3urns)