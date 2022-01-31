"""Format contents of `hmt` as delimited-text in CEX format.
$(SIGNATURES)
"""
function publish(hmt::Archive, release::AbstractString)
    @warn("Incomplete test output")
    @warn("Release ID: ", release)
    dipls = diplomaticcorpus(hmt)
    normed = normalizedcorpus(hmt)
        
    join([
        cexheader(release),
        datamodelcex(),
        cex(dipls), 
        cex(normed), 
        cex(dse),
        codexcex(hmt),
        imagecex(hmt),
        authlistscex()
        ], "\n\n")
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
function datamodelcex()
    @warn("CEX for data models not yet implemented")
    """//
    // CEX FOR DATA MODELS NOT YET IMPLEMENTED
    //
    """
end



"""Format CEX for authority lists.
$(SIGNATURES)
"""
function datamodelcex()
    @warn("CEX for authority lists not yet implemented")
    """//
    // CEX FOR AUTHORITY LISTS NOT YET IMPLEMENTED
    //
    """
end

function cexheader(releaseid::AbstractString)
    hdrsource = """
// Metadata for the current release

#!cexversion
3.0.1

#!citelibrary
// These values are inserted programmtacally when
// the CITE library is built:
name#Homer Multitext project, release RELEASE_ID
urn#urn:cite2:hmt:publications.cex.RELEASE_ID:all
license#Creative Commons Attribution, Non-Commercial 4.0 License <https://creat\
ivecommons.org/licenses/by-nc/4.0/>.

// CITE namespace definitions
namespace#hmt#http://www.homermultitext.org/citens/hmt
namespace#greekLit#http://chs.harvard.edu/ctsns/greekLit
"""
    replace(hdrsource, "RELEASE_ID" => releaseid)
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