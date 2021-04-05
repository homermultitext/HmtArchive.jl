
"""Copied from https://github.com/sylvaticus/LAJuliaUtils.jl
"""
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

"""Make a copy of the current master branch of the archive in the local file system.
"""
function localcopy()
    zipurl = "https://github.com/homermultitext/hmt-archive/archive/refs/heads/master.zip"
    @info "Beginning download..."
    zipfile =  Downloads.download(zipurl)
    hmt = dirname(zipfile) * "/hmt-archive-master/"
    if isdir(hmt)
        @warn "Cowardly refusing to overwrite existing directory $hmt"
    else 
        unzip(zipurl)
    end
    Archive(hmt)
end
