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


"""Load current release and compose a table of page counts per codex.
$(SIGNATURES)
"""
function coltbl_pagecounts()
    hmt_codices() |> coltbl_pagecounts
end

"""Compose a table of page counts per codex in `codd`.
$(SIGNATURES)
"""
function coltbl_pagecounts(codd::Vector{Codex})
    dataseries = []
    for c in codd
        push!(dataseries, (ms = label(c), pages = length(c)))
    end
    Tables.columntable(dataseries)
end
