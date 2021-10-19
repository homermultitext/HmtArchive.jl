module HmtArchive

using Documenter, DocStringExtensions
using PolytonicGreek
using CitableObject, CitableText, CitableCorpus
using CitableTeiReaders, EditionBuilders, CitableParserBuilder
using EzXML, ZipFile, Downloads

export Archive

# Builds a single corpus of all texts
# in the archive in all editions:
export corpus

# These are available if you only want to
# work with some pieces of the archive
export iliadxmlcorpus, scholiaxmlcorpus
export iliaddipl, iliadnormed
export scholiadipl, scholianormed

diplbuilder = MidDiplomaticBuilder("Diplomatic edition", "dipl")
normbuilder = MidNormalizedBuilder("Normalized edition", "normed")

# Named entity management and text editions for topic modelling
export HmtAbbreviation, expandabbr
export TMEditionBuilder, editednode


include("archive.jl")
include("directories.jl")
include("textbuilding.jl")
include("namedentity.jl")
include("TMEdition.jl")
include("remote.jl")
include("indexscholia.jl")

end # module
