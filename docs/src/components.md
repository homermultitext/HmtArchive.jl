```@setup components
root = joinpath(pwd() |> dirname |> dirname |> dirname, "hmt-archive", "archive")
using HmtArchive, EditorsRepo
hmt = Archive(root)
```

# Assembling parts of the archive

`HmtArchive` includes functions to instantiate parts of the archive as collections of citable content. In the following examples, the `hmt` variable is an instance of an `Archive`.

## Text corpora

Create a normalized corpus of all texts in the repository:

```@example components
normedcorpus = normalizedcorpus(hmt)
```
Create a diplomatic corpus of all texts in the repository:

```@example components
diplcorpus = diplomaticcorpus(hmt)
```


## DSE indexing

Collect all DSE records:


```@example components
dsecollection = dse(hmt)
```


## Indexing content of XML editions

Index scholia commenting on *Iliad*:

```@example components
commentaryindex = commentpairs(hmt)
```

Manually compiled indexes (including indexes of *Iliad* lines to incompletely
edited manuscripts):

```@example components
relationsets = relationsetscex(hmt)
```

## Summary

In the following summary lines, `hmt` is an instance of an `Archive`.  Assignment statements create collections that are then used in the example in the adjacent cell.

| Component |  Instantiate from archive | Serialize to CEX | 
| --- | --- | --- |
| diplomatic editions of all texts | `d = diplomaticcorpus(hmt)` | `cex(d)` | 
| normalized editions of all texts | `n = normalizedcorpus(hmt)`| `cex(n)` |
| catalog of all texts | `fromcex(tcex, TextCatalogCollection)` | `tcex = textcatalogcex(hmt)` |
| all DSE records| `d = dse(hmt)` | `cex(d)`|
| collection of all codices | *TBD* | `codexcex(hmt)` |
| collection of all images | *TBD* | `imagecex(hmt)` |
| collection of all data models in the library| *TBD: accounted for in `cex` methods for DSE records, codices and images* | `datamodelcex()` |
| collections of authority lists for personal names, place names, astronomical entities, and texts no longer extant | `fromcex(acex, CatalogedCollection)` |  `acex = authlistscex(hmt)` | 
| indexes of scholia to *Iliad* passages | *TBD*  | `scholiaindexcex(hmt)` |
| other indexes (including *Iliad* passages to pages) | *TBD*  | `relationsetscex(hmt)` |
