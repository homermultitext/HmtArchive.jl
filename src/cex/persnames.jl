
"""Load HMT authority list for personal names from `src`.
$(SIGNATURES)
"""
function hmt_persnames(src::AbstractString; delimiter = "|")
    propblock = "#!citeproperties\nProperty|Label|Type|Authority list\n" * join(properties(src, HmtArchive.PERSONS_URN), "\n") * "\n"

    datablock = "#!citedata\nURN|mf|Character|Label|Description|Status|Redirect\n" * join(collectiondata(src, HmtArchive.PERSONS_URN), "\n")

    rdc = fromcex(propblock * datablock, RawDataCollection)
    
    catentries = filter(data(src, "citecollections")) do s
        startswith(s, string(HmtArchive.PERSONS_URN))
    end
    cataloging =  fromcex(catentries[1], CiteCatalogEntry)
    CatalogedCollection(cataloging, rdc[1])
end

"""Load HMT authority list for personal names from current release.
$(SIGNATURES)
"""
function hmt_persnames()
    hmt_cex() |> hmt_persnames
end
