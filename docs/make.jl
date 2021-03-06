# Run this from repository root, e.g. with
# 
#    julia --project=docs/ docs/make.jl
#
using Pkg
Pkg.activate(".")
Pkg.instantiate()


using Documenter, DocStringExtensions
using CitableText
using EditionBuilders
using HmtArchive

makedocs(
    sitename = "HmtArchive",
    pages = [
        "Home" => "index.md",
        "Guide" => [
            "validation.md",
            "analysis.md"
            
        ],
        "API documentation" => "apis.md"
    ]
    
)


deploydocs(
    repo = "github.com/homermultitext/HmtArchive.jl.git",
)

