#!/usr/bin/env lua5.4

local Set = require("Set")

print("Day 3, Task 2!")

local function open_file(filename)
    local sum = 0

    local elves_count = 1
    local sets = {Set{}, Set{}, Set{}}

    local f = io.open(filename)
    for line in f:lines()
    do
        -- Add all element to set:
        for c in line:gmatch(".")
        do
            sets[elves_count].insert(c)
        end

        elves_count = elves_count + 1

        if elves_count == 4
        then
            -- Get share element:
            local share_element
            local inter_set = sets[1].intersection(sets[2], sets[3])
            inter_set.each(function(x) share_element = x end)

            -- Chcek is upper or lower:
            local share_element_number = share_element:byte()
            if share_element_number >= 97
            then
                sum = sum + share_element_number - 96
            else
                sum = sum + share_element_number - 64 + 26
            end

            -- Reset elves_count and sets:
            elves_count = 1
            sets = {Set{}, Set{}, Set{}}
        end
    end
    f:close()

    return sum
end

local sum = open_file(arg[1])
print(sum)