#=
using Memoize

"""Find shortest common supersequence of `x` and `y`.
$(SIGNATURES)
Taken from Rosetta Code solution to SCS at https://rosettacode.org/wiki/Shortest_common_supersequence#Julia but generalized to work 
with Vectors of any `eltype` rather than just Strings.
"""
@memoize function scs(x, y)
    if isempty(x)
        return y
    elseif isempty(y)
        return x
    elseif x[1] == y[1]
        return append!([x[1]], scs(x[2:end], y[2:end]))
    elseif length(scs(x, y[2:end])) <= length(scs(x[2:end], y))
        return append!([y[1]], scs(x, y[2:end]))
    else
        return append!([x[1]], scs(x[2:end], y))
    end
end
=#
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

function lcs(a,b)
    memo = memoize(a,b)
    common = []
    idx1 = 1
    idx2 = 1
    while idx1 <= length(a) && idx2 <= length(b)
        @info("Compare a/b", a[idx1], b[idx2])
        if a[idx1] == b[idx2] 
            @info("Push", a[idx1])
            push!(common, a[idx1])
            idx1 = idx1 + 1
            idx2 = idx2 + 1
        else 
          if memo[idx2 + 1, idx2] >= memo[idx1, idx2 + 1] 
            idx1 = idx1 + 1
          else 
            idx2 = idx2 + 1
          end
        end
    end
    common
end


function scs(a,b)
    overlap = lcs(a,b)
    max = length(overlap) + (length(a) - length(overlap)) + (length(b) - length(overlap))
    println("Build SCS length $(max) from scs $(overlap)")

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
            @info("Pushing $(a[aidx]) with a/b/scs", aidx, bidx, scsidx)
            push!(mashup, a[aidx])
            aidx = aidx + 1
            bidx = bidx + 1
            scsidx = scsidx + 1
        else
            # Otherwise, add missing element
            if a[aidx] == overlap[scsidx]
                @info("Pushing $(b[bidx]) with a/b/scs", aidx, bidx, scsidx)
                push!(mashup, b[bidx])
                bidx = bidx + 1
            else
                @info("Pushing $(a[aidx]) with a/b/scs", aidx, bidx, scsidx)
                push!(mashup, a[aidx])
                aidx = aidx + 1
            end
        end
    end
    mashup
end
