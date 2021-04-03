# If not already instantiated:
#=
using Pkg
Pkg.activate(".")
Pkg.instantiate
=#

# If this repo is checked out adjacent to hmt-archive:
dir = string(dirname(pwd()), "/hmt-archive/")

using HmtArchive
hmt = Archive(dir)

using CitableText

# Analyzing scholia.
scholiadiplomatic = scholiadipl(hmt)
sx = scholiaxmlcorpus(hmt)


#### THESE ARE USEFUL THINGS TO WITH A CORPUS:
"""Compute list of unique textgroup.version values in `c`.
"""
function textids(c::CitableCorpus)
    alltexts = map(cn -> workcomponent(dropversion(cn.urn)), c.corpus)
    unique(alltexts)
end

"""Compose a Dict mapping group.text values to versions.
"""
function textversions(c::CitableCorpus)
    textlist = textids(c)
    pairs = []
    for t in textlist
      filtered = filter(cn -> occursin(t, workcomponent(cn.urn)), c.corpus)
      verss = unique(map(cn -> versionid(cn.urn) , filtered))
      push!(pairs, (t => verss))
    end
    Dict(pairs)
  end


### THESE SHOULD GO IN CitableText
"""Extract work ID value from a Cts Urn.
"""
function textid(u::CtsUrn)
    workparts(u)[2]
end

"""Extract version ID value from a Cts Urn.
"""
function versionid(u::CtsUrn)
	workparts(u)[3]
end