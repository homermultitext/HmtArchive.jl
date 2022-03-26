function iliadreff(urnlist::Vector{CtsUrn})
    allurns = map(u -> dropexemplar(u), urnlist)
    filter(u -> startswith(workcomponent(u), "tlg0012.tlg001"), allurns)
end

function scholiareff(urnlist::Vector{CtsUrn})
    allurns = map(u -> dropexemplar(u), urnlist)
    comments = filter(u -> endswith(passagecomponent(u),"comment"), allurns)
    scholia = map(u -> collapsePassageBy(u, 1), comments)
end

"""Normalize URN values in `urnlist` for standardized comparison by
dropping exemplar identifiers, and reducing citation of scholia to whole scholion
level (rathern than citation by part of scholion).
$(SIGNATURES)
"""
function hmtreff(urnlist::Vector{CtsUrn})
    allurns = map(u -> dropexemplar(u), urnlist)
    scholia = scholiareff(allurns)
    other = filter(u -> groupid(u) != "tlg5026", allurns)
    vcat(scholia, other)
end


function hmtreff(psgs::Vector{CitablePassage})
    hmtreff(map(p -> p.urn, psgs))
end

function hmtreff(c::CitableTextCorpus)
    hmtreff(c.passages)
end