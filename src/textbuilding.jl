# Functions building text corpora from the HMT archive.

"""
Builds a single corpus comprising Venetus A Iliad and scholia in
mulitvalent archival XML edition, and univocal diplomatic and
normalized editions.

$(SIGNATURES)
"""
function corpus(archive::Archive)
    println("1. Compiling XML corpora ...")
    iliadx = iliadxmlcorpus(archive::Archive)
    scholiax = scholiaxmlcorpus(archive::Archive)
    println("2. Building dipomatic and normalized editions...")
    corpora = [
        edition(diplbuilder, iliadx), 
        edition(normbuilder, iliadx), 
        edition(diplbuilder, scholiax), 
        edition(normbuilder, scholiax), 
        iliadx,
        scholiax
    ]
    println("3. Compositing separate editions...")
    rslt = composite_array(corpora)
    println("Done.")
    rslt
end

"""Compose a diplomatic edition of *Iliad* texts.

$(SIGNATURES)
"""
function iliaddipl(archive::Archive)
    edition(diplbuilder, iliadxmlcorpus(archive))
end


"""Compose a normalized edition of *Iliad* texts.

$(SIGNATURES)
"""
function iliadnormed(archive::Archive)
    edition(normbuilder, iliadxmlcorpus(archive))
end


"""Compose a diplomatic edition of *scholia*.

$(SIGNATURES)
"""
function scholiadipl(archive::Archive)
    edition(diplbuilder, scholiaxmlcorpus(archive))
end


"""Compose a normalized edition of *scholia*.

$(SIGNATURES)
"""
function scholianormed(archive::Archive)
    edition(normbuilder, scholiaxmlcorpus(archive))
end

"""Compile a single citable edition of Venetus A Iliad.

$(SIGNATURES)
"""
function iliadxmlcorpus(archive::Archive)
    vailiad = CtsUrn("urn:cts:greekLit:tlg0012.tlg001.msA:")
    iliadfiles = filter(f -> endswith(f, "xml"), readdir(iliaddir(archive)))
    fullpath = map(f -> iliaddir(archive) * f, iliadfiles)
    corpora = [] 
    for f in fullpath
        contents = open(f) do file
            read(file, String)
        end
        try 
            push!( corpora, divAbReader(contents, vailiad))
        catch e
            println("ERROR ON $(f) : $(e)")
        end
    end
    composite_array(reverse!(corpora))
end


"""Compile a single citable edition of all Venetus A scholia.

$(SIGNATURES)
"""
function scholiaxmlcorpus(archive::Archive)
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
    noreff = filter(cn -> ! occursin("ref", passagecomponent(cn.urn)), nonempty)
    
    CitableCorpus(noreff)
end


"""Make a CitableCorpus for one scholia document in one book.

$(SIGNATURES)

# Arguments

- `docroot` is the parsed XML root node for one scholia document such as "Venetus A main scholia"  or "Venetus A intermarginal scholia"
- `bk` is the *Iliad* book number you want.
"""
function scholiaforbookdoc(docroot, bk)
    wrkcomponent = "tlg5026." *  docroot["n"] * ".hmt"
    baseurn = CtsUrn("urn:cts:greekLit:$(wrkcomponent):")
    body = elements(docroot)[1]
    scholiadivs = elements(body)
    #println("Found ", length(scholiadivs), " scholia for ", baseurn, " in book ", bk)
    citableNodes =  Array{CitableNode}(undef, 0)
    for s in scholiadivs
        scholid = "$(bk)." * s["n"]
        for div in eachelement(s)
            cn = CitableTeiReaders.citeNAttr(div, baseurn, scholid)       
            push!(citableNodes, cn)
        end
    end
    CitableCorpus(citableNodes)
end

# This is unusably slow.
function collapsecorpus(c; levels = 1)
    passageseq = map(n -> collapsePassageBy(n.urn, levels) |> dropversion, c.corpus) |> unique
    combined = []

    lastseen = ""
    for cn in c.corpus
        txt = ""
        reducedurn = collapsePassageBy(cn.urn, levels)
        if reducedurn == lastseen
            txt = txt * cn.text
        else
            lastseen = reducedurn
            txt = cn.text
            if isempty(txt)
                # skip it
            else
                newnode = CitableNode(reducedurn, txt)
                push!(combined, newnode) 
            end
        end
    end
    #=
    for psg in passageseq
        
        txt = ""
        matches = filter(n -> urncontains(psg, n.urn), c.corpus)
        for m in matches
            txt = txt * m.text
        end
        push!(combined, CitableNode(psg, txt))        
    end
    =#
    combined
end