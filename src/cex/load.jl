HMT_RELEASE_DIR = "https://raw.githubusercontent.com/homermultitext/hmt-archive/master/releases-cex/"
HMT_CURRENT = "https://raw.githubusercontent.com/homermultitext/hmt-archive/master/releases-cex/hmt-current.cex"


"""Download current HMT release in CEX format.
$(SIGNATURES)
"""
function hmt_cex()
    f = Downloads.download(HMT_CURRENT) 
    data = f |> read |> String
    rm(f)
    data
end


"""Download a published HMT release in CEX format, identified by its release identifier.

$(SIGNATURES)
"""
function hmt_cex(id)
    re = r"hmt-([0-9]+)[a-z]+"
    matchyear = match(re, id)
    year = matchyear.captures[1]
    release_url = string(HMT_RELEASE_DIR, year, "/", id, ".cex")


    f = Downloads.download(release_url) 
    data = f |> read |> String
    rm(f)
    data
end




function hmt_releaseinfo()
    hmt_cex() |> hmt_releaseinfo
end

"""Extract release info from library header of `cexsrc`.
$(SIGNATURES)
"""
function hmt_releaseinfo(cexsrc::AbstractString; delimiter = "|")
    libinfo = blocks(cexsrc, "citelibrary")[1]
    infoparts = split(libinfo.lines[1], delimiter) 
    infoparts[2]
end