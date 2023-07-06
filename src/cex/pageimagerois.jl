

"""Load indices of named entities, and filter out index of page RoIs.
$(SIGNATURES)
"""
function hmt_pagerois(src::AbstractString; delimiter = "|")
    indices = fromcex(src, PageImageZone, delimiter = delimiter)
    indices[1]
end

"""Load indices of named entities, and filter out index of page RoIs.
$(SIGNATURES)
"""
function hmt_pagerois()
    hmt_cex() |> hmt_pagerois
end