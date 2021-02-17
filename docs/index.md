---
layout: page
title: HmtArchive.jl
---

# `HmtArchive.jl`: documentation


`HmtArchive.jl` is an unregistered julia package for working with the contents of the Homer Multitext project's archive at  (https://github.com/homermultitext/hmt-archive).  

The archival repository also includes pluto notebooks illustrating usage of `HmtArchive.jl`.) Its Project.toml file is already configured to use the library, so you can also easily work from a julia terminal started in that directory by activating and instantiating the environment.  (In package mode, `activate .` and `instantiate`.)

Then return to the julia prompt, import libraries and instantiate an Archive:

```julia
using HmtArchive
hmt = Archive(dirname(pwd()))
```

At that point, you can work with the archive as illustrated in the Pluto notebooks, for example, to create a citable corpus of all texts in the archive, and count the number of citable passages of text:

```julia
julia> texts = corpus(hmt)
1. Compiling XML corpora ...
2. Building dipomatic and normalized editions...
3. Compositing separate editions...
Done.
CitableText.CitableCorpus(Any[CitableText.CitableNode(CitableText.CtsUrn("urn:cts:greekLit:tlg5026.msAim.hmt:24.A1.lemma"), "<div n=\"lemma\">\n                            
...
tlg0012.tlg001.dipl:24.804"), "ὣς οἵ γ᾽ ἀμφίεπον τάφον Ἕκτορος ἱπποδάμοιο:")])
julia> 
julia> length(texts.corpus)
140820
```