
"""Publish CEX file to `releases-cex` directory of archive.
$(SIGNATURES)
"""
function publish(hmt::Archive, releaseid::AbstractString)
    target = joinpath(hmt.root |> dirname, "releases-cex", "hmt-$(releaseid).cex")
    open(target, "w") do io
        write(io, librarycex(hmt, releaseid))
    end
end

"""Write CEX file to `release-candidates` directory of archive.
$(SIGNATURES)
"""
function writerc(hmt::Archive, releaseid::AbstractString)
    target = joinpath(hmt.root |> dirname, "release-candidates", "hmt-$(releaseid).cex")
    open(target, "w") do io
        write(io, librarycex(hmt, releaseid))
    end
end

function introcomment(releaseid::AbstractString) 
    lines = [
        "// CEX representation of HMT archive.",
        "// - data release: $(releaseid) ",
        "// Automatically assembled by the `HmtArchive` module.",
        "// - module version: $(HmtArchive.currentversion())"
    ]
    join(lines,"\n")
end

"""Format contents of `hmt` as delimited-text in CEX format.
$(SIGNATURES)
"""
function librarycex(hmt::Archive, releaseid::AbstractString)
    @info("Building release of HMT archive with release ID $(releaseid)")
    

    @info("Building archival corpus...")
    archivaltexts = archivalcorpus(hmt |> edrepo, skipref = true)
    @info("Building diplomatic corpus...")
    diplomatictexts = diplomaticcorpus(hmt, sourcecorpus = archivaltexts)
    @info("Building normalized corpus...")
    normalizedtexts = normalizedcorpus(hmt, sourcecorpus = archivaltexts)
    dsecollection = dse(hmt)

    @info("Assembling CEX...")
    join([
        introcomment(releaseid),
        cexheader(hmt, releaseid), 
        datamodelcex(hmt),
        cex(diplomatictexts),  
        cex(normalizedtexts), 
        textcatalogcex(hmt), 
        DSE_HEADER,
        cex(dsecollection), 
        codexcex(hmt),
        imagecex(hmt),
        authlistscex(hmt),
        scholiaindexcex(hmt), 
        relationsetscex(hmt)
        ], "\n\n")
end


"""Collect relation sets.
$(SIGNATURES)
"""
function relationsetscex(hmt::Archive)

    compositecex = []
    for f in relationfiles(hmt)
        push!(compositecex, read(f, String))
    end
    join(compositecex, "\n\n")
end

"""Format CEX index of scholia to Iliad.
$(SIGNATURES)
"""
function scholiaindexcex(hmt::Archive)
    
    rawpairs = commentpairs(hmt)
    clean = filter(pr -> ! isnothing(pr[2]), rawpairs)
    dirty = filter(pr -> isnothing(pr[2]), rawpairs)
    @warn("Failed to map the following scholia to Iliad passages:")
    msg = join(map(pr -> pr[1], dirty), "\n")
    @warn(msg)
    cexlines = map(pr -> string(pr[1]) * "|" * string(pr[2]),  clean)

    HmtArchive.COMMENTARY_HEADER * join(cexlines, "\n")
end

"""Compose CEX for authority lists managed in a separate github repository.
$(SIGNATURES)
If `adjacent` is true, read files from a clone of `hmt-authlists` in an adjacent directory; otherwise, read over the internet using `HTTP`.
"""
function authlistscex(hmt::Archive; adjacent = false)
    if ! adjacent
        remoteauthlists()
    else
       localauthlists(hmt)
    end
end

"""Read authlist data from clone of github repo in adjacent directory.
$(SIGNATURES)
"""
function localauthlists(hmt::Archive)
    repo = joinpath(hmt.root |> dirname |> dirname, 
    "hmt-authlists")
    catalogfile = joinpath(repo, "catalog", "catalog-data.cex")
    catalogcex = read(catalogfile, String)

    fullpath = joinpath(repo, "data") |> readdir
    filenames = filter(f -> endswith(f, "cex"), fullpath)        
    datacex = []
    for f in map(fname -> joinpath(repo, "data", fname), filenames)
        push!(datacex, read(f, String))
    end
    catalogcex * "\n\n" * join(datacex, "\n\n")
end

"""Read authlist data from github repo.
$(SIGNATURES)
"""
function remoteauthlists()
    rawurl = "https://raw.githubusercontent.com/homermultitext/hmt-authlists/master"
    rawcatalog = rawurl * "/catalog/catalog-data.cex"
    catalogcex = HTTP.get(rawcatalog).body |> String
    datacex = []
    datafiles = ["astronomy.cex", "citedworks.cex", "hmtnames.cex", "hmtplaces.cex"]
    for f in datafiles
        url = rawurl * "/data/" * f
        s = HTTP.get(url).body |> String
        push!(datacex, s)
    end
    catalogcex * "\n\n" * join(datacex, "\n\n")
end

"""Read text catalog CEX.
$(SIGNATURES)
"""
function textcatalogcex(hmt::Archive)
    read(textcatalogfile(hmt), String)
end

"""Find path to CEX file with text catalog.
$(SIGNATURES)
"""
function textcatalogfile(hmt::Archive)
    joinpath(hmt.root, "textconfigs", "catalog.cex")
end

"""Read all pre-formatted CEX data for codices
into a single CEX string.
$(SIGNATURES)
"""
function codexcex(hmt::Archive)
    composite = []
    for f in codexfiles(hmt)
        push!(composite, read(f, String))
    end
    join(composite, "\n\n")
end


"""Read all pre-formatted CEX data for images
into a single CEX string.
$(SIGNATURES)
"""
function imagecex(hmt::Archive)
    composite = []
    for f in imagefiles(hmt)
        push!(composite, read(f, String))
    end
    join(composite, "\n\n")
end


"""Format CEX for datamodels.
$(SIGNATURES)
This includes both data model declarations, and
a CITE Collection cataloging the data models.
"""
function datamodelcex(hmt)
    f = joinpath(hmt.root, "datamodels", "datamodels.cex")
    read(f) |> String
end

"""Remove initial comment lines.
Useful for stripping out instructions in CEX template file.
$(SIGNATURES)
"""
function stripleadcomments(s::AbstractString)
    lines = split(s, "\n")
    foundit = false
    keepers = []
    for ln in lines
        if foundit
            push!(keepers, ln)
        elseif ! startswith(ln, "//")
            foundit = true
            push!(keepers, ln)
        end
    end
    join(keepers, "\n")
end
"""Interpolate `releaseid` into CEX library header.
$(SIGNATURES)
"""
function cexheader(hmt, releaseid::AbstractString)
    f = joinpath(hmt.root, "library", "header.cex")
    template = read(f) |> String |> stripleadcomments
    replace(template, "RELEASE_ID" => releaseid)
end


