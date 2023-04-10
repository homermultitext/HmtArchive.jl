#
# Some constant values:  URNs for data models of collections
#

"""URN for model of a collection of records indexing text passages to chunks (paragraphs)."""
PARAGRAPH_MODEL = Cite2Urn("urn:cite2:hmt:datamodels.v1:paragraphing")


# This should be generated by a better implementation
# of `cex` for these types.
"""Data model and relation set declaration for scholia-passage indexing."""
COMMENTARY_HEADER = """

#!datamodels
Collection|Model|Label|Description
urn:cite2:hmt:commentary.v1:all|$(CitableAnnotations.COMMENTARY_MODEL)|Relation of commentary to text passages commented on.

#!citerelationset
urn|urn:cite2:hmt:commentary.v1:all
label|Index of scholia to *Iliad* passages they comment on

scholion|iliad
"""


#
# Some constant values:  URNs for collections
#
"""URN for a `DSECollection` with all HMT project DSE records."""
DSE_URN = Cite2Urn("urn:cite2:hmt:hmtdse.v1:all")

"""URN for a collection with authority list for HMT place names."""
PLACES_URN = Cite2Urn("urn:cite2:hmt:place.v1:")

"""URN for a collection with authority list for HMT names of persons."""
PERSONS_URN = Cite2Urn("urn:cite2:hmt:pers.v1:")

