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
        @info("Work on ", imgc)
        if isempty(imgc.images)
            @warn("No data: ", imgc)
        else
            push!(dataseries, (collection = label(imgc), count = length(imgc), siglum = collectionid(urn(imgc))))
        end
    end
    Tables.columntable(dataseries)
end

"""Compose a table of image counts per image collection in `src`.
$(SIGNATURES)
"""
function coltbl_imagecounts(src::AbstractString)
    hmt_images(src) |> coltbl_imagecounts
end


"""Load current release and compose a table of image counts per image collection.
$(SIGNATURES)
"""
function coltbl_imagecounts()
    hmt_images() |> coltbl_imagecounts
end


"""Compose a column table from `pairlist` with a title
looked u in `cat`.  `pairlist` contains pairs of strings giving cooccurrences of Iliad book number and page number.
$(SIGNATURES)
"""
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

"""For each indexed image collection in `src`, create a list of titles and a table of counts of images per Iliad book.
$(SIGNATURES)
"""
function coltblv_indexedimagesbybook(src::AbstractString) 
    tables = []
    titles = []
    sigla = []
    cat = fromcex(src,CiteCollectionCatalog)
    pgs = hmt_pageindex(src)
    for idx in pgs
        prs = map(pr -> (collapsePassageTo(pr[1], 1) |> passagecomponent, string(pr[2])), idx) |> unique
        (title, tab) = coltbl_indexedimagesbybook(prs, cat)
        push!(titles, title)
        push!(tables, tab)
        siglum = idx.data[1][2] |> collectionid
        push!(sigla, siglum)
    end

    dse = hmt_dse(src)[1]
    va = CtsUrn("urn:cts:greekLit:tlg0012.tlg001.msA:")
    vadse = filter(rec -> CitableText.urncontains(va, rec.passage),dse)
    vaprs = map(dserec ->  (collapsePassageTo(dserec.passage, 1) |> passagecomponent, string(dserec.surface)), vadse) |> unique
    (vatitle, vatab) = coltbl_indexedimagesbybook(vaprs, cat)
    push!(titles, vatitle)
    push!(tables, vatab)
  
    (titles, tables, sigla)
end


"""For each indexed image collection in the current release of HMT, create a list of titles and a table of counts of images per Iliad book.
$(SIGNATURES)
"""
function coltbl_indexedimagesbybook()
    hmt_cex() |> coltbl_indexedimagesbybook
end