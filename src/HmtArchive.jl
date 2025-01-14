module HmtArchive
using Pkg
using Documenter, DocStringExtensions
using HTTP
using EzXML



using CitableBase, CitableText, CitableCorpus
using CitableTeiReaders, EditionBuilders

using CitableObject
using CitablePhysicalText

using CitableAnnotations

using EditorsRepo
import EditorsRepo: diplomaticcorpus
import EditorsRepo: normalizedcorpus



export Archive
# Instantiate an archive and publish to CEX:
export adjacent
export writerc, publish
export librarycex

export PageSummary, pagereport

include("constants.jl")
include("archive.jl")
include("indexing.jl")
include("publish.jl")
include("validation/page_summary.jl")

module Analysis
    using Documenter, DocStringExtensions

    import ..HmtArchive

    import Base: show
    import Base: ==
    
    using CitableBase
    import CitableBase: citabletrait
    import CitableBase: urntype
    import CitableBase: urn
    import CitableBase: label


    import CitableBase: cextrait
    import CitableBase: cex
    import CitableBase: fromcex

    using CitableText, CitableCorpus
    using CitableObject, CitableObject.CexUtils
    using CitableCollection
    using CitableImage
    using CitablePhysicalText
    using CitableAnnotations
    using CiteEXchange
    using Downloads, FileIO
    using TypedTables, SplitApplyCombine
    # Replace these:
    using Tables, Query


    export PageImageZone

    # Functions to instantiate parts of a published release:
    export hmt_cex
    export hmt_releaseinfo
    export hmt_images
    export hmt_codices
    export hmt_textcatalog
    export hmt_diplomatic
    export hmt_normalized
    export hmt_dse
    export hmt_commentary
    export hmt_pageindex
    export hmt_persnames
    export hmt_placenames
    export hmt_paragraphs
    export hmt_persnamesindex
    export hmt_placenamesindex
    export hmt_ethnicgroupsindex
    export hmt_pagerois

    # Summarizing tables:
    export coltbl_pagecounts
    export coltbl_imagecounts
    export coltbl_paragraphs
    export coltbl_imagesbyms
    export coltbl_vbbifolios
    export coltbl_e3bifolios

    export coltblv_indexedimagesbybook
    export coltblv_editedpagesbybook

    # analysis functions:
    export lcs, scs
    export vertical, horizontal


    # validation functions:
    export isiliad, isscholion
    export missing_from_edition
    export missing_from_dse, missingbybook

    # working with scholia:
    export scholion, scholion_text, scholion_text_md
    export islemma, iscomment, lemma_text, comment_text
    export scholia_on, scholia_text_on, scholia_text_md_on
    
    
    include("datamodels/pageroimodel.jl")

    include("cex/imageservice.jl")
    include("cex/load.jl")
    include("cex/images.jl")
    include("cex/codices.jl")
    include("cex/textcatalog.jl")
    include("cex/corpora.jl")
    include("cex/dse.jl")
    include("cex/commentary.jl")
    include("cex/pageindex.jl")
    include("cex/persnames.jl")
    include("cex/ethnicgroups.jl")
    include("cex/placenames.jl")
    include("cex/paragraphs.jl")
    include("cex/pageimagerois.jl")
    

    include("analysis/scs.jl")
    include("analysis/vertical.jl")
    include("analysis/horizontal.jl")

    include("textutils/scholia.jl")

    include("validation/dse_missingedition.jl")
    include("validation/text_missingdse.jl")
    include("validation/textreff.jl")
end

end # module


#
#using PolytonicGreek
#using CitableParserBuilder
#, ZipFile, Downloads


#= Named entity management and text editions for topic modelling 
export HmtAbbreviation, expandabbr
export TMEditionBuilder, editednode

=#
#=
include("directories.jl")
include("textbuilding.jl")
include("namedentity.jl")
include("TMEdition.jl")
include("remote.jl")
include("indexscholia.jl")
=#

