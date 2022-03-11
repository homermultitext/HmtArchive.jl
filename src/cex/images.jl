"""Load HMT image collections from `src`.
$(SIGNATURES)
"""
function hmt_images(src::AbstractString; delimiter = "|")
    fromcex(src, ImageCollection, delimiter = delimiter)
end

"""Load HMT image collections from current CEX release of HMT project.
$(SIGNATURES)
"""
function hmt_images()
    hmt_cex() |> hmt_images
end


"""Compose a table of image counts per image collection in `codd`.
$(SIGNATURES)
"""
function coltbl_imagecounts(imgs::Vector{ImageCollection})
    dataseries = []
    for imgc in imgs
        push!(dataseries, (collection = label(imgc), count = length(imgc)))
    end
    Tables.columntable(dataseries)
end


"""Load current release and compose a table of image counts per image collection.
$(SIGNATURES)
"""
function coltbl_imagecounts()
    hmt_codices() |> coltbl_imagecounts
end

