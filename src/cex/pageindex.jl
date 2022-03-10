"""Load HMT index of Iliad lines to pages from `src`.
$(SIGNATURES)
"""
function hmt_pageindex(src::AbstractString; delimiter = "|")
    fromcex(src, TextOnPage, delimiter = delimiter)
end

"""Load HMT index of Iliad lines to pages from current CEX release of HMT project.
$(SIGNATURES)
"""
function hmt_pageindex()
    hmt_cex() |> hmt_pageindex
end

