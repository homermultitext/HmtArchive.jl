#
# Some constant values:
#
"""URN for a `DSECollection` with all HMT project DSE records."""
DSE_URN = Cite2Urn("urn:cite2:hmt:hmtdse.v1:all")


DSE_HEADER = """

#!datamodels
Collection|Model|Label|Description
$(HmtArchive.DSE_URN)|urn:cite2:cite:datamodels.v1:dsemodel|Relations of text, manuscript page and documentary image for all edited texts.
"""
