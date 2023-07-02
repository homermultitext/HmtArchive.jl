"""Load indices of named entities, and filter out index of ethnic group names.
$(SIGNATURES)
"""
function hmt_ethnicgroupsindex(src::AbstractString; delimiter = "|")
    indices = fromcex(src, NamedEntityIndex, delimiter = delimiter)
    filter(i -> i.urn == HmtArchive.ETHNICGROUP_INDEX_URN, indices)[1]
end

"""Load indices of named entities, and filter out index of ethnic group names.
$(SIGNATURES)
"""
function hmt_ethnicgroupsindex()
    hmt_cex() |> hmt_ethnicgroupsindex
end
