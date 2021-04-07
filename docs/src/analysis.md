```@meta
CurrentModule = HmtArchive
```

# Analysis


## Create an `Archive`

You can clone or download the HMT project's publicly available repository at <https://github.com/homermultitext/hmt-archive>, or use the `localcopy` function to download the repository and create an `Archive`.

```
using HmtArchive
hmt = HmtArchive.localcopy()
isdir(hmt.root)
```


## Texts

Create a citable corpus of all texts in the archive, and count the number of citable passages of text.

```
texts = corpus(hmt)
length(texts.corpus)
```

## Topic modelling



Build an edition suitable for topic modelling from an XML corpus.  Text is normalized, but `placeName` and `persName` entities are translated to `HmtAbbreviation` strings.


```
scholiaxml = scholiaxmlcorpus(hmt)
tmcorp = HmtArchive.tmcorpus(scholiaxml)
length(tmcorp.corpus)
```
Look at text from an example node: `pers.pers1` is Aristarchus.

```
words = split(tmcorp.corpus[10].text, " ")
```