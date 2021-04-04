
"Directory with archival XML source for Iliad editions."
function scholiadir(archive::Archive)
    archive.root *  "/archive/scholia/"
end

"Directory with archival XML for scholia editions."
function iliaddir(archive::Archive)
    archive.root  *  "/archive/iliad/"
end
