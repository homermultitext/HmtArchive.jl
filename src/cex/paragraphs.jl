
"""Load HMT data indexing chunking of texts in paragraphs from `src`.
$(SIGNATURES)
"""
function hmt_paragraphs(src::AbstractString; delimiter = "|")
    relations_for_model(src, HmtArchive.PARAGRAPH_MODEL) .|> CtsUrn
end

"""Load HMT data indexing chunking of texts in paragraphs from current CEX release of HMT project.
$(SIGNATURES)
"""
function hmt_paragraphs()
    hmt_cex() |> hmt_paragraphs
end

