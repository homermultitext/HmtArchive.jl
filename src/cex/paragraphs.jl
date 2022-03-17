
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




"""Create a named tuple of integers for a passage string citing book and line.
$(SIGNATURES)
"""
function bookline(s::AbstractString)
    try
        (bk,ln) = split(s, ".")
        (book = parse(Int64, bk), line = parse(Int64,ln))
    catch 
        throw(ArgumentError("Failed to parse string $(s)"))
    end
end


"""Compose an X,Y table where X is an *Iliad* book
number and Y is a line number for end of the paragraph.
`src` is a CEX release of HMT.
$(SIGNATURES)
"""
function coltbl_paragraphs(src::AbstractString)
    datapairs = []
    for u in hmt_paragraphs(src)
        if CitableText.isrange(u)
            push!(datapairs, CitableText.range_end(u) |> bookline)
        else
            @warn("$(u) is not a range! Ignoring.")
        end
    end
    datapairs  |> Tables.columntable
end

"""Compose an X,Y table where X is an *Iliad* book
number and Y is a line number for end of the paragraph.
$(SIGNATURES)
"""
function coltbl_paragraphs()
    hmt_cex() |> hmt_paragraphs()
end
