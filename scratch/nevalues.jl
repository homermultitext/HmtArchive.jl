"Builder for reading diplomatic text from TEI XML following MID conventions."
struct MidNormalizedBuilder <: MidBasicBuilder
    name
    versionid
end

"Make normalized choice of MID-legal TEI choice."
function TEIchoice(builder::MidNormalizedBuilder, n)
    #= Account for:
        abbr/expan
        orig/reg
        sic/corr
    =#
    children = elements(n)
    childnames = map(n -> n.name, children)
    if "abbr" in childnames
        abbrlist = filter(n -> n.name == "expan", children)
        editedtext(builder, abbrlist[1])

    elseif "orig" in childnames
        origlist = filter(n -> n.name == "reg", children)
        editedtext(builder, origlist[1])


    elseif "sic" in childnames
        siclist = filter(n -> n.name == "corr", children)
        editedtext(builder, siclist[1])


    else
        nameslist = join(childnames, ", ")
        x = ezxmlstring(n)
        msg =  "Invalid syntax for choice element with children $(nameslist) in $(x)"
  
        throw(DomainError(msg))
    end
end

function skipelement(builder::MidNormalizedBuilder,elname)
    elname in ["del", "ref"]
end

function edition(builder::MidNormalizedBuilder, c::CitableCorpus)
    nodes = map(cn -> editednode(builder, cn), c.corpus)
    #tidied = map(cn -> tidyFrag(cn),nodes)
    CitableCorpus(nodes)
end

#=
function edition(builder::MidNormalizedBuilder, c::CitableCorpus)
    nodes = map(cn -> editednode(builder, cn), c.corpus)
    
    psgids =  map(cn -> passagecomponent(cn.urn), nodes)
    wstokens = map(cn -> split(cn.text," "), nodes)


    # Build up a dictionary of passages with trailing
    # word fragments.
    frag = r"^\+\+(.+)\+\+$"
    trailers = []
    for i in 1:length(psgids)
        tkns = wstokens[i]
        if occursin(frag, tkns[end])
            tobecontinued = match(frag, tkns[end]).captures[1] * "+"
            push!(trailers, (psgids[i], tobecontinued))
        end
    end
    trailerdict = Dict(trailers)
    # Now look at passages with initial wordfragments,
    # and update dictionary.
    wstokens

    # Finally, compose new corpus
    CitableCorpus(tidied)
end=#

