```@meta
CurrentModule = HmtArchive
```

# HmtArchive


`HmtArchive` is a julia package for working with the contents of the Homer Multitext project's archive at  (https://github.com/homermultitext/hmt-archive).  

You create an `Archive` from a copy of the `hmt-archive` repository in your local file system, for example,

```
hmt = Archive("PATH/TO/REPOSITORY/ROOT")
```

If you don't have git and don't want to download the repository manually, you can also use the `localcopy` function to create an `Archive` like this:

```
hmt = HmtArchive.localcopy()
```

!!! warning
    It will take several seconds to download and unzip the entire repository.


On the following page, you'll see examples of live code that download a copy of the repository, and use it to create and work with text corpora.

