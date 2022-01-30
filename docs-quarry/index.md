```@meta
CurrentModule = HmtArchive
```

# HmtArchive


`HmtArchive` is a julia package for working with the contents of the Homer Multitext project's archive at  (https://github.com/homermultitext/hmt-archive).  



The package supports building a text corpus from archival source for the the Venetus A manuscript.  For the *Iliad* text and each scholia document, the package can build:

- a citable corpus of multivalent, well-formed XML
- a univocal diplomatic edition
- a univocal normalized edition

It also provides functions to create an edition optimized for topic modelling, and to index scholia to the *Iliad* text.