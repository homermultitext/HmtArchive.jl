"""For each element in `scsreff`, stitch together a triplet containing a passage reference,
a `CitablePassage` or `nothing`, and a score from the `plusminus` function.
`psgs` and `plusminusscores` will be equal in length, and will be <= the length of the supersequence `scsreff`.
$(SIGNATURES)

## Arguments

- `scsreff` is the shortest common supersequence of passage references (the passage component of a CtsUrn) for a selection of passages.
- `psgs` is a list of text passages with passage references belonging to the supersequence `scsreff`.
- `plusminusscores` is a list of scores from the `plusminus` function comparing the each in `psgs` to a reference version of the same work.
"""
function stitch(scsreff::Vector{AbstractString}, psgs::Vector{CitablePassage}, plusminusscores::Vector{Symbol})  
    stitched = NamedTuple{(:ref, :score, :passage), Tuple{AbstractString, Symbol, Union{CitablePassage, Nothing}}}[]

    txtindex = 1
    for (i, ref) in enumerate(scsreff)
        if i > length(psgs)
            push!(stitched, (ref = ref, score = :minus, passage = nothing))

        else
            score = plusminusscores[i]
            psgref = passagecomponent(urn(psgs[txtindex]))
            if psgref == ref
                push!(stitched, (ref = ref, score = score, passage = psgs[txtindex]))
                txtindex = txtindex + 1
            
            else
                push!(stitched, (ref = ref, score = score, passage = nothing))
            end
        end
    end
    stitched
end



"""Compute vertical difference
$(SIGNATURES)
"""
function vertical(u::CtsUrn, corpus::CitableTextCorpus; exemplar = "normalized")
    allcontained = filter(psg -> urncontains(u, urn(psg)), corpus.passages)
    by_exemplar = filter(p -> exemplarid(urn(p)) == exemplar, allcontained)

    sigla = map(p -> versionid(urn(p)), by_exemplar) |> unique
    psgreff = Vector{AbstractString}[]
    docs = Vector{CitablePassage}[]
    for s in sigla
        doc = filter(p -> versionid(urn(p)) == s, by_exemplar)
        push!(docs, doc)
        push!(psgreff, map(p -> urn(p) |> passagecomponent,  doc))
    end
 
    refversion = psgreff[1]
    mashup = scs_all(refversion, psgreff[2:end])
    refindexing = []
    for psg in psgreff
        push!(refindexing, scsindex(psg, mashup))
    end
    plusminusscores = Vector{Symbol}[]
    for idx in refindexing
        push!(plusminusscores, plusminus(refindexing[1], idx)[2])
    end

    results = []
    for (i,doc) in enumerate(docs)
        push!(results, stitch(mashup, doc, plusminusscores[i]))
    end
    results
end