```@meta
CurrentModule = HmtArchive
```

# API documentation

```@contents
Pages = ["apis.md"]
Depth = 4
```


## Validation

- [ ] validate cataloging and citation structure of all texts
- [ ] validate orthography
- [ ] validate syntactic validity and completeness of DSE indexing
- [ ] validate syntactic validity and referential integrity of scholia references
- [ ] validate syntactic validity and  referential integrity of `persName` elements
- [ ] validate syntactic validity and  referential integrity of `placeName` elements
- [ ] validate syntactic validity and  referential integrity of `rs` elements


## Analysis

### Text corpora

#### Exported types and functions

```@docs
Archive
corpus
iliadxmlcorpus
scholiaxmlcorpus
iliaddipl
iliadnormed
scholiadipl
scholianormed

```


#### Internals

```@docs
iliaddir
scholiadir
scholiaforbookdoc
```

### Named entity management and topic modelling

#### Exported types and functions

```@docs
TMEditionBuilder
editednode
expandabbr
```

#### Internals


```@docs
editedTMelement
editedTMtext
isnamedentity
neregistry
```