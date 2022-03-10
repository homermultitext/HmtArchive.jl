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

