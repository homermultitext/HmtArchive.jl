

"""Find text passages not appearing in DSE records.
$(SIGNATURES)
"""
function missingdse(c::CitableTextCorpus, dsec::DSECollection; interval = 50)
    missingdse(c.passages, dsec.data; interval = interval)
end

"""Find text passages not appearing in DSE records.
$(SIGNATURES)
"""
function missingdse(psgs::Vector{CitablePassage}, triples::Vector{DSETriple}; interval = 50)
    missingdse(map(p -> p.urn, psgs), triples; interval = interval)
end

"""Find text passages not appearing in DSE records.
$(SIGNATURES)
"""
function missingdse(texturns::Vector{CtsUrn}, triples::Vector{DSETriple}; interval = 50)
    @info("Analyzing indexing of $(length(texturns)) text passages.")
    textreff = hmtreff(texturns) .|> string
    tripletexts = map(tr -> tr.passage, triples) .|> string
    max = length(textreff)
    mia = []
    for (i,txt) in enumerate(textreff)
        if mod(i, interval) == 0
            @info("$(i)/$(max)")
        end
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

"""Report on text passages not appearing in DSE triples.
Results are grouped by the first component of the passage hierarchy.
$(SIGNATURES)
"""
function missingbybook(texturns::Vector{CtsUrn}, triples::Vector{DSETriple})  
 
    textreff = hmtreff(texturns) #.|> string
    bookreff = map(u -> collapsePassageTo(u,1) |> string, textreff) |> unique # .|> CtsUrn
    stringreff = string.(textreff)

    @info("ALL THE BOOKS: $(bookreff)")
    #report = Tuple{CtsUrn, Vector{CtsUrn}}[]
    report  = []
    for bk in string.(bookreff)
        @debug("Checking indexing of $(bk) against textreff")
        checklist = filter(s -> startswith(s, bk), stringreff) .|> CtsUrn
        missinglist = missingdse(checklist, triples) .|> CtsUrn
        
        push!(report,(book = CtsUrn(bk), missinglist = missinglist))
        if ! isempty(missinglist)
         #   @debug("> $(length(missinglist)) missing passages.")
        else
        #    @debug("All indexed in $(bk) - $(length(checklist)) passages.")
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


function missingbybook(c::CitableTextCorpus, dse::DSECollection)
    missingbybook(map(p->p.urn, c.passages), dse.data)
end