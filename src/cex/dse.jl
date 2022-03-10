function hmt_dse()
end


"""Load DSE records from `src`.
$(SIGNATURES)
"""
function hmt_dse(src::AbstractString; delimiter = "|")
    fromcex(src, DSECollection, delimiter = delimiter)
end

"""Load DSE records from current CEX release of HMT project.
$(SIGNATURES)
"""
function hmt_dse()
    hmt_cex() |> hmt_dse
end

