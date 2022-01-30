module HmtArchive
using Documenter, DocStringExtensions

using CitableBase, CitableText, CitableCorpus
using CitableTeiReaders, EditionBuilders

using CitableObject
using CitablePhysicalText
using EditorsRepo

#using PolytonicGreek
#using CitableObject, CitableText, CitableCorpus
#using CitableTeiReaders, EditionBuilders, CitableParserBuilder
#using EzXML, ZipFile, Downloads

export Archive
export adjacent

include("archive.jl")

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
