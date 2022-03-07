#
# Some constant values:
#
"""URN for a `DSECollection` with all HMT project DSE records."""
DSE_URN = Cite2Urn("urn:cite2:hmt:hmtdse.v1:all")





"""URN for a `CitableCommentary` with all HMT project scholia-passage indexing."""
COMMENTARY_URN = Cite2Urn("urn:cite2:cite:datamodels.v1:commentarymodel")

"""Data model and relation set declaration for scholia-passage indexing."""
COMMENTARY_HEADER = """

#!datamodels
Collection|Model|Label|Description
$(HmtArchive.COMMENTARY_URN)|urn:cite2:hmt:commentary.v1:all|Relation of commentary to text passages commented on.

#!citerelationset
urn|urn:cite2:hmt:commentary.v1:all
label|Index of scholia to *Iliad* passages they comment on

scholion|iliad
"""

