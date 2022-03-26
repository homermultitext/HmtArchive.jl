

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
    @info("Analyzing indexing of $(length(texturns)) text passages.")
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


"""True if `u` refers to an *Iliad* or *Iliad* passage.
$(SIGNATURES)
"""
function isiliad(u::CtsUrn)
    contains(workcomponent(u), "tlg0012.tlg001")
end


"""True if `u` refers to a scholion or scholia document.
$(SIGNATURES)
"""
function isscholion(u::CtsUrn)
    groupid(u) == "tlg5026"
end

"""Report on text passages not appearing in `triples`.
Results are grouped by first 
component of passage hierarchy.
$(SIGNATURES)
"""
function missingbybook(texturns::Vector{CtsUrn}, triples::Vector{DSETriple})  
 
    textreff = hmtreff(texturns)
    bookreff = map(u -> collapsePassageTo(u,1) |> string, textreff) |> unique .|> CtsUrn

    report = Tuple{CtsUrn, Vector{CtsUrn}}[]
    for bk in bookreff
        @info("Checking indexing of $(bk)")
        checklist = filter(u -> urncontains(bk, u), textreff)
        #@info(typeof(checklist), typeof(triples))
        missinglist = missingdse(checklist, triples)
        if ! isempty(missinglist)
            push!(report,(bk, missinglist))
            @info("> $(length(missinglist)) missing passages.")
        else
            @info("All indexed in $(bk) - $(length(checklist)) passages.")
        end
    end
    report

end

"""Report on text passages in `psgs` not appearing in `triples`. Results are grouped by the first 
component of passage hierarchy.
$(SIGNATURES)
"""
function missingbybook(psgs::Vector{CitablePassage}, triples::Vector{DSETriple})
    missingbybook(map(p->p.urn, psgs), triples)
end