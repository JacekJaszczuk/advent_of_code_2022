#!/usr/bin/env lua5.4

local Set = require("Set")

print("Day 3, Task 1!")

local function open_file(filename)
    local sum = 0

    local f = io.open(filename)
    for line in f:lines()
    do
        local first = line:sub(1, #line/2)
        local second = line:sub(#line/2+1, #line)

        -- Add all first to set:
        local first_set = Set({})
        for c in first:gmatch(".")
        do
            first_set.insert(c)
        end

        -- Add all second to set:
        local second_set = Set({})
        for c in second:gmatch(".")
        do
            second_set.insert(c)
        end

        -- Get share element:
        local share_element
        local inter_set = first_set.intersection(second_set)
        inter_set.each(function(x) share_element = x end)

        -- Chcek is upper or lower:
        local share_element_number = share_element:byte()
        if share_element_number >= 97
        then
            sum = sum + share_element_number - 96
        else
            sum = sum + share_element_number - 64 + 26
        end
    end
    f:close()

    return sum
end

local sum = open_file(arg[1])
print(sum)