var documenterSearchIndex = {"docs":
[{"location":"components/","page":"Assembling parts of the archive","title":"Assembling parts of the archive","text":"root = joinpath(pwd() |> dirname |> dirname |> dirname, \"hmt-archive\", \"archive\")\nusing HmtArchive, EditorsRepo\nhmt = Archive(root)","category":"page"},{"location":"components/#Assembling-parts-of-the-archive","page":"Assembling parts of the archive","title":"Assembling parts of the archive","text":"","category":"section"},{"location":"components/","page":"Assembling parts of the archive","title":"Assembling parts of the archive","text":"HmtArchive includes functions to instantiate parts of the archive as collections of citable content. In the following examples, the hmt variable is an instance of an Archive.","category":"page"},{"location":"components/#Text-corpora","page":"Assembling parts of the archive","title":"Text corpora","text":"","category":"section"},{"location":"components/","page":"Assembling parts of the archive","title":"Assembling parts of the archive","text":"Create a normalized corpus of all texts in the repository:","category":"page"},{"location":"components/","page":"Assembling parts of the archive","title":"Assembling parts of the archive","text":"normedcorpus = normalizedcorpus(hmt)","category":"page"},{"location":"components/","page":"Assembling parts of the archive","title":"Assembling parts of the archive","text":"Create a diplomatic corpus of all texts in the repository:","category":"page"},{"location":"components/","page":"Assembling parts of the archive","title":"Assembling parts of the archive","text":"diplcorpus = diplomaticcorpus(hmt)","category":"page"},{"location":"components/#DSE-indexing","page":"Assembling parts of the archive","title":"DSE indexing","text":"","category":"section"},{"location":"components/","page":"Assembling parts of the archive","title":"Assembling parts of the archive","text":"Collect all DSE records:","category":"page"},{"location":"components/","page":"Assembling parts of the archive","title":"Assembling parts of the archive","text":"dsecollection = HmtArchive.dse(hmt)","category":"page"},{"location":"components/#Indexing-content-of-XML-editions","page":"Assembling parts of the archive","title":"Indexing content of XML editions","text":"","category":"section"},{"location":"components/","page":"Assembling parts of the archive","title":"Assembling parts of the archive","text":"Index scholia commenting on Iliad:","category":"page"},{"location":"components/","page":"Assembling parts of the archive","title":"Assembling parts of the archive","text":"commentaryindex = HmtArchive.commentpairs(hmt)","category":"page"},{"location":"components/#Summary","page":"Assembling parts of the archive","title":"Summary","text":"","category":"section"},{"location":"components/","page":"Assembling parts of the archive","title":"Assembling parts of the archive","text":"In the following summary lines, hmt is an instance of an Archive; archivecex is the output of cex(hmt) (a complete representation of the archive in CEX format).","category":"page"},{"location":"components/","page":"Assembling parts of the archive","title":"Assembling parts of the archive","text":"Each line of the table represents a complete round trip beginning from the archive, to instantiate objects in Julia, serialize the object to CEX, and then instantiate equivalent objects from a CEX serialization of the entire archive.","category":"page"},{"location":"components/","page":"Assembling parts of the archive","title":"Assembling parts of the archive","text":"Component Instantiate from archive Serialize to CEX Instantiate from CEX\ncollection of all images TBD imagecex(hmt) TBA\ncollection of all codices TBD codexcex(hmt) (but currently failing to include CEX for data model?) fromcex(archivecex, Codex)\ncatalog of all texts fromcex(textcatalogcex(hmt), TextCatalogCollection) textcatalogcex(hmt) fromcex(archivecex, TextCatalogCollection)\ndiplomatic editions of all texts diplomaticcorpus(hmt) cex(diplomaticcorpus(hmt)) filter full corpus created with fromcex(archivecex, CitableTextCorpus)\nnormalized editions of all texts normalizedcorpus(hmt) cex(normalizedcorpus(hmt)) filter full corpus created with fromcex(archivecex, CitableTextCorpus)\nall DSE records dse(hmt) cex(dse(hmt)) TBA (fromcex(archivecex, DseCollection)) is broken in current version of CitablePhysicalText)\nindexes of scholia to Iliad passages TBD scholiaindexcex(hmt) TBA (fromcex(archivecex, CitableCommentary) is broken in current version of CitableAnnotations)\nother indexes (including Iliad passages to pages) TBD relationsetscex(hmt) TBA (should be instantiated using fromcex with an implementation of the index's data model)\ncollections of authority lists for personal names, place names, astronomical entities, and texts no longer extant fromcex(acex, CatalogedCollection) acex = authlistscex(hmt) TBA\ncollection of all data models in the library TBD: accounted for in cex methods for DSE records, codices and images datamodelcex() TBA","category":"page"},{"location":"apis/#API-documentation","page":"Archive: API documentation","title":"API documentation","text":"","category":"section"},{"location":"apis/#Publishing-the-archive","page":"Archive: API documentation","title":"Publishing the archive","text":"","category":"section"},{"location":"apis/","page":"Archive: API documentation","title":"Archive: API documentation","text":"librarycex\npublish\nwriterc","category":"page"},{"location":"apis/#HmtArchive.librarycex","page":"Archive: API documentation","title":"HmtArchive.librarycex","text":"Format contents of hmt as delimited-text in CEX format.\n\nlibrarycex(hmt, releaseid)\n\n\n\n\n\n\n","category":"function"},{"location":"apis/#HmtArchive.publish","page":"Archive: API documentation","title":"HmtArchive.publish","text":"Publish CEX file to releases-cex directory of archive.\n\npublish(hmt, releaseid)\n\n\n\n\n\n\n","category":"function"},{"location":"apis/#HmtArchive.writerc","page":"Archive: API documentation","title":"HmtArchive.writerc","text":"Write CEX file to release-candidates directory of archive.\n\nwriterc(hmt, releaseid)\n\n\n\n\n\n\n","category":"function"},{"location":"tutorials/#Tutorials","page":"Tutorials","title":"Tutorials","text":"","category":"section"},{"location":"tutorials/","page":"Tutorials","title":"Tutorials","text":"The tutorials directory of the github repository includes Pluto notebooks with tutorials on using this package to work with the Homer Multitext archive. You can either directly use the notebooks from the github repository or use the following links to static HTML pages:","category":"page"},{"location":"tutorials/","page":"Tutorials","title":"Tutorials","text":"reading the HMT archive","category":"page"},{"location":"summary/cex/#Working-with-a-published-release","page":"Loading a release","title":"Working with a published release","text":"","category":"section"},{"location":"summary/cex/","page":"Loading a release","title":"Loading a release","text":"The HMT archive is published as citable libraries in CEX format.","category":"page"},{"location":"apis2/#Working-with-published-releases:-API-documentation","page":"Published releases: API documentation","title":"Working with published releases: API documentation","text":"","category":"section"},{"location":"apis2/#Loading-and-identifing-a-CEX-release","page":"Published releases: API documentation","title":"Loading and identifing a CEX release","text":"","category":"section"},{"location":"apis2/","page":"Published releases: API documentation","title":"Published releases: API documentation","text":"hmt_cex\nhmt_releaseinfo","category":"page"},{"location":"apis2/#HmtArchive.Analysis.hmt_cex","page":"Published releases: API documentation","title":"HmtArchive.Analysis.hmt_cex","text":"Download current HMT release in CEX format.\n\nhmt_cex()\n\n\n\n\n\n\n","category":"function"},{"location":"apis2/#HmtArchive.Analysis.hmt_releaseinfo","page":"Published releases: API documentation","title":"HmtArchive.Analysis.hmt_releaseinfo","text":"Extract release info from library header of cexsrc.\n\nhmt_releaseinfo(cexsrc; delimiter)\n\n\n\n\n\n\n","category":"function"},{"location":"apis2/#Instantiating-parts-of-the-release","page":"Published releases: API documentation","title":"Instantiating parts of the release","text":"","category":"section"},{"location":"apis2/","page":"Published releases: API documentation","title":"Published releases: API documentation","text":"hmt_images\nhmt_codices\nhmt_textcatalog\nhmt_diplomatic\nhmt_normalized\nhmt_dse\nhmt_commentary\nhmt_pageindex\nhmt_paragraphs\nhmt_persnames\nhmt_placenames","category":"page"},{"location":"apis2/#HmtArchive.Analysis.hmt_images","page":"Published releases: API documentation","title":"HmtArchive.Analysis.hmt_images","text":"Load HMT image collections from src.\n\nhmt_images(src; delimiter)\n\n\n\n\n\n\nLoad HMT image collections from current CEX release of HMT project.\n\nhmt_images()\n\n\n\n\n\n\n","category":"function"},{"location":"apis2/#HmtArchive.Analysis.hmt_codices","page":"Published releases: API documentation","title":"HmtArchive.Analysis.hmt_codices","text":"Load HMT codex page collections from src.\n\nhmt_codices(src; delimiter)\n\n\n\n\n\n\nLoad HMT codex page collections from current CEX release of HMT project.\n\nhmt_codices()\n\n\n\n\n\n\n","category":"function"},{"location":"apis2/#HmtArchive.Analysis.hmt_textcatalog","page":"Published releases: API documentation","title":"HmtArchive.Analysis.hmt_textcatalog","text":"Load HMT text catalog from src.\n\nhmt_textcatalog(src; delimiter)\n\n\n\n\n\n\nLoad HMT text catalog from current CEX release of HMT project.\n\nhmt_textcatalog()\n\n\n\n\n\n\n","category":"function"},{"location":"apis2/#HmtArchive.Analysis.hmt_diplomatic","page":"Published releases: API documentation","title":"HmtArchive.Analysis.hmt_diplomatic","text":"Load diplomatic corpus from src.\n\nhmt_diplomatic(src; delimiter)\n\n\n\n\n\n\nLoad diplomatic corpus from current CEX release of HMT project.\n\nhmt_diplomatic()\n\n\n\n\n\n\n","category":"function"},{"location":"apis2/#HmtArchive.Analysis.hmt_normalized","page":"Published releases: API documentation","title":"HmtArchive.Analysis.hmt_normalized","text":"Load normalized corpus from src.\n\nhmt_normalized(src; delimiter)\n\n\n\n\n\n\nLoad normalized corpus from current CEX release of HMT project.\n\nhmt_normalized()\n\n\n\n\n\n\n","category":"function"},{"location":"apis2/#HmtArchive.Analysis.hmt_dse","page":"Published releases: API documentation","title":"HmtArchive.Analysis.hmt_dse","text":"Load DSE records from src.\n\nhmt_dse(src; delimiter)\n\n\n\n\n\n\nLoad DSE records from current CEX release of HMT project.\n\nhmt_dse()\n\n\n\n\n\n\n","category":"function"},{"location":"apis2/#HmtArchive.Analysis.hmt_commentary","page":"Published releases: API documentation","title":"HmtArchive.Analysis.hmt_commentary","text":"Load DSE records from src. TBA\n\nhmt_commentary(src; delimiter)\n\n\n\n\n\n\n","category":"function"},{"location":"apis2/#HmtArchive.Analysis.hmt_pageindex","page":"Published releases: API documentation","title":"HmtArchive.Analysis.hmt_pageindex","text":"Load HMT index of Iliad lines to pages from src.\n\nhmt_pageindex(src; delimiter)\n\n\n\n\n\n\nLoad HMT index of Iliad lines to pages from current CEX release of HMT project.\n\nhmt_pageindex()\n\n\n\n\n\n\n","category":"function"},{"location":"apis2/#HmtArchive.Analysis.hmt_paragraphs","page":"Published releases: API documentation","title":"HmtArchive.Analysis.hmt_paragraphs","text":"Load HMT data indexing chunking of texts in paragraphs from src.\n\nhmt_paragraphs(src; delimiter)\n\n\n\n\n\n\nLoad HMT data indexing chunking of texts in paragraphs from current CEX release of HMT project.\n\nhmt_paragraphs()\n\n\n\n\n\n\n","category":"function"},{"location":"apis2/#HmtArchive.Analysis.hmt_persnames","page":"Published releases: API documentation","title":"HmtArchive.Analysis.hmt_persnames","text":"Load HMT authority list for personal names from src.\n\nhmt_persnames(src; delimiter)\n\n\n\n\n\n\nLoad HMT authority list for personal names from current release.\n\nhmt_persnames()\n\n\n\n\n\n\n","category":"function"},{"location":"apis2/#HmtArchive.Analysis.hmt_placenames","page":"Published releases: API documentation","title":"HmtArchive.Analysis.hmt_placenames","text":"Load HMT authority list for place names from src.\n\nhmt_placenames(src; delimiter)\n\n\n\n\n\n\nLoad HMT authority list for place names from current release.\n\nhmt_placenames()\n\n\n\n\n\n\n","category":"function"},{"location":"apis2/#Tables-summarizing-parts-of-the-release","page":"Published releases: API documentation","title":"Tables summarizing parts of the release","text":"","category":"section"},{"location":"apis2/","page":"Published releases: API documentation","title":"Published releases: API documentation","text":"coltbl_pagecounts\ncoltbl_imagecounts","category":"page"},{"location":"apis2/#HmtArchive.Analysis.coltbl_pagecounts","page":"Published releases: API documentation","title":"HmtArchive.Analysis.coltbl_pagecounts","text":"Load current release and compose a table of page counts per codex.\n\ncoltbl_pagecounts()\n\n\n\n\n\n\nCompose a table of page counts per codex in the CEX source src.\n\ncoltbl_pagecounts(src)\n\n\n\n\n\n\nCompose a table of page counts per codex in codd.\n\ncoltbl_pagecounts(codd)\n\n\n\n\n\n\n","category":"function"},{"location":"apis2/#HmtArchive.Analysis.coltbl_imagecounts","page":"Published releases: API documentation","title":"HmtArchive.Analysis.coltbl_imagecounts","text":"Compose a table of image counts per image collection in codd.\n\ncoltbl_imagecounts(imgs)\n\n\n\n\n\n\nCompose a table of image counts per image collection in src.\n\ncoltbl_imagecounts(src)\n\n\n\n\n\n\nLoad current release and compose a table of image counts per image collection.\n\ncoltbl_imagecounts()\n\n\n\n\n\n\n","category":"function"},{"location":"#HMTArchive.jl","page":"Home","title":"HMTArchive.jl","text":"","category":"section"},{"location":"#Overview","page":"Home","title":"Overview","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"root = joinpath(pwd() |> dirname |> dirname |> dirname, \"hmt-archive\", \"archive\")","category":"page"},{"location":"","page":"Home","title":"Home","text":"HmtArchive is a Julia package for working with the citable content freely available from the Homer Multitext project's github repository for archival data at https://github.com/homermultitext/hmt-archive. In its current early version, its primary focus is on generating a complete serialization of all material in the archive in delimited-text format following the CEX specification, and instantiating all content in the serialized release as Julia objects.","category":"page"},{"location":"#Brief-example","page":"Home","title":"Brief example","text":"","category":"section"},{"location":"#Creating-an-Archive","page":"Home","title":"Creating an Archive","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"You create an Archive object using the path in your local file system to the archive directory in a downloaded or cloned copy of the hmt-archive repository.  Here, we've defined a variable root with that full path.","category":"page"},{"location":"","page":"Home","title":"Home","text":"using HmtArchive\nhmt = Archive(root)","category":"page"},{"location":"#Publishing-an-Archive","page":"Home","title":"Publishing an Archive","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Three exported functions compile a complete description of the archive in CEX format.  All three functions take the same parameters:  an Archive, and a string value identifying the release.","category":"page"},{"location":"","page":"Home","title":"Home","text":"librarycex returns a single (large!) CEX string\nwriterc writes the CEX output to the hmt-archive's release-candidates directory\npublish writes the CEX output to the hmt-archive's releases-cex directory","category":"page"},{"location":"","page":"Home","title":"Home","text":"note: Note\nThe functions that add content to hmt-archive do not commit or push anything to the repository.  You still need to do that manually. (That is a feature.)","category":"page"},{"location":"","page":"Home","title":"Home","text":"writerc(hmt, \"2022alpha\")","category":"page"},{"location":"","page":"Home","title":"Home","text":"In the current version of HmtArchive, the CEX accounts for the following components:","category":"page"},{"location":"","page":"Home","title":"Home","text":"diplomatic editions of all texts\nnormalized editions of all texts\ncatalog of all texts\nall DSE records\ncollection of all data models in the library\ncollection of all codices\ncollection of all images\ncollections of authority lists for personal names, place names, astronomical entities, and texts no longer extant\nindexes of scholia to Iliad passages","category":"page"},{"location":"analysis/comparison/#Comparing-texts","page":"Comparing texts","title":"Comparing texts","text":"","category":"section"},{"location":"analysis/comparison/","page":"Comparing texts","title":"Comparing texts","text":"use HmtArchive.Analysis","category":"page"},{"location":"analysis/comparison/","page":"Comparing texts","title":"Comparing texts","text":"Exported functions:","category":"page"},{"location":"analysis/comparison/","page":"Comparing texts","title":"Comparing texts","text":"scs\nlcs\nvertical","category":"page"},{"location":"analysis/comparison/","page":"Comparing texts","title":"Comparing texts","text":"TBA:","category":"page"},{"location":"analysis/comparison/","page":"Comparing texts","title":"Comparing texts","text":"horizontal","category":"page"}]
}
