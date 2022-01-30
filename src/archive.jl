"The HMT archive in a local file system."
struct Archive
    root::AbstractString
end

function edrepo(archive::Archive)
    repository(archive.root, dse = "dse-data", config = "textconfigs", editions = "tei-editions")
end

function adjacent()
    Archive(joinpath(pwd() |> dirname, "hmt-archive", "archive"))
end


function publish(hmt::Archive, release::AbstractString)
    @warn("Incomplete test output")
    @warn("Release ID: ", release)
    dipls = diplomaticcorpus(edrepo(hmt))
    normed = normalizedcorpus(edrepo(hmt))
    dseurn = Cite2Urn("urn:cite2:hmt:hmtdse.v1:")
    dse = DSECollection(dseurn, "HMT DSE records", dsetriples(hmt |> edrepo))
    
    join([cex(dipls), cex(normed), cex(dse)], "\n\n")
end