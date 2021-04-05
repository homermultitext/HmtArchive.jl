"""Abbreviated URN for HMT named entity.

$(SIGNATURES)
"""
struct HmtAbbreviation <: AbbreviatedUrn
    collection::AbstractString
    objectid::AbstractString
    HmtAbbreviation(s) = begin
        parts = split(s,".")
        if length(parts) == 2
            new(parts[1], parts[2])
        else
            throw(ArgumentError("HmtAbbreviation: invalid syntax: $(s)"))
        end
    end
end


"""Create dictionary mapping abbreviated collection names to full Cite2Urns.

$(SIGNATURES)
"""
function neregistry()
    Dict(
        "pers" => "urn:cite2:hmt:pers.v1:",
        "place" => "urn:cite2:hmt:place.v1:"
    )
end


"""Expand abbreviated URN string to full Cite2Urn using `neregistry`.

$(SIGNATURES)
"""
function expandabbr(s::AbstractString)
    tidy = replace(s, "abbr:" => "")
    expand(HmtAbbreviation(tidy), neregistry())
end

"""Expand abbreviated URN to full Cite2Urn using `neregistry`.

$(SIGNATURES)
"""
function expandabbr(abbr::HmtAbbreviation)
    registry = neregistry()
    expand(abbr, registry)
end


