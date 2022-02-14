# Some constant values:

"""URN for a `DSECollection` with all HMT project DSE records."""
DSE_URN = Cite2Urn("urn:cite2:hmt:hmtdse.v1:")


"""Template string for CEX library header"""
CEX_HEADER_SOURCE = """
// Metadata for the current release

#!cexversion
3.0.1

#!citelibrary
// These values are inserted programmtacally when
// the CITE library is built:
name|Homer Multitext project, release RELEASE_ID
urn|urn:cite2:hmt:publications.cex.RELEASE_ID:all
license|Creative Commons Attribution, Non-Commercial 4.0 License <https://creat\
ivecommons.org/licenses/by-nc/4.0/>.

// CITE namespace definitions
namespace|hmt|http://www.homermultitext.org/citens/hmt
namespace|greekLit|http://chs.harvard.edu/ctsns/greekLit
"""