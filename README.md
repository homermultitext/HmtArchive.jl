
# HmtArchive.jl


An unregistered julia module to manage and analyze the Homer Multitext project archive (see the [archival data repository](https://github.com/homermultitext/hmt-archive).


## Current version: `0.1.1`

Supports building a text corpus from archival source for the the Venetus A manuscript.  For the *Iliad* text and each scholia document, the package can build:

- a citable corpus of multivalent, well-formed XML
- a univocal diplomatic edition
- a univocal normalized edition

## Using the module

The `hmt-archive` github repository (<https://github.com/homermultitext/hmt-archive>) includes pluto notebooks illustrating usage of the library.

Since its `Project.toml` file is already configured to use the library, you can also easily work from a julia terminal started in that directory, as follows:

First, use the package manager to `activate .` and `instantiate` the environment.

Then return to the julia prompt, import libraries and instantiate an `Archive`:

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


