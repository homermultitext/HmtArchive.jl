"""Compute pairs of CtsUrns mapping scholion URN to Iliad Urn.
$(SIGNATURES)
"""
function commentpairs(hmt::Archive)
    @info("Compiling XML corpus to index...")
    xmlcorp = EditorsRepo.archivalcorpus(hmt |> HmtArchive.edrepo, skipref = false)
    reflist = filter(psg -> endswith(passagecomponent(psg.urn), "ref"),  xmlcorp.passages)
    prs = []
    for ref in reflist
        push!(prs, indexrefnode(ref))
    end
    prs
end

"""Index a scholion node to an *Iliad* passage.

($SIGNATURES)

# Arguments

- `cn` should be the citable node for the `ref` node of a scholion record.

The function returns a pairing of the canonical reference for the scholion with the *Iliad* Urn in the `ref` node's text content.
"""
function indexrefnode(psg::CitablePassage)
    nd = parsexml(psg.text) |> root 
    tidy = nd.content |> strip
    try 
        (collapsePassageBy(psg.urn, 1),CtsUrn(tidy))
    catch e
        @warn "$e"
        (collapsePassageBy(psg.urn, 1),nothing)
    end
end
