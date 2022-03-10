module HmtArchive
using Pkg
using Documenter, DocStringExtensions
using HTTP
using EzXML

using CitableBase, CitableText, CitableCorpus
using CitableTeiReaders, EditionBuilders

using CitableObject
using CitablePhysicalText

using EditorsRepo
import EditorsRepo: diplomaticcorpus
import EditorsRepo: normalizedcorpus



export Archive
export adjacent

export librarycex, writerc, publish

export dse
export commentpairs

include("constants.jl")
include("archive.jl")
include("indexing.jl")
include("publish.jl")


module Analysis
    using Documenter, DocStringExtensions

    import ..HmtArchive
    
    using CitableBase
    using CitableText, CitableCorpus
    using CitableObject, CitableCollection
    using CitableImage
    using CitablePhysicalText
    using CitableAnnotations
    using CiteEXchange
    using Downloads
    using Tables

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
    export hmt_authlists
    export hmt_paragraphs

    # Summarizing tables:
    export hmt_pagecounts
    export hmt_imagecounts

    # analysis functions:
    export lcs, scs
    export vertical, horizontal
    
    include("cex/load.jl")
    include("cex/images.jl")
    include("cex/codices.jl")
    include("cex/textcatalog.jl")
    include("cex/corpora.jl")
    include("cex/dse.jl")
    include("cex/commentary.jl")
    include("cex/pageindex.jl")
    include("cex/authlists.jl")
    include("cex/paragraphs.jl")

    include("analysis/scs.jl")
    include("analysis/vertical.jl")
    include("analysis/horizontal.jl")
end


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
end # module
