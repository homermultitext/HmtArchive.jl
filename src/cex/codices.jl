"""Load HMT codex page collections from `src`.
$(SIGNATURES)
"""
function hmt_codices(src::AbstractString; delimiter = "|")
    fromcex(src, Codex, delimiter = delimiter)
end

"""Load HMT codex page collections from current CEX release of HMT project.
$(SIGNATURES)
"""
function hmt_codices()
    hmt_cex() |> hmt_codices
end

