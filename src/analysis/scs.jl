"""Memoize lengths of sequences of common elements between two  vectors `a` and `b`.
$(SIGNATURES)
"""
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


"""Find longest common subsequence of two vectors `a` and `b` with any `eltype`.
$(SIGNATURES)
This is a lightly modified version of the `lcs` function from:
https://github.com/WestleyArgentum/Subsequences.jl/blob/master/src/Subsequences.jl
"""
function lcs(a, b)
    result = []
    lengths = memoize(a, b)
    # Walk back through the memoization table:
    x = length(a) + 1
    y = length(b) + 1
    while x != 1 && y != 1
        if lengths[x, y] == lengths[x - 1, y]
            x -= 1
        elseif lengths[x, y] == lengths[x, y-1]
            y -= 1
        else
            push!(result, a[x-1])
            x -= 1
            y -= 1
        end
    end

    reverse(result)
end

"""Find shortest common supersequence of two vectors `a` and `b`
by comparing them to their `lcs` and appropirately inserting 
values not in the `lcs` into the result.
$(SIGNATURES)
"""
function scs(a,b)
    overlap = lcs(a,b)
    # `max`` will be the resulting length of `scsmashup`
    max = length(overlap) + (length(a) - length(overlap)) + (length(b) - length(overlap))
    scsmashup = AbstractString[]
    scsidx  = 1
    aidx = 1
    bidx = 1
    for i in 1:max
        
        if aidx > length(a)
            # We've run out of `a`, so keep adding `b`
            push!(scsmashup, b[bidx])
            bidx = bidx + 1
        elseif bidx > length(b)
            # We've run out of `b`, so keep adding `a`
            push!(scsmashup, a[aidx])
            aidx = aidx + 1
        elseif a[aidx] == b[bidx]
            # Add common element if in both vectors
            push!(scsmashup, a[aidx])
            aidx = aidx + 1
            bidx = bidx + 1
            scsidx = scsidx + 1
        else
            # Otherwise, add missing element
            if a[aidx] == overlap[scsidx]
                push!(scsmashup, b[bidx])
                bidx = bidx + 1
            else
                push!(scsmashup, a[aidx])
                aidx = aidx + 1
            end
        end
    end
    scsmashup
end

"""For each element in `superv`, a supersequence of `v`, record
the index of that element in vector `v`, or 0 if it is absent from `v`.
$(SIGNATURES)
"""
function scsindex(v, superv)
    indices = []
    vidx = 1
    for idx in 1:length(superv)
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

"""Interpret the indexing position recorded in each element 
of `index1` and `index2` as `:same`, `:plus` or `:minus`, using  `index1` 
as the "reference" index.

$(SIGNATURES)
`index1` and `index2` should be vectors of equal length recording the
index value of an element with respect to a shared supersequence.  That is,
`index1` and `index2` should be the output of `scsindex` for two vectors
having a common supersequence.

## Scoring method

For a given element, if the reference index `index1` has a non-zero value, it will be scored as `:same`; the value for `index2` will be either `:same` or `:minus`.

If `index1` has a value of 0, it will be scored as `:minus`; `index2` will be scored as either `:plus` (non-zero value) or `:same` (0).

"""
function plusminus(index1, index2)
    v1scores = []
    v2scores = []
    for i in 1:length(index1)
        if index1[i] == 0 
            push!(v1scores, :minus)
            push!(v2scores, :plus)
        else
            push!(v1scores, :same)
            if (index2[i] == 0)
                push!(v2scores, :minus)
            else
                push!(v2scores, :same)
            end
        end
    end
    (v1scores, v2scores)
end

"""Find the shortest common supersequence of a Vector `ref`
and a Vector of Vectors `v` by recursively computing SCS for the
first Vector in `v` with the SCS of the remaining vectors in `v`.
$(SIGNATURES)
"""
function scs_all(ref, v)
    if length(v) == 1
        scs(ref, v[1])
    else
        mashup = scs(ref, v[1])
        scs_all(mashup, v[2:end])
    end
end

