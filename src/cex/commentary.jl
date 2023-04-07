
"""Load DSE records from `src`. TBA
$(SIGNATURES)
"""
function hmt_commentary(src::AbstractString; delimiter = "|")
    fromcex(src, CitableCommentary, delimiter = delimiter)
end


