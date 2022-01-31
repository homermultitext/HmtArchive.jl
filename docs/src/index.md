# HMTArchive.jl


## Overview

```@setup archive
root = joinpath(pwd() |> dirname |> dirname |> dirname, "hmt-archive", "archive")
```

`HmtArchive` is a Julia package for working with the citable content freely available from the Homer Multitext project's github repository for archival data at https://github.com/homermultitext/hmt-archive. In its current early version, its primary focus is on generating a complete serialization of all material in the archive in delimited-text format following the CEX specification.

## Brief example


### Creating an `Archive`

You create an `Archive` object using the path in your local file system to the `archive` directory in a downloaded or cloned copy of the `hmt-archive` repository.  Here, we've defined a variable `root` with that full path.


```@example archive
using HmtArchive
hmt = Archive(root)
```


### Publishing an `Archive`

Three exported functions compile a complete description of the archive in CEX format.  All three functions take the same parameters:  an `Archive`, and a string value identifying the release.

1. `librarycex` returns a single (large!) CEX string
2. `writerc` writes the CEX output to the `hmt-archive`'s `release-candidates` directory
3. `publish` writes the CEX output to the `hmt-archive`'s `releases-cex` directory

!!! note

    The functions that add content to `hmt-archive` do **not** commit or push anything to the repository.  You still need to do that manually. (That is a feature.)

```@example archive
writerc(hmt, "2022alpha")
```

In the current version of `HmtArchive`, the CEX accounts for the following components:

- diplomatic editions of all texts
- normalized editions of all texts
- catalog of all texts
- all DSE records
- collection of all data models in the library
- collection of all codices
- collection of all images
- collections of authority lists for personal names, place names, astronomical entities, and texts no longer extant
- indexes of scholia to *Iliad* passages

