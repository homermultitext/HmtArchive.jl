using Pkg
Pkg.activate("..")

using Test
using TestSetExtensions

using HmtArchive
using HmtArchive.Analysis
using CitableText, CitableObject
using CitableCorpus
using CitableParserBuilder
using EzXML

@testset "All the tests" begin
    println(map(s -> replace(s, r".jl$" => ""), ARGS))
    @includetests map(s -> replace(s, r".jl$" => ""), ARGS)
end

