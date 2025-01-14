
"""In current published release of HMT, find list of texts cited in DSE record that do not appear in the corpus of a release.
$(SIGNATURES)
"""
function missing_from_edition(; interval = 50)
    missing_from_edition(hmt_cex(); interval = interval)
end

"""In `cexsrc`, find list of texts cited in DSE record that do not appear in the corpus of a release.
$(SIGNATURES)
"""
function missing_from_edition(cexsrc::AbstractString; interval = 50)
    missing_from_edition(hmt_normalized(cexsrc), hmt_dse(cexsrc)[1]; interval = interval)
end

"""Find indexed text references in `dse` that do not appear in corpus `c`.
$(SIGNATURES)
"""
function missing_from_edition(c::CitableTextCorpus, dse::DSECollection; interval = 50)
    missing_from_edition(map(p -> p.urn, c.passages), dse.data; interval = interval)
end

"""Find indexed text references in `dse` that do not appear in corpus `c`.
$(SIGNATURES)
"""
function missing_from_edition(psgs::Vector{CitablePassage}, dse::DSECollection; interval = 50)
    missing_from_edition(map(p -> p.urn, psgs), dse.data; interval = interval)
end

"""Find indexed text references in `dses` that do not appear in `texturns`.
$(SIGNATURES)
"""
function missing_from_edition(texturns::Vector{CtsUrn}, triples::Vector{DSETriple}; interval = 50)
    textreff = hmtreff(texturns) .|> string
    tripletexts = map(tr -> string(tr.passage), triples)
    mia = []
    max = length(tripletexts)
    for (i, txt) in enumerate(tripletexts)
        if mod(i,interval) == 0
            @info("$(i)/$(max)")
        end
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
function missing_from_edition(texturns::Vector{CtsUrn}, triples::Vector{DSETriple}, pg::Cite2Urn; interval = 50)
    missing_from_edition(texturns,
        filter(tr.surface == pg, triples);
        interval = interval
    )
end



"""Find indexed text references in DSE for `pg` that do not appear in `psgs`.
$(SIGNATURES)
"""
function missing_from_edition(psgs::Vector{CitablePassage}, triples::Vector{DSETriple}, pg::Cite2Urn; interval = 50) @info("Find missing texts for $(pg)")
    
    surfacerecords = filter(tr -> string(tr.surface) == string(pg), triples)
    surfacelist = map(tr -> tr.passage, surfacerecords) .|> string
    txtlist = map(p -> p.urn, psgs) |> hmtreff .|> string
    bad = []
    max = length(surfacelist)
    for (i,txt) in enumerate(surfacelist)
        if mod(i, interval) == 0
            @info("Text $(i)/$(max) on $(pg)")
        end
        if txt in txtlist
            # OK
        else
            push!(bad, txt)
        end
    end
    bad 
end


"""Find indexed text references in DSE for `pglist` that do not appear in `c`.
Report results as Tuples pairing a page reference with list of missing passages,
only including references to pages with missing passages.
$(SIGNATURES)
"""
function missing_from_edition_per_page(c::CitableTextCorpus, dsec::DSECollection, pglist::Vector{Cite2Urn}; interval = 50 )
    @info("Analyzing DSE indexing for $(length(pglist)) pages")
    
    reports = Tuple{Cite2Urn, Vector{CtsUrn}}[]
    #reports = []
  
    for pg in pglist
        @debug("Checking $(pg)")
        missinglist = missing_from_edition(c.passages, dsec.data, pg; interval = interval)
        if isempty(missinglist)
            @debug("All edited.")
        else
            @debug("Try to push for $(pg) with list $(missinglist)")
            @debug("> $(length(missinglist)) missing.")
        end
        push!(reports,(pg, CtsUrn.(missinglist)))
    end
 
    reports
end

"""Find indexed text references in `dsec` that appear in `codex` but do not appear in `c`.
Report results as Tuples pairing a page reference with list of missing passages,
only including references to pages with missing passages.
$(SIGNATURES)
"""
function missing_from_edition_per_page(c::CitableTextCorpus, dsec::DSECollection, codex::Codex; interval = 50)
    @info("Analyzing DSE indexing in $(label(codex))")
    missing_from_edition_per_page(c, dsec, map(p -> p.urn, codex.pages); interval = interval)
end
