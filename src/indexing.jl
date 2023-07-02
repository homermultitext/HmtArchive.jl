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


"""Compute an index of personal names to occurrences in corpus `c`.
The corpus should be a TEI corpus with personal names identified by
URNs on the `n` attribute of a `persName` element.

Returns two lists: a list of valid pairs of URNs for text passage + name ID,
and a list of passages plus invalid CITE2URN values for personal name.
$(SIGNATURES)
"""
function indexpersnames(c::CitableTextCorpus)
    sheep = Tuple{CtsUrn, Cite2Urn}[]
    goats = []
    for psg in c.passages
        xmlnode = parsexml(psg.text)
        persnames = findall("//persName", xmlnode) |> collect
        for pn in persnames
            # Note on EzXML:
            # pn.content is text content the node
            # attrs are also XML Nodes, so attribute's value is also the `content` member
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
        end
    end
    (sheep, goats)
end

"""Compute an index of place names to occurrences in corpus `c`.
The corpus should be a TEI corpus with place names identified by
URNs on the `n` attribute of a `placeName` element.

Returns two lists: a list of valid pairs of URNs for text passage + name ID,
and a list of passages plus invalid CITE2URN values for place name.
$(SIGNATURES)
"""
function indexplacenames(c::CitableTextCorpus)
    sheep = Tuple{CtsUrn, Cite2Urn}[]
    goats = []
    for psg in c.passages
        xmlnode = parsexml(psg.text)
        placenames = findall("//placeName", xmlnode) |> collect
        for pn in placenames
            # Note on EzXML:
            # pn.content is text content the node
            # attrs are also XML Nodes, so attribute's value is also the `content` member
            attrs = attributes(pn) |> collect
            nattrs = filter(a -> a.name == "n", attrs)
            for attr in nattrs
                placeurn = nothing
                try 
                    placeurn = Cite2Urn(attr.content)
                 catch 
                    @warn("Bad URN in $(psg.urn)", attr.content)
                    push!(goats, (psg.urn, attr.content))
                 else
                    push!(sheep, (psg.urn, placeurn))
                end 
            end
        end
    end
    (sheep, goats)
end



"""Compute an index of ethnic group names to occurrences in corpus `c`.
The corpus should be a TEI corpus with ethnic group names identified by
URNs on the `n` attribute of an `rs` element with `type` attribute = `ethnic`.

Returns two lists: a list of valid pairs of URNs for text passage + name ID,
and a list of passages plus invalid CITE2URN values for ethnic group name.
$(SIGNATURES)
"""
function indexethnicgroups(c::CitableTextCorpus)
    sheep = Tuple{CtsUrn, Cite2Urn}[]
    goats = []

    for psg in c.passages
        xmlnode = parsexml(psg.text)
        ethnicnames = findall("//rs", xmlnode) |> collect
        for pn in ethnicnames
            if isethnic(pn)
                attrs = attributes(pn) |> collect
                nattrs = filter(a -> a.name == "n", attrs)
                
                for attr in nattrs
                    placeurn = nothing
                    try 
                        placeurn = Cite2Urn(attr.content)
                    catch 
                        @warn("Bad URN in $(psg.urn)", attr.content)
                        push!(goats, (psg.urn, attr.content))
                    else
                        push!(sheep, (psg.urn, placeurn))
                    end 
                end
        end
        end
    end
    (sheep, goats)
end

"""True of XML node `nd` is an `rs` element of type `ethnic`.
$(SIGNATURES)
"""
function isethnic(nd::EzXML.Node)
    attrs = attributes(nd)
    ethnic = false
    for a in attrs
        if a.name == "type" && a.content == "ethnic"
            ethnic = true
        end
    end
    ethnic
end