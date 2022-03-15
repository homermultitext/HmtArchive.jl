"""Load HMT image collections from `src`.
$(SIGNATURES)
"""
function hmt_images(src::AbstractString; delimiter = "|")
    fromcex(src, ImageCollection, delimiter = delimiter)
end

"""Load HMT image collections from current CEX release of HMT project.
$(SIGNATURES)
"""
function hmt_images()
    hmt_cex() |> hmt_images
end


"""Compose a table of image counts per image collection in `codd`.
$(SIGNATURES)
"""
function coltbl_imagecounts(imgs::Vector{ImageCollection})
    dataseries = []
    for imgc in imgs
        push!(dataseries, (collection = label(imgc), count = length(imgc)))
    end
    Tables.columntable(dataseries)
end


"""Load current release and compose a table of image counts per image collection.
$(SIGNATURES)
"""
function coltbl_imagecounts()
    hmt_codices() |> coltbl_imagecounts
end

#=
groupby(f, list::Array) = begin
  foldl(list; init = Dict()) do dict, v
    push!(get!(dict, f(v), []), v)
    dict
  end
end

=#

function coltbl_indexedimagesbybook(pairlist, cat::CiteCollectionCatalog)
    
    collid = pairlist[1][2] |> Cite2Urn |> dropobject
    @info("Filter catalog for $(collid)")
    catentry = filter(entry -> collid == entry.urn, cat)[1]

    t = @from pr in pairlist begin
        @group pr by pr[1] into grp
        @select {book=key(grp),count=length(grp)}
        @collect  Tables.columntable
    end
    (label(catentry), t)
end

function coltblv_indexedimagesbybook(src::AbstractString)
    
 
 
    tables = []
    titles = []
    cat = fromcex(src,CiteCollectionCatalog)
    pgs = hmt_pageindex(src)
    for idx in pgs
        prs = map(pr -> (collapsePassageTo(pr[1], 1) |> passagecomponent, string(pr[2])), idx) |> unique
        (title, tab) = coltbl_indexedimagesbybook(prs, cat)
        push!(titles, title)
        push!(tables, tab)
    end

  
    dse = hmt_dse(src)[1]
    va = CtsUrn("urn:cts:greekLit:tlg0012.tlg001.msA:")
    vadse = filter(rec -> CitableText.urncontains(va, rec.passage),dse)
    vaprs = map(dserec ->  (collapsePassageTo(dserec.passage, 1) |> passagecomponent, string(dserec.surface)), vadse)
    (vatitle, vatab) = coltbl_indexedimagesbybook(vaprs, cat)
    push!(titles, vatitle)
    push!(tables, vatab)
  
    (titles, tables)
end

function coltbl_indexedimagesbybook()
    hmt_cex() |> coltbl_indexedimagesbybook
end