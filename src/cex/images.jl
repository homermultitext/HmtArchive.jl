#using CitableBase
#using CitableImage

function hmt_images(src::AbstractString; delimiter = "|")
    fromcex(src, ImageCollection, delimiter = delimiter)
end


function hmt_images()
    hmt_cex |> hmt_images
end
