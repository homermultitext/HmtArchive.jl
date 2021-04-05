```@meta
CurrentModule = HmtArchive
```

# Analysis


## Create an `Archive`

You can clone or download the HMT project's publicly available repository at <https://github.com/homermultitext/hmt-archive>, or use the `localcopy` function to download the repository and create an `Archive`.

```@example dl
using HmtArchive
hmt = HmtArchive.localcopy()
isdir(hmt.root)
```


## Texts

Create a citable corpus of all texts in the archive, and count the number of citable passages of text.

```@example dl
texts = corpus(hmt)
length(texts.corpus)
```

## Topic modelling

Create an edition suitable for topic modelling.  Text is normalized, but `placeName` and `persName` entities are translated to `HmtAbbreviation` strings.

```@example dl
``