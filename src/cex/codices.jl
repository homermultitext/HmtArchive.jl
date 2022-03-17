"""Load HMT codex page collections from `src`.
$(SIGNATURES)
"""
function hmt_codices(src::AbstractString; delimiter = "|")
    fromcex(src, Codex, delimiter = delimiter)
end

"""Load HMT codex page collections from current CEX release of HMT project.
$(SIGNATURES)
"""
function hmt_codices()
    hmt_cex() |> hmt_codices
end

"""Load current release and compose a table of page counts per codex.
$(SIGNATURES)
"""
function coltbl_pagecounts()
    hmt_codices() |> coltbl_pagecounts
end


"""Compose a table of page counts per codex in the CEX source `src`.
$(SIGNATURES)
"""
function coltbl_pagecounts(src::AbstractString)
    hmt_codices(src) |> coltbl_pagecounts
end

"""Compose a table of page counts per codex in `codd`.
$(SIGNATURES)
"""
function coltbl_pagecounts(codd::Vector{Codex})
    dataseries = []
    for c in codd
        push!(dataseries, (ms = label(c), pages = length(c)))
    end
    Tables.columntable(dataseries)
end

"""Compose a table of image counts per codex in `codd`.
$(SIGNATURES)
"""
function coltbl_imagesbyms(mss::Vector{Codex})
    dataseries = []
    for m in mss
        push!(dataseries, (ms = label(m), pages = length(m)))
    end
    Tables.columntable(dataseries)
end



"""Compose a table of image counts per codex in the CEX source `src`.
$(SIGNATURES)
"""
function coltbl_imagesbyms(src::AbstractString)
    hmt_codices(src) |> coltbl_imagesbyms
end

"""Compose a table of image counts per codex the current
published release of the HMT project.
$(SIGNATURES)
"""
function coltbl_imagesbyms()
    hmt_codices() |> hmt_codices |> coltbl_imagesbyms
end


"""True if `imgurn` can be successfully downloaded from `svc`.
$(SIGNATURES)
"""
function checkimg(imgurn, svc;  dim = 100 )
    iiifrequest = url(imgurn, svc, ht = dim)
    @debug("REQUEST", iiifrequest)
    try
        f = Downloads.download(iiifrequest) 
        @info("Downloaded $(f)")
        dimm = load(f) |> size
        rm(f)
        
        ok = dimm[2] == dim
        @debug("OK? $(ok)")
        ok
    catch e
        @warn("Failed to load $(imgurn)", e)
        false
    end
end

"""Compose a table of boolean values for each image
in Venetus B bifoios that is true if the image is online.
The list of images is drawn from all recto pages in the
codex model for Venetus B.
$(SIGNATURES)
"""
function coltbl_vbbifolios(src::AbstractString)
    vb = hmt_codices(src)[7]
    bifolios(vb)
end

"""Compose a table of boolean values for each image
in Upsilon 1.1 bifoios that is true if the image is online.
The list of images is drawn from all recto pages in the
codex model for Upsilon 1.1.
$(SIGNATURES)
"""
function coltbl_e3bifolios(src::AbstractString)
    e3 = hmt_codices(src)[2]
    bifolios(e3)
end



"""Compose a table of boolean values for the image
of each recto face in `ms`. The value is true if the
image is online.
$(SIGNATURES)
"""
function bifolios(ms::Codex)
    results = []
    for recto in filter(pg -> pg.rv == "recto", ms) 
        push!(results, (image = recto.image, online = checkimg(recto.image, HmtArchive.Analysis.HMT_IIIF)))
    end
    Tables.columntable(results)
end



"""For each MS represented in DSE records, create a list of titles and a table of counts of pages per Iliad book.
$(SIGNATURES)
"""
function coltblv_editedpagesbybook(src::AbstractString)
    books = []
    pages = []
    titles = []
    cat = fromcex(src,CiteCollectionCatalog)
    # All DSE records are in a single collection:
    dse = hmt_dse(src)[1]
    booksurftable = map(trip -> (book = collapsePassageTo(passage(trip),1)  |> passagecomponent, page = surface(trip) |> objectcomponent, ms = surface(trip) |> dropobject |> string), dse) |> unique |> Table 

    byms = group(booksurftable.ms, booksurftable)
    bksperms = group(getproperty(:ms), getproperty(:book), booksurftable)
    pagesperms = group(getproperty(:ms), getproperty(:page), booksurftable)
    for ms in keys(byms)
        collid = Cite2Urn(ms)
        @info("Look for $(collid)")
        catentry = filter(entry -> collid == entry.urn, cat)[1]
        push!(titles, label(catentry))
        push!(books, bksperms[ms])
        push!(pages, pagesperms[ms])
    end

    (titles, books, pages)
end

function coltblv_editedpagesbybook()
    hmt_cex() |> coltblv_editedpagesbybook
end