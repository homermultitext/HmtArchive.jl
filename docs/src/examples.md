```@meta
CurrentModule = HmtArchive
```

# Examples

Create a local copy of the `hmt-archive` github repository.

```julia
using HmtArchive
hmt = HmtArchive.localcopy()
isdir(hmt.root)
```

Create a citable corpus of all texts in the archive, and count the number of citable passages of text.

```julia
texts = corpus(hmt)
length(texts.corpus)
```

