
"""Load HMT authority list for place names from `src`.
$(SIGNATURES)
"""
function hmt_placenames(src::AbstractString; delimiter = "|")
    propblock = "#!citeproperties\nProperty|Label|Type|Authority list\n" * join(properties(src, HmtArchive.PLACES_URN), "\n") * "\n"

    datablock = "#!citedata\nURN|Label|Description|Pleiades|Status|Redirect\n" * join(collectiondata(src, HmtArchive.PLACES_URN), "\n")

    rdc = fromcex(propblock * datablock, RawDataCollection)
    
    catentries = filter(data(src, "citecollections")) do s
        startswith(s, string(HmtArchive.PLACES_URN))
    end
    cataloging =  fromcex(catentries[1], CiteCatalogEntry)
    CatalogedCollection(cataloging, rdc[1])

end

"""Load HMT authority list for place names from current release.
$(SIGNATURES)
"""
function hmt_placenames()
    hmt_cex() |> hmt_placenames
end
