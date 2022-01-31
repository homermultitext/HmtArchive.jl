var documenterSearchIndex = {"docs":
[{"location":"components/","page":"Assembling parts of the archive","title":"Assembling parts of the archive","text":"root = joinpath(pwd() |> dirname |> dirname |> dirname, \"hmt-archive\", \"archive\")\nusing HmtArchive, EditorsRepo\nhmt = Archive(root)","category":"page"},{"location":"components/#Assembling-parts-of-the-archive","page":"Assembling parts of the archive","title":"Assembling parts of the archive","text":"","category":"section"},{"location":"components/","page":"Assembling parts of the archive","title":"Assembling parts of the archive","text":"HmtArchive includes functions to instantiate parts of the archive as collections of citable content. In the following examples, the hmt variable is an instance of an Archive.","category":"page"},{"location":"components/#Text-corpora","page":"Assembling parts of the archive","title":"Text corpora","text":"","category":"section"},{"location":"components/","page":"Assembling parts of the archive","title":"Assembling parts of the archive","text":"Create a normalized corpus of all texts in the repository:","category":"page"},{"location":"components/","page":"Assembling parts of the archive","title":"Assembling parts of the archive","text":"normedcorpus = normalizedcorpus(hmt)","category":"page"},{"location":"components/","page":"Assembling parts of the archive","title":"Assembling parts of the archive","text":"Create a diplomatic corpus of all texts in the repository:","category":"page"},{"location":"components/","page":"Assembling parts of the archive","title":"Assembling parts of the archive","text":"diplcorpus = diplomaticcorpus(hmt)","category":"page"},{"location":"components/#DSE-indexing","page":"Assembling parts of the archive","title":"DSE indexing","text":"","category":"section"},{"location":"components/","page":"Assembling parts of the archive","title":"Assembling parts of the archive","text":"Collect all DSE records:","category":"page"},{"location":"components/","page":"Assembling parts of the archive","title":"Assembling parts of the archive","text":"dsecollection = dse(hmt)","category":"page"},{"location":"components/#Indexing-content-of-XML-editions","page":"Assembling parts of the archive","title":"Indexing content of XML editions","text":"","category":"section"},{"location":"components/","page":"Assembling parts of the archive","title":"Assembling parts of the archive","text":"Index scholia commenting on Iliad:","category":"page"},{"location":"components/","page":"Assembling parts of the archive","title":"Assembling parts of the archive","text":"commentaryindex = commentpairs(hmt)","category":"page"},{"location":"apis/#API-documentation","page":"API documentation","title":"API documentation","text":"","category":"section"},{"location":"apis/#Publishing-the-archive","page":"API documentation","title":"Publishing the archive","text":"","category":"section"},{"location":"apis/","page":"API documentation","title":"API documentation","text":"librarycex\npublish\nwriterc","category":"page"},{"location":"apis/#HmtArchive.librarycex","page":"API documentation","title":"HmtArchive.librarycex","text":"Format contents of hmt as delimited-text in CEX format.\n\nlibrarycex(hmt, releaseid)\n\n\n\n\n\n\n","category":"function"},{"location":"apis/#HmtArchive.publish","page":"API documentation","title":"HmtArchive.publish","text":"Publish CEX file to releases-cex directory of archive.\n\npublish(hmt, releaseid)\n\n\n\n\n\n\n","category":"function"},{"location":"apis/#HmtArchive.writerc","page":"API documentation","title":"HmtArchive.writerc","text":"Write CEX file to release-candidates directory of archive.\n\nwriterc(hmt, releaseid)\n\n\n\n\n\n\n","category":"function"},{"location":"apis/#Building-pieces-of-the-archive","page":"API documentation","title":"Building pieces of the archive","text":"","category":"section"},{"location":"apis/","page":"API documentation","title":"API documentation","text":"dse","category":"page"},{"location":"apis/#HmtArchive.dse","page":"API documentation","title":"HmtArchive.dse","text":"Instantiate a DSECollection with all DSE records in the archive.\n\ndse(hmt)\n\n\n\n\n\n\n","category":"function"},{"location":"#HMTArchive.jl","page":"Home","title":"HMTArchive.jl","text":"","category":"section"},{"location":"#Overview","page":"Home","title":"Overview","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"root = joinpath(pwd() |> dirname |> dirname |> dirname, \"hmt-archive\", \"archive\")","category":"page"},{"location":"","page":"Home","title":"Home","text":"HmtArchive is a Julia package for working with the citable content freely available from the Homer Multitext project's github repository for archival data at https://github.com/homermultitext/hmt-archive. In its current early version, its primary focus is on generating a complete serialization of all material in the archive in delimited-text format following the CEX specification.","category":"page"},{"location":"#Brief-example","page":"Home","title":"Brief example","text":"","category":"section"},{"location":"#Creating-an-Archive","page":"Home","title":"Creating an Archive","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"You create an Archive object using the path in your local file system to the archive directory in a downloaded or cloned copy of the hmt-archive repository.  Here, we've defined a variable root with that full path.","category":"page"},{"location":"","page":"Home","title":"Home","text":"using HmtArchive\nhmt = Archive(root)","category":"page"},{"location":"#Publishing-an-Archive","page":"Home","title":"Publishing an Archive","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Three exported functions compile a complete description of the archive in CEX format.  All three functions take the same parameters:  an Archive, and a string value identifying the release.","category":"page"},{"location":"","page":"Home","title":"Home","text":"librarycex returns a single (large!) CEX string\nwriterc writes the CEX output to the hmt-archive's release-candidates directory\npublish writes the CEX output to the hmt-archive's releases-cex directory","category":"page"},{"location":"","page":"Home","title":"Home","text":"note: Note\nThe functions that add content to hmt-archive do not commit or push anything to the repository.  You still need to do that manually. (That is a feature.)","category":"page"},{"location":"","page":"Home","title":"Home","text":"writerc(hmt, \"2022alpha\")","category":"page"},{"location":"","page":"Home","title":"Home","text":"In the current version of HmtArchive, the CEX accounts for the following components:","category":"page"},{"location":"","page":"Home","title":"Home","text":"diplomatic editions of all texts\nnormalized editions of all texts\ncatalog of all texts\nall DSE records\ncollection of all data models in the library\ncollection of all codices\ncollection of all images\ncollections of authority lists for personal names, place names, astronomical entities, and texts no longer extant\nindexes of scholia to Iliad passages","category":"page"}]
}
