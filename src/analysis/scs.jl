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

