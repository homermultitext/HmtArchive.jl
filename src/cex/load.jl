HMT_CURRENT = "https://raw.githubusercontent.com/homermultitext/hmt-archive/master/releases-cex/hmt-current.cex"


"""Download current HMT release in CEX format.
$(SIGNATURES)
"""
function hmt_cex()
    Downloads.download(HMT_CURRENT) |> read |> String
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