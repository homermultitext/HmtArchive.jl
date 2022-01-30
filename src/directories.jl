
"""Find directory with archival XML source for *scholia* editions.

$(SIGNATURES)
"""
function scholiadir(archive::Archive)
    joinpath(archive.root,  "archive", "scholia/")
end

"""Directory with archival XML for *Iliad* editions.

$(SIGNATURES)
"""
function iliaddir(archive::Archive)
    joinpath(archive.root,  "archive", "iliad/")
end
