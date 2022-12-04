#!/usr/bin/env lua5.4

print("Day 4, task 2!")

local function check_contains(s1, e1, s2, e2)
    if ((s1 >= s2) and (s1 <= e2)) or ((e1 >= s2) and (e1 <= e2))
    then
        return true
    else
        return false
    end
end

local function open_file(filename)
    local f = io.open(filename)

    local sum = 0

    for line in f:lines()
    do
        local first_start, first_end, second_start, second_end = line:match("(%d+)-(%d+),(%d+)-(%d+)")
        first_start = tonumber(first_start)
        first_end = tonumber(first_end)
        second_start = tonumber(second_start)
        second_end = tonumber(second_end)

        if check_contains(first_start, first_end, second_start, second_end) or
           check_contains(second_start, second_end, first_start, first_end)
        then
            sum = sum + 1
        end
    end

    f:close()

    return sum
end

local sum = open_file(arg[1])
print(sum)