"Index of image regions to pages of a MS."
struct PageImageZone <: AbstractAnnotationSet
    urn::Cite2Urn
    label::AbstractString
    index::Vector{Tuple{Cite2Urn, Cite2Urn}}
end



"""Override `show` for `PageImageZone`
$(SIGNATURES)
Required for `CitableTrait`.
"""
function show(io::IO, idx::PageImageZone)
    print(io, idx.urn, " ", idx.label)
end

"""Override `==` for `PageImageZone`
$(SIGNATURES)
"""
function ==(idx1::PageImageZone, idx2::PageImageZone)
    idx1.urn.urn == idx2.urn.urn && idx1.label == idx2.label && idx1.index == idx2.index
end



"Define singleton type to use as value of `CitableTrait` on `PageImageZone`."
struct PageZones <: CitableTrait end
"""Set value of `CitableTrait` for `PageImageZone`.
$(SIGNATURES)
"""
function citabletrait(::Type{PageZones})
    PageImageZone()
end



"""Type of URN identifying `idx`.
$(SIGNATURES)
Required function for `Citable` abstraction.
"""
function urntype(idx::PageImageZone)
    Cite2Urn
end


"""URN identifying `idx`.
$(SIGNATURES)
Required function for `Citable` abstraction.
"""
function urn(idx::PageImageZone)
    idx.urn
end

"""Label for `idx`.
$(SIGNATURES)
Required function for `Citable` abstraction.
"""
function label(idx::PageImageZone)
    idx.label
end



"Singleton type for value of `CexTrait`"
struct PageImageZoneCex <: CexTrait end
"""Set value of `CexTrait` for `PageImageZone`
$(SIGNATURES)
"""
function cextrait(::Type{PageImageZone})
    PageImageZoneCex()
end




"""Format a `PageImageZone` as a delimited-text string.
$(SIGNATURES)
Required function for `Citable` abstraction.
"""
function cex(idx::PageImageZone; delimiter = "|")
    lines = ["#!citerelationset",
        "urn$(delimiter)$(urn(idx))",
        "label$(delimiter)$(label(idx))",
        "",
        "passage$(delimiter)person"
    ]
    for pr in idx.index
        push!(lines, string(pr[1]) * delimiter * string(pr[2]))
    end
    join(lines, "\n")
end





"""Parse a delimited-text string into a (possibly empty) list of `PageImageZone`s.
$(SIGNATURES)
"""
function fromcex(trait::PageImageZoneCex, cexsrc::AbstractString, ::Type{PageImageZone}; 
    delimiter = "|", configuration = nothing, strict = true)

    indexsets = []
    modelblocks = blocks(cexsrc, "datamodels")
    for mb in modelblocks
        for ln in mb.lines[2:end]
            cols = split(ln, delimiter)
            collurn =  Cite2Urn(cols[1])
            modelurn = Cite2Urn(cols[2])
            if modelurn == HmtArchive.PAGE_IMAGE_ZONE_MODEL
                push!(indexsets,collurn)
            else
                @debug("$(modelurn) != $(HmtArchive.PAGE_IMAGE_ZONE_MODEL)")
            end
        end
    end

    crblocks = blocks(cexsrc, "citerelationset")
    indexblocks = []
    crurns = map(crblocks) do blk
        split(blk.lines[1], delimiter)[2] |> Cite2Urn
    end
    for commseturn in indexsets
        blockindices = findall(u -> u == commseturn, crurns)
        for idx in blockindices
            push!(indexblocks, crblocks[idx])
        end
    end
    

    indices = []
    for blk in indexblocks
        datapairs = []
        (coll_urn, coll_label) = CitableAnnotations.headerinfo(blk, delimiter = delimiter)
        for ln in blk.lines
            columns = split(ln, delimiter)
            try
                push!(datapairs, (Cite2Urn(columns[1]), Cite2Urn(columns[2]))) 
            catch 
                @warn("Skipping line $(ln)")
            end
        end

        push!(indices, PageImageZone(coll_urn, coll_label, datapairs))
    end
    indices
end


