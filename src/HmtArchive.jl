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



#=
module Analysis
    import ..HmtArchive
    using Documenter, DocStringExtensions
    using Memoize

    export scs
    
    include("analysis/scs.jl")
end

=#

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
