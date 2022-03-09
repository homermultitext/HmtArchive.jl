
"""Load HMT authority lists from `src`.
$(SIGNATURES)
"""
function hmt_authlists(src::AbstractString; delimiter = "|")
    #fromcex(src, Codex, delimiter = delimiter)
end

"""Load HMT codex page collections from current CEX release of HMT project.
$(SIGNATURES)
"""
function hmt_authlists()
    hmt_cex() |> hmt_authlists
end
