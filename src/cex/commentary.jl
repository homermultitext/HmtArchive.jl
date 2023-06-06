
"""Load DSE records from `src`. TBA
$(SIGNATURES)
"""
function hmt_commentary(src::AbstractString; delimiter = "|")
    fromcex(src, CitableCommentary, delimiter = delimiter)
end

function hmt_commentary()
    hmt_cex() |> hmt_commentary
end



