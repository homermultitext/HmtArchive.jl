
"""Builder to compose editions for topic modelling.
"""
struct TMEditionBuilder  <:  EditionBuilder
    name
    versionid
end

"""Construct an edition builder for topic modelling editions

$(SIGNATURES)
"""
function tmbuilder()
    TMEditionBuilder("Edition with named entities resolved", "tm")
end

"""Builder for constructing a citable node for a diplomatic text from a citable node in archival XML.

$(SIGNATURES)
"""
function editednode(builder::TMEditionBuilder, CitablePassage::CitablePassage)
    nd  = root(parsexml(CitablePassage.text))
    editiontext = editedTMtext(nd) |> rmaccents
    CitablePassage(addversion(CitablePassage.urn, builder.versionid), editiontext)
end

"""Construct a corpus for use in topic modelling.

$(SIGNATURES)

Named entities are lemmatized to ID values; other text content is normalized.
"""
function tmcorpus(xml::CitableTextCorpus)
    builder = tmbuilder()
    nodelist = map(n -> editednode(builder, n), xml.corpus)
    CitableTextCorpus(nodelist)
end


"""Compose edited text of a given XML element using a given builder.

$(SIGNATURES)

Piggy back on the `MidNormalizedBuilder` to normalize everything except
named entities.
"""
function editedTMelement(el, accum)
    normed = MidNormalizedBuilder("Builder for normalizing choices", "normed")
    if ! validelname(normed, el.name)
        str = EditionBuilders.ezxmlstring(el)
        msg = "Invalid element $(el.name) in $(str)"
        throw(DomainError(msg))
    end

    reply = []
    if isnamedentity(el.name)
        push!(reply, namedentityid(el))

    elseif el.name == "foreign"
        push!(reply, "«" * el.content * "»")

    elseif el.name == "choice"
        if ! EditionBuilders.validchoice(el)
            children = elements(el)
            childnames = map(n -> n.name, children)
            badlist = join(childnames, ", ")
            msg = "Invalid children of `choice` element: $(badlist) in  $(EditionBuilders.ezxmlstring(el))"
            throw(DomainError(msg))
            
        else
            chosen = EditionBuilders.TEIchoice(normed, el)
            push!(reply, chosen)
        end

    elseif el.name == "w"
        push!(reply, EditionBuilders.collectw(el, normed))       
       
    elseif EditionBuilders.skipelement(normed, el.name)
        # do nothing

    else
        children = nodes(el)
        if !(isempty(children))
            for c in children
                childres =  editedTMtext(c, accum)
                push!(reply, childres)
            end
        end
    end
    strip(join(reply," "))
end



"""Convert a parsed node of XML to appropriate text string.

$(SIGNATURES)
"""
function editedTMtext(n::EzXML.Node, accum = "")::AbstractString
	rslts = [accum]
    if n.type == EzXML.ELEMENT_NODE 
        elresults = editedTMelement(n, accum)
        push!(rslts, elresults)

	elseif 	n.type == EzXML.TEXT_NODE
		tidier = EditionBuilders.cleanws(n.content )
		if !isempty(tidier)
			push!(rslts, accum * tidier)
		end
                
    elseif n.type == EzXML.COMMENT_NODE
        # do nothing
    else
        throw(DomainError("Unrecognized node type for node $(n.type)"))
	end
    stripped = strip(join(rslts," "))
    replace(stripped, r"[ \t]+" => " ")
end



"""Composes a string in format of `HmtAbbreviation` for a URN encoded with the `n` 
attribute of an XML node.

$(SIGNATURES)

"""
function namedentityid(nd)
    try 
        nodeurn = Cite2Urn(nd["n"])
        string("abbr:",abbreviate(nodeurn))
    catch e
        @warn "$e"
        "abbr:namedentity.badurn"
    end
end

"""True if `elname` is the name of an element tagging a named entity.

$(SIGNATURES)

Currently only supports `persName` and `placeName`.  HMT usage of `rs`
should be supported by consulting `type` attribute, since there are uses of
TEI `rs` for both named entities and other annotations that are only distinguished
by the `type` attribute
"""
function isnamedentity(elname::AbstractString)::Bool
    namedentityels = ["persName", "placeName"]
    # Checking for `rs` requires looking at `@type` attr
    elname in namedentityels
end