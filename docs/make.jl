# To build these docs, you must have a copy of the hmt-archive repository
# cloned to a directory adjacent to the HmtArchive.jl root directory.
#
# Then run this from repository root:
# 
#    julia --project=docs/ docs/make.jl
#
# Serve docs from repository root:
#
#   julia -e 'using LiveServer; serve(dir="docs/build")'
#
using Pkg
Pkg.activate(".")
Pkg.instantiate()


using Documenter, DocStringExtensions
using CitableText
using EditionBuilders
using HmtArchive
using HmtArchive.Analysis

makedocs(
    sitename = "HmtArchive",
    pages = [
        "Home" => "index.md",
        "Assembling parts of the archive" => "components.md",
    
        "Analyzing a release" => Any[
            "Comparing texts" => "analysis/comparison.md"
        ],
    
    
        "Tutorials" => "tutorials.md"
    ]
    
)


deploydocs(
    repo = "github.com/homermultitext/HmtArchive.jl.git",
)

