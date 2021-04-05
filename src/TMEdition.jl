"""
Builder to compose editions for topic modelling.


"""
struct TMEditionBuilder  <:  EditionBuilder
    name
    versionid
end

"Compose edited text of a given XML element using a given builder."
function editedTMelement(el, accum)
    basic = MidBasicBuilder("Builder for valid element names", "basic")
    normed = MidNormalizedBuilder("Builder for normalizing choices", "normed")
    if ! validelname(basic, el.name)
        str = ezxmlstring(el)
        msg = "Invalid element $(el.name) in $(str)"
        throw(DomainError(msg))
    end

    reply = []
    if el.name == "foreign"
        push!(reply, "«" * el.content * "»")

    elseif el.name == "choice"
        if ! EditionBuilders.validchoice(el)
            children = elements(el)
            childnames = map(n -> n.name, children)
            badlist = join(childnames, ", ")
            msg = "Invalid children of `choice` element: $(badlist) in  $(ezxmlstring(el))"
            throw(DomainError(msg))
            
        else
            chosen = TEIchoice(normed, el)
            push!(reply, chosen)
        end

    elseif el.name == "w"
        push!(reply, EditionBuilders.collectw(el, builder))
       
        # check for word-fragment convention:
        # `w` with `@n` attribute:
        # mark for subsequent peek-ahead
        #if hasattribute(el, "n")
        #    push!(reply, " ++$(singletoken)++ ")
        #else
        #    push!(reply, " $(singletoken) ")
        #end
       
        
        
    elseif skipelement(normed, el.name)
        # do nothing

    else
        children = nodes(el)
        if !(isempty(children))
            for c in children
                childres =  editedtext(builder, c, accum)
                push!(reply, childres)
            end
        end
    end
    strip(join(reply," "))
end


"""Convert a parsed node of XML to appropriate text string.
"""
function editedTMtext(builder::MidBasicBuilder, n::EzXML.Node, accum = "")::AbstractString
	rslts = [accum]
    if n.type == EzXML.ELEMENT_NODE 
        elresults = editedTMelement(n, accum)
        push!(rslts, elresults)

	elseif 	n.type == EzXML.TEXT_NODE
		tidier = EditonBuilders.cleanws(n.content )
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


"Builder for constructing a citable node for a diplomatic text from a citable node in archival XML."
function editednode(builder::MidBasicBuilder, citablenode::CitableNode)
    nd  = root(parsexml(citablenode.text))
    editiontext = editedTMtext(builder, nd)
    CitableNode(addversion(citablenode.urn, builder.versionid), editiontext)
end