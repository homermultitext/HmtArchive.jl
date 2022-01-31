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

