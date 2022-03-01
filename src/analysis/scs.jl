#using CitableBase
#using CitableText

# Document these.
# Based on my scala lcs-scs package.
#

function memoize(a,b) 
    lengths = zeros(Int, length(a) + 1, length(b) + 1)
 
    # row 0 and column 0 are initialized to 0 already
    for (i, x) in enumerate(a), (j, y) in enumerate(b)
        if x == y
            lengths[i+1, j+1] = lengths[i, j] + 1
        else
            lengths[i+1, j+1] = max(lengths[i+1, j], lengths[i, j+1])
        end
    end
    lengths
end



function lcs(a, b)
    lengths = memoize(a,b)
    result = []
    x, y = length(a) + 1, length(b) + 1
 
    a_start, a_end = 0, 0
    b_start, b_end = 0, 0

    while x != 1 && y != 1
        if lengths[x, y] == lengths[x-1, y]
            x -= 1
        elseif lengths[x, y] == lengths[x, y-1]
            y -= 1
        else
            #result = join_fn(a[x-1], result)
            push!(result, a[x-1])

            a_start = x - 1
            b_start = y - 1

            if (a_end == 0)
                a_end = x - 1
                b_end = y - 1
            end

            x -= 1
            y -= 1
        end
    end

    reverse(result)#, a_start:a_end, b_start:b_end
end




"""Shortest common supersequence.
"""
function scs(a,b)
    overlap = lcs(a,b)
    max = length(overlap) + (length(a) - length(overlap)) + (length(b) - length(overlap))
    @debug("Build SCS length $(max) from scs $(overlap)")

    mashup = []
    scsidx  = 1
    aidx = 1
    bidx = 1
    for i in 1:max
        # Add common element if in both vectors
        if aidx > length(a)
            push!(mashup, b[bidx])
            bidx = bidx + 1
        elseif bidx > length(b)
            push!(mashup, a[aidx])
            aidx = aidx + 1
        elseif a[aidx] == b[bidx]
            @debug("Pushing $(a[aidx]) with a/b/scs", aidx, bidx, scsidx)
            push!(mashup, a[aidx])
            aidx = aidx + 1
            bidx = bidx + 1
            scsidx = scsidx + 1
        else
            @debug("Check common at a/b/scs", join(mashup,":"), aidx, bidx, scsidx)
            # Otherwise, add missing element
            if a[aidx] == overlap[scsidx]
                @debug("Pushing $(b[bidx]) with a/b/scs", aidx, bidx, scsidx)
                push!(mashup, b[bidx])
                bidx = bidx + 1
            else
                @debug("Pushing $(a[aidx]) with a/b/scs", aidx, bidx, scsidx)
                push!(mashup, a[aidx])
                aidx = aidx + 1
            end
        end
    end
    mashup
end

"""Index value in `v` of each element in `superv`, a supersequence of `v`.
"""
function scsindex(v, superv)
    indices = []
    vidx = 1
    for idx in 1:length(superv)
        @debug("Cf v/scs", v[vidx], superv[idx])
        if vidx > length(v)
            push!(indices, 0)
        elseif superv[idx] == v[vidx]
            push!(indices, vidx)
            vidx = vidx + 1
        else
            push!(indices, 0)
        end
    end
    indices
end

"""Interpret indexing position recorded in each element 
of `v1` and `v2` as same, plus or minus with respect to
their supersequence.
"""
function plusminus(v1, v2)
    v1scores = []
    v2scores = []
    for i in 1:length(v1)
        if v1[i] == 0 
            push!(v1scores, :minus)
            push!(v2scores, :plus)
        else
            push!(v1scores, :same)
            if (v2[i] == 0)
                push!(v2scores, :minus)
            else
                push!(v2scores, :same)
            end
        end
    end
    (v1scores, v2scores)
end



"""Translate a pair of SCS indexes as plus/minus/same scores.
`v1` is the reference vector: plus will be scored relative to `v1`
"""
function cf(v1, v2)
    mashup = scs(v1, v2)
    v1index = scsindex(v1, mashup)
    v2index = scsindex(v2, mashup) # Indexing error here!
    plusminus(v1index, v2index)
end


function scsall(ref, v)
    if length(v) == 1
        scs(ref, v[1])
    else
        mashup = scs(ref, v[1])
        scsall(mashup, v[2:end])
    end

end

function vertical(u::CtsUrn, corpus::CitableTextCorpus; exemplar = "normalized")
    allcontained = filter(psg -> urncontains(u, urn(psg)), corpus.passages)
    by_exemplar = filter(p -> exemplarid(urn(p)) == exemplar, allcontained)


    sigla = map(p -> versionid(urn(p)), by_exemplar) |> unique
    psgreff = []
    for s in sigla
        doc = filter(p -> versionid(urn(p)) == s, by_exemplar)
        push!(psgreff, map(p -> urn(p) |> passagecomponent,  doc))
    end
    

    refversion = psgreff[1]
    mashup = scsall(refversion, psgreff[2:end])
    refindexing = []
    for psg in psgreff
        push!(refindexing, scsindex(psg, mashup))
    end
    plusminusscores = []
    for idx in refindexing
        push!(plusminusscores, plusminus(refindexing[1], idx))
    end
    plusminusscores

    # Now join plusminusscores with reference
end