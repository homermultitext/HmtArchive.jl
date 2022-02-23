"A copy of the HMT archive in a local file system."
struct Archive
    root::AbstractString
end


"""Find current version of `HmtArchive` module.
$(SIGNATURES)
"""
function currentversion()
    config = Base.current_project() |> Pkg.TOML.parsefile
    config["version"]
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
    DSECollection(HmtArchive.DSE_URN, "Homer Multitext project indexing of digital scholarly editions", dsetriples(hmt |> edrepo))
end

"""Compile a diplomatic edition of all texts in the archive.
$(SIGNATURES)
"""
function diplomaticcorpus(hmt::Archive; sourcecorpus = nothing)
    diplomaticcorpus(hmt |> edrepo, sourcecorpus = sourcecorpus)
end

"""Compile a normalized edition of all texts in the archive.
$(SIGNATURES)
"""
function normalizedcorpus(hmt::Archive; sourcecorpus = nothing)
    normalizedcorpus(hmt |> edrepo, sourcecorpus = sourcecorpus)
end

"""List *cex files in codex directory.
$(SIGNATURES)
"""
function codexfiles(hmt::Archive)
    fullpath = joinpath(hmt.root, "codices") |> readdir
    filenames = filter(f -> endswith(f, "cex"), fullpath)        
	map(fname -> joinpath(hmt.root, "codices", fname), filenames)
end

"""List *cex files in images directory.
$(SIGNATURES)
"""
function imagefiles(hmt::Archive)
    fullpath = joinpath(hmt.root, "images") |> readdir
    filenames = filter(f -> endswith(f, "cex"), fullpath)        
	map(fname -> joinpath(hmt.root, "images", fname), filenames)
end


"""List *cex files in relations directory.
$(SIGNATURES)
"""
function relationfiles(hmt::Archive)
    fullpath = joinpath(hmt.root, "relations") |> readdir
    filenames = filter(f -> endswith(f, "cex"), fullpath)        
	map(fname -> joinpath(hmt.root, "relations", fname), filenames)
end