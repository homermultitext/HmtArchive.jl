using HmtArchive
using HmtArchive.Analysis
using Test
using CitableText, CitableObject
using CitableCorpus
using CitableParserBuilder
using EzXML

const HAA = HmtArchive.Analysis

include("summary/test_loading.jl")
include("summary/test_summarytables.jl")


include("utils/test_scholia.jl")

#include("analysis/test_scs.jl")

# Rewrite all unit tests for >= v0.5
# 
#include("test_dl.jl")
#include("test_tm.jl")
#include("test_abbrurn.jl")
