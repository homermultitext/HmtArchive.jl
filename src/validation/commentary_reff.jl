"""In current published release of HMT, find list of scholia referring to lines of the Iliad that do not exist in this release.
$(SIGNATURES)
"""
function bad_xref(; interval = 5000)
    bad_xref(hmt_cex(); interval = interval)
end

"""In a published release of HMT, find list of scholia referring to lines of the Iliad that do not exist in this release.
$(SIGNATURES)
"""
function bad_xref(cexsrc::AbstractString; interval = 5000)
    bad_xref(hmt_normalized(cexsrc), hmt_dse(cexsrc)[1]; interval = interval)
end

function bad_xref(c::CitableTextCorpus, dse::DSECollection; interval = 5000)
    bad_xref(map(p -> p.urn, c.passages), dse.data; interval = interval)
end

function bad_xref(texturns::Vector{CtsUrn}, triples::Vector{DSETriple}; interval = 5000)
    dsepsgs = map(tr -> string(tr.passage), triples)
    txtpsgs = hmtreff(texturns) .|> string
    
    bad = []
    max = length(dsepsgs)
    for (i,psg) in enumerate(dsepsgs)
        if mod(i, interval) == 0
            @info("$(i)/$(max)")
        end
        if psg in txtpsgs
            # ok
        else
            push!(bad, psg)
        end
    end
    bad
end