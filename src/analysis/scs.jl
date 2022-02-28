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

function lcs(a,b)
    memo = memoize(a,b)
    common = []
    idx1 = 1
    idx2 = 1
    while idx1 <= length(a) && idx2 <= length(b)
        @debug("Compare a/b", a[idx1], b[idx2])
        if a[idx1] == b[idx2] 
            @debug("Push", a[idx1])
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


# DEBUG THIS
function cf(v1, v2)
    mashup = scs(v1, v2)
    v1index = scsindex(v1, mashup)
    v2index = scsindex(v2, mashup) # Indexing error here!
    plusminus(v1index, v2index)
end