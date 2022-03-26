"""Normalize URN values in `urnlist` for standardized comparison by
dropping exemplar identifiers, and reducing citation of scholia to whole scholion
level (rathern than citation by part of scholion).
$(SIGNATURES)
"""
function hmtreff(urnlist::Vector{CtsUrn})
    allurns = map(u -> dropexemplar(u), urnlist)
    comments = filter(u -> endswith(passagecomponent(u),"comment"), allurns)
    scholia = map(u -> collapsePassageBy(u, 1), comments)
    other = filter(u -> groupid(u) != "tlg5026", allurns)
    vcat(scholia, other)
end


function hmtreff(psgs::Vector{CitablePassage})
    hmtreff(map(p -> p.urn, psgs))
end

function hmtreff(c::CitableTextCorpus)
    hmtreff(c.passages)
end

"""In current published release of HMT, find indexed text references that do not appear in text corpus.
$(SIGNATURES)
"""
function missingtexts()
    missingtexts(hmt_cex())
end

"""In `cexsrc`, find indexed text references that do not appear in text corpus.
$(SIGNATURES)
"""
function missingtexts(cexsrc::AbstractString)
    missingtexts(hmt_normalized(cexsrc), hmt_dse(cexsrc)[1])
end

"""Find indexed text references in `dse` that do not appear in corpus `c`.
$(SIGNATURES)
"""
function missingtexts(c::CitableTextCorpus, dse::DSECollection)
    missingtexts(map(p -> p.urn, c.passages), dse.data)
end

"""Find indexed text references in `dse` that do not appear in corpus `c`.
$(SIGNATURES)
"""
function missingtexts(psgs::Vector{CitablePassage}, dse::DSECollection)
    missingtexts(map(p -> p.urn, psgs), dse.data)
end

"""Find indexed text references in `dses` that do not appear in `texturns`.
$(SIGNATURES)
"""
function missingtexts(texturns::Vector{CtsUrn}, triples::Vector{DSETriple})
    textreff = hmtreff(texturns)
    tripletexts = map(tr -> tr.passage, triples)
    mia = []
    for txt in tripletexts
        if txt in textreff
        else
            push!(mia, txt)
        end
    end
    mia
end


"""Find indexed text references in DSE for `pg` that do not appear in `texturns`.
$(SIGNATURES)
"""
function missingtexts(texturns::Vector{CtsUrn}, triples::Vector{DSETriple}, pg::Cite2Urn)
    missingtexts(texturns,
        filter(tr.surface == pg, triples)
    )
end


function missingtexts(psgs::Vector{CitablePassage}, triples::Vector{DSETriple}, pg::Cite2Urn)
    missingtexts(
        map(p -> p.urn, psgs),
        filter(tr -> tr.surface == pg, triples)
    )
end




"""Find text passages not appearing in DSE records.
$(SIGNATURES)
"""
function missingdse(c::CitableTextCorpus, dsec::DSECollection)
    missingdse(c.passages, dsec.data)
end

"""Find text passages not appearing in DSE records.
$(SIGNATURES)
"""
function missingdse(psgs::Vector{CitablePassage}, triples::Vector{DSETriple})
    missingdse(map(p -> p.urn, psgs), triples)
end

"""Find text passages not appearing in DSE records.
$(SIGNATURES)
"""
function missingdse(texturns::Vector{CtsUrn}, triples::Vector{DSETriple})
    textreff = hmtreff(texturns)
    tripletexts = map(tr -> tr.passage, triples)
    mia = []
    for txt in textreff
        if txt in tripletexts
        else
            push!(mia, txt)
        end
    end
    mia
end

