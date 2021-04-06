"""Index a scholion node to an *Iliad* passage.

($SIGNATURES)

# Arguments

- `cn` should be the citable node for the `ref` node of a scholion record.

The function returns a pairing of the canonical reference for the scholion with the *Iliad*
Urn in the `ref` node's text content.
"""
function indexrefnode(cn::CitableNode)
    nd = parsexml(cn.text) |> root 
    tidy = replace(nd.content, r"[\s]+" => "")
    try 
        (collapsePassageBy(cn.urn, 1),CtsUrn(tidy))
    catch e
        @warn "$e"
        (collapsePassageBy(cn.urn, 1),nothing)
    end
end


"""Compose a list of Tuples pairing canonical CtsUrns for scholia with CtsUrns
for the *Iliad* text.

$(SIGNATURES)
"""
function indexscholia(archive)
    # XPaths for finding the parts of the document we need:
    bookxp = "/ns:TEI/ns:text/ns:group"
    docxp = "/ns:TEI/ns:text/ns:group/ns:text"
        
    # collect files:
    scholiafiles = filter(f -> endswith(f, "xml"), readdir(scholiadir(archive)))
    fullpath = map(f -> scholiadir(archive) * f, scholiafiles)

    docs = [] 
    allscholia = []
    for f in fullpath
        try 
            doc = readxml(f).root
            # One book per file: use the book-containing element
            # to save the book value we'll need for passage URNs.
            booklevel = findall(bookxp, doc,["ns"=> EditionBuilders.teins]) 
            book = booklevel[1]["n"]

            # Scholia documents for the book in this file,
            # and their sigla, which we'll use for text ID 
            # in URNs
            scholiadocs = findall(docxp, doc,["ns"=> EditionBuilders.teins]) 
            sigla = map(root -> root["n"], scholiadocs)

            for sdoc in scholiadocs
                scholia = scholiaforbookdoc(sdoc, book)
                push!(allscholia, scholia)
            end
            
        catch e
            throw(DomainError("ERROR ON $(f) : $(e)"))
        end 
    end
    composite = CitableText.composite_array(allscholia)
    nonempty = filter(s -> ! isempty(s.text), composite.corpus)
    noreff = filter(cn -> occursin("ref", passagecomponent(cn.urn)), nonempty)
    map(cn -> indexrefnode(cn), noreff)
end