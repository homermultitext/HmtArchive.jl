"""Load HMT text catalog from `src`.
$(SIGNATURES)
"""
function hmt_textcatalog(src::AbstractString; delimiter = "|")
    fromcex(src, TextCatalogCollection, delimiter = delimiter)
end

"""Load HMT text catalog from current CEX release of HMT project.
$(SIGNATURES)
"""
function hmt_textcatalog()
    hmt_cex() |> hmt_textcatalog
end

