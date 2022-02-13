
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
        cexheader(releaseid), 
        datamodelcex(),
        cex(diplomatictexts),  
        cex(normalizedtexts), 
        textcatalogcex(hmt), 
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
    for f in codexfiles(hmt)
        push!(compositecex, read(f, String))
    end
    join(compositecex, "\n\n")
end

"""Format CEX index of scholia to Iliad.
$(SIGNATURES)
"""
function scholiaindexcex(hmt::Archive)
    hdr = """#!citerelationset
urn|urn:cite2:hmt:commentary.v1:all
label|Index of scholia to *Iliad* passages they comment on
scholion|iliad
"""
    rawpairs = commentpairs(hmt)
    clean = filter(pr -> ! isnothing(pr[2]), rawpairs)
    dirty = filter(pr -> isnothing(pr[2]), rawpairs)
    @warn("Failed to map the following scholia to Iliad passages:")
    msg = join(map(pr -> pr[1], dirty), "\n")
    @warn(msg)
    cexlines = map(pr -> string(pr[1]) * "|" * string(pr[2]),  clean)

    hdr * "\n\n" * join(cexlines, "\n")
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
    for f in relationfiles(hmt)
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
function datamodelcex()
    """// CITE namespace definitions
namespace|hmt|http://www.homermultitext.org/citens/hmt
namespace|greekLit|http://chs.harvard.edu/ctsns/greekLit

// Collection of data models used in this release:

#!citecollections
URN|Description|Labelling property|Ordering property|License
urn:cite2:cite:datamodels.v1:|CITE data models|urn:cite2:cite:datamodels.v1.label:||Public domain

#!citeproperties
Property|Label|Type|Authority list
urn:cite2:cite:datamodels.v1.urn:|Data model|Cite2Urn|
urn:cite2:cite:datamodels.v1.label:|Label|String|
urn:cite2:cite:datamodels.v1.description:|Description|String|

#!citedata
urn|label|description
urn:cite2:cite:datamodels.v1:imagemodel|Citable Image|Model of a citable image.  See http://cite-architecture.github.io/imagemodel/.
urn:cite2:cite:datamodels.v1:binaryimg|Binary image data|Model of a binary image data associated with a citable image.  See TBA.
urn:cite2:cite:datamodels.v1:tbsmodel|Text Bearing Surface Model|Model of TextBearing Surfaces.  See http://cite-architecture.github.io/tbsmodel/.
urn:cite2:cite:datamodels.v1:dsemodel|Diplomatic Scholarly Edition|Diplomatic Scholarly Edition.  See https://cite-architecture.github.io/dsemodel/.
urn:cite2:cite:datamodels.v1:commentarymodel|Commentary|Model text passages commenting on text passages
"""
end


"""Interpolate `releaseid` into CEX library header.
$(SIGNATURES)
"""
function cexheader(releaseid::AbstractString)
    replace(CEX_HEADER_SOURCE, "RELEASE_ID" => releaseid)
end




#=

Data models:

CODEX:
urn:cite2:citebl:burney86pages.v1:#urn:cite2:cite:datamodels.v1:tbsmodel#Model of Burney 86 codex#British Library, Burney 86, in the CITE model of a sequence of text-bearing surfaces

CITABLE IMAGES:
urn:cite2:citebl:burney86imgs.v1:#urn:cite2:cite:datamodels.v1:imagemodel#Model of citable images of the British Library, Burney 86 manuscript#Model of citable images of the British Library, Burney 86 manuscript


BINARY IMAGE:
urn:cite2:hmt:binaryimg.v1:#urn:cite2:cite:datamodels.v1:binaryimg#Image collections supporting binary image manipulation#Image collections supporting binary image manipulation int the CITE architecture model.  See <TBA>.

DSE:
urn:cite2:hmt:va_dse.v1:#urn:cite2:cite:datamodels.v1:dsemodel#DSE model of the Venetus A manuscript#Diplomatic Scholarly Edition (DSE) model.  See documentation at <https://github.com/cite-architecture/dse>.

COMMENTARY AND ILLUSTRATION:
urn:cite2:cite:verbs.v1:#urn:cite2:cite:datamodels.v1:commentarymodel#Commentary Model#URN comments on URN. See documentation at <https://github.com/cite-architecture/commentary>.
urn:cite2:cite:verbs.v1:#urn:cite2:cite:datamodels.v1:illustrationmodel#Illustration Model#URN comments on URN. See documentation at <https://github.com/cite-architecture/illustration>.
=#