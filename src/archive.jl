"A copy of the HMT archive in a local file system."
struct Archive
    root::AbstractString
end


"""Instantiate an `EditingRepository` from `archive`.
$(SIGNATURES)
"""
function edrepo(archive::Archive)
    repository(archive.root, dse = "dse-data", config = "textconfigs", editions = "tei-editions")
end


"""Short-cut for instantiating an `Archive` from a clone or download of
https://github.com/homermultitext/hmt-archive in an adjacent directory to 
where you are working.
$(SIGNATURES)
"""
function adjacent()
    Archive(joinpath(pwd() |> dirname, "hmt-archive", "archive"))
end

"""Instantiate a `DSECollection` with all DSE records in the archive.
$(SIGNATURES)
"""
function dse(hmt::Archive)
    dse = DSECollection(HmtArchive.DSE_URN, "Homer Multitext project indexing of digital scholarly editions", dsetriples(hmt |> edrepo))
end

"""Compile a diplomatic edition of all texts in the archive.
$(SIGNATURES)
"""
function diplomaticcorpus(hmt::Archive)
    diplomaticcorpus(hmt |> edrepo)
end

"""Compile a normalized edition of all texts in the archive.
$(SIGNATURES)
"""
function normalizedcorpus(hmt::Archive)
    normalizedcorpus(hmt |> edrepo)
end

"""List *cex files in codex directory.
$(SIGNATURES)
"""
function codexfiles(hmt::Archive)
    fullpath = joinpath(hmt.root, "codices") |> readdir
    filenames = filter(f -> endswith(f, "cex"), fullpath)        
	filenames
end

"""List *cex files in images directory.
$(SIGNATURES)
"""
function imagefiles(hmt::Archive)
    fullpath = joinpath(hmt.root, "images") |> readdir
    filenames = filter(f -> endswith(f, "cex"), fullpath)        
	filenames
end