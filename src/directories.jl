
"Directory with archival XML of Iliad."
function scholiadir(archive::Archive)
    archive.root *  "/archive/scholia/"
end

"Directory with archival XML of scholia."
function iliaddir(archive::Archive)
    archive.root  *  "/archive/iliad/"
end
