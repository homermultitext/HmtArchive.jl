"""Load diplomatic corpus from `src`.
$(SIGNATURES)
"""
function hmt_diplomatic(src::AbstractString; delimiter = "|")
    alltexts = fromcex(src, CitableTextCorpus)
    filter(psg -> endswith(workcomponent(psg.urn), "diplomatic"), alltexts.passages) |> CitableTextCorpus
end

"""Load diplomatic corpus from current CEX release of HMT project.
$(SIGNATURES)
"""
function hmt_diplomatic()
    hmt_cex() |> hmt_diplomatic
end

"""Load normalized corpus from `src`.
$(SIGNATURES)
"""
function hmt_normalized(src::AbstractString; delimiter = "|")
    alltexts = fromcex(src, CitableTextCorpus)
    filter(psg -> endswith(workcomponent(psg.urn), "normalized"), alltexts.passages) |> CitableTextCorpus
end

"""Load normalized corpus from current CEX release of HMT project.
$(SIGNATURES)
"""
function hmt_normalized()
    hmt_cex() |> hmt_normalized
end