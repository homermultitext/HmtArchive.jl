# https://www.techiedelight.com/shortest-common-supersequence-introduction-scs-length/


function hack()
    "File included"
end

function weslcs()
end
# https://github.com/WestleyArgentum/Subsequences.jl/blob/master/src/Subsequences.jl

function weslcs(a, b; result_base = "", join_fn = string)
    weslcs(a, b, result_base, join_fn)
end

function weslcs(a, b, result_base, join_fn)
    lengths = zeros(length(a) + 1, length(b) + 1)

    for i in 1:length(a)
        ai = a[i]
        for j in 1:length(b)
            if ai == b[j]
                lengths[i+1, j+1] = lengths[i, j] + 1
            else
                lengths[i+1, j+1] = max(lengths[i+1, j], lengths[i, j+1])
            end
        end
    end

    x, y = length(a) + 1, length(b) + 1
    result = result_base
    a_start, a_end = 0, 0
    b_start, b_end = 0, 0

    while x != 1 && y != 1
        if lengths[x, y] == lengths[x-1, y]
            x -= 1
        elseif lengths[x, y] == lengths[x, y-1]
            y -= 1
        else
            result = join_fn(a[x-1], result)

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

    result, a_start:a_end, b_start:b_end
end

#=
function memoize2(a,b)
    lengths = zeros(length(a) + 1, length(b) + 1)

    for i in 1:length(a)
        ai = a[i]
        for j in 1:length(b)
            if ai == b[j]
                lengths[i+1, j+1] = lengths[i, j] + 1
            else
                lengths[i+1, j+1] = max(lengths[i+1, j], lengths[i, j+1])
            end
        end
    end
    lengths
end
=#


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



"""Longest common subsequence mocking my scala scs
"""
function badlcs(a,b)
    memo = memoize(a,b)
    common = []
    idx1 = 1
    idx2 = 1
    while idx1 <= length(a) && idx2 <= length(b)
        @info("Compare a/b", a[idx1], b[idx2])
        @info("at a/b", idx1, idx2)
        if a[idx1] == b[idx2] 
            @debug("Push", a[idx1])
            push!(common, a[idx1])
            idx1 = idx1 + 1
            idx2 = idx2 + 1
        else
            @info("a,b differed at a/b", idx1, idx2)
            @info("a/b", a[idx1], b[idx2])
            @info("with lengths",length(a), length(b))
            if memo[idx1 + 1, idx2] > memo[idx1, idx2 + 1] 
                @info("Advancing a to $(idx1 + 1)")
                idx1 = idx1 + 1
            else
                @info("Advancing b to $(idx2 + 1)") 
                idx2 = idx2 + 1
            end
        end
    end
    common
end