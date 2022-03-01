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