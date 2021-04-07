# Use scratch.jl to get started.
# Mess around with tokenizing NamedEntities
using ZipFile
using Downloads

function unzip(file,exdir="")
    fileFullPath = isabspath(file) ?  file : joinpath(pwd(),file)
    basePath = dirname(fileFullPath)
    outPath = (exdir == "" ? basePath : (isabspath(exdir) ? exdir : joinpath(pwd(),exdir)))
    isdir(outPath) ? "" : mkdir(outPath)
    zarchive = ZipFile.Reader(fileFullPath)
    for f in zarchive.files
        fullFilePath = joinpath(outPath,f.name)
        if (endswith(f.name,"/") || endswith(f.name,"\\"))
            mkdir(fullFilePath)
        else
            write(fullFilePath, read(f))
        end
    end
    close(zarchive)
end


zipurl = "https://github.com/homermultitext/hmt-archive/archive/refs/heads/master.zip"
zipfile =  Downloads.download(zipurl)
unzip(zipurl)

hmt = dirname(zipfile) * "/hmt-archive-master/"
