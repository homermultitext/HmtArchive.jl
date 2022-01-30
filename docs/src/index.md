# HMTArchive.jl

```@setup archive
root = joinpath(pwd() |> dirname, "hmt-archive", "archive")
```

Create an `Archive` from a downloaded or cloned copy of the Homer Multitext project's github repository for archival data at https://github.com/homermultitext/hmt-archive.  Here, `root` is set to the `archive` subdirectory of the repository.


```@example archive
using HmtArchive
hmt = Archive(root)
```

Create a normalized corpus of all texts in the repository:

```@example archive
normedcorpus = normalizedcorpus(hmt)
```


Create a diplomatic corpus of all texts in the repository:

```@example archive
normedcorpus = diplomaticcorpus(hmt)
```

Collect all DSE records:


```@example archive
dsecollection = dse(hmt)
```
