using HmtArchive
using CitableObject
using CitableBase, CitableCorpus
using EzXML


hmt = joinpath(dirname(pwd()), "hmt-archive", "archive") |> Archive
corpus = HmtArchive.archivalcorpus(hmt |> HmtArchive.edrepo)

function indexcorpus(c)
    sheep = []
    goats = []
    for psg in c.passages
        xmlnode = parsexml(psg.text)
        persnames = findall("//persName", xmlnode) |> collect
        for pn in persnames
            # pn.content is text content
            # attrs are also XML Nodes, so

            attrs = attributes(pn) |> collect
            nattrs = filter(a -> a.name == "n", attrs)
            for attr in nattrs
                personurn = nothing
                try 
                    personurn = Cite2Urn(attr.content)
                 catch 
                    @warn("Bad URN in $(psg.urn)", attr.content)
                    push!(goats, (psg.urn, attr.content))
                 else
                    push!(sheep, (psg.urn, personurn))
                end
                
            end
            
            # filter for attr.name = "n"
            # value is attr.content
            # Index attr.name and psg.urn
        end
    end
    (sheep, goats)
end

(good, bad) = indexcorpus(corpus)