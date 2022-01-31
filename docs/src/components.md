# Assembling parts of the archive

`HmtArchive` includes functions to instantiate parts of the archive as collections of citable content.

## Text corpora

Create a normalized corpus of all texts in the repository:

```@example archive
using EditorsRepo
normedcorpus = normalizedcorpus(hmt)
```
Create a diplomatic corpus of all texts in the repository:

```@example archive
diplcorpus = diplomaticcorpus(hmt)
```


## DSE indexing

Collect all DSE records:


```@example archive
dsecollection = dse(hmt)
```

