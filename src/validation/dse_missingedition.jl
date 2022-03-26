

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



"""Find indexed text references in DSE for `pg` that do not appear in `psgs`.
$(SIGNATURES)
"""
function missingtexts(psgs::Vector{CitablePassage}, triples::Vector{DSETriple}, pg::Cite2Urn)
    missingtexts(
        map(p -> p.urn, psgs),
        filter(tr -> tr.surface == pg, triples)
    )
end


"""Find indexed text references in DSE for `pglist` that do not appear in `c`.
Report results as Tuples pairing a page reference with list of missing passages,
only including references to pages with missing passages.
$(SIGNATURES)
"""
function missingtexts(c::CitableTextCorpus, dsec::DSECollection, pglist::Vector{Cite2Urn} )
    @info("Analyzing DSE indexing for $(length(pglist)) pages")
    reports = Tuple{Cite2Urn, Vector{CtsUrn}}[]
    for pg in pglist
        @info("Checking $(pg)")
        missinglist = missingtexts(c.passages, dsec.data, pg)
        if ! isempty(missinglist)
            push!(reports,(pg, missinglist))
        end
    end
    reports
end

"""Find indexed text references in `dsec` that appear in `codex` but do not appear in `c`.
Report results as Tuples pairing a page reference with list of missing passages,
only including references to pages with missing passages.
$(SIGNATURES)
"""
function missingtexts(c::CitableTextCorpus, dsec::DSECollection, codex::Codex)
    @info("Analyzing DSE indexing in $(label(codex))")
    missingtexts(c, dsec, map(p -> p.urn, codex.pages))
end
