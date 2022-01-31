"""Format contents of `hmt` as delimited-text in CEX format.
$(SIGNATURES)
"""
function publish(hmt::Archive, release::AbstractString)
    @warn("Incomplete test output")
    @warn("Release ID: ", release)
    dipls = diplomaticcorpus(hmt)
    normed = normalizedcorpus(hmt)
        
    join([
        cex(dipls), 
        cex(normed), 
        cex(dse),
        codexcex(hmt)
        ], "\n\n")
end

"""Read all pre-formatted CEX data for codices
into a single CEX string.
$(SIGNATURES)
"""
function codexcex(hmt::Archive)
    composite = []
    for f in codexfiles(hmt)
        push!(composite, read(f, String))
    end
    join(composite, "\n\n")
end