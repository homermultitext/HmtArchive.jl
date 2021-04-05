module HmtArchive

using CitableObject, CitableText
using CitableTeiReaders, EditionBuilders
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

include("archive.jl")
include("directories.jl")
include("textbuilding.jl")
include("TMEdition.jl")
include("remote.jl")

end # module
