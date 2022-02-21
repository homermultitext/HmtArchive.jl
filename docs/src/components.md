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



## Summary

In the following summary lines, `hmt` is an instance of an `Archive`; `archivecex` is the output of `cex(hmt)` (a complete representation of the archive in CEX format).

Each line of the table represents a complete round trip beginning from the archive, to instantiate objects in Julia, serialize the object to CEX, and then instantiate equivalent objects from a CEX serialization of the entire archive.

| Component |  Instantiate from archive | Serialize to CEX | Instantiate from CEX |
| --- | --- | --- | --- |
| collection of all images | *TBD* | `imagecex(hmt)` | *TBA* |
| collection of all codices | *TBD* | `codexcex(hmt)` (but currently failing to include CEX for data model?)| `fromcex(archivecex, Codex)` |
| catalog of all texts | `fromcex(textcatalogcex(hmt), TextCatalogCollection)` | `textcatalogcex(hmt)` | `fromcex(archivecex, TextCatalogCollection)` |
| diplomatic editions of all texts | `diplomaticcorpus(hmt)` | `cex(diplomaticcorpus(hmt))` | filter full corpus created with `fromcex(archivecex, CitableTextCorpus)` |
| normalized editions of all texts | `normalizedcorpus(hmt)`| `cex(normalizedcorpus(hmt))` | filter full corpus created with `fromcex(archivecex, CitableTextCorpus)` |
| all DSE records| `dse(hmt)` | `cex(dse(hmt))`| *TBA* (`fromcex(archivecex, DseCollection))` is broken in current version of `CitablePhysicalText`) | 
| indexes of scholia to *Iliad* passages | *TBD*  | `scholiaindexcex(hmt)` | *TBA* (`fromcex(archivecex, CitableCommentary)` is broken in current version of `CitableAnnotations`) |
| other indexes (including *Iliad* passages to pages) | *TBD*  | `relationsetscex(hmt)` | *TBA* (should be instantiated using `fromcex` with an implementation of the index's data model) |
| collections of authority lists for personal names, place names, astronomical entities, and texts no longer extant | `fromcex(acex, CatalogedCollection)` |  `acex = authlistscex(hmt)` | *TBA* |
| collection of all data models in the library| *TBD: accounted for in `cex` methods for DSE records, codices and images* | `datamodelcex()` | *TBA* |