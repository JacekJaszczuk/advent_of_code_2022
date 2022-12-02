#!/usr/bin/env lua5.4

local sum = 0

local function open_file(filename)
    local f = io.open(filename)
    for line in f:lines()
    do
        --print(line)
        local opponent = line:sub(1,1)
        local elf = line:sub(3,3)

        -- Rock:
        if opponent == "A"
        then
            if elf == "X"
            then
                -- Loss + Scissors
                sum = sum + 0 + 3
            elseif elf == "Y"
            then
                -- Draw + Rock
                sum = sum + 3 + 1
            elseif elf == "Z"
            then
                -- Win + Paper
                sum = sum + 6 + 2
            end
        end

        -- Paper:
        if opponent == "B"
        then
            if elf == "X"
            then
                -- Loss + Rock
                sum = sum + 0 + 1
            elseif elf == "Y"
            then
                -- Draw + Paper
                sum = sum + 3 + 2
            elseif elf == "Z"
            then
                -- Win + Scissors
                sum = sum + 6 + 3
            end
        end

        -- Scissors:
        if opponent == "C"
        then
            if elf == "X"
            then
                -- Loss + Paper
                sum = sum + 0 + 2
            elseif elf == "Y"
            then
                -- Draw + Scissors
                sum = sum + 3 + 3
            elseif elf == "Z"
            then
                -- Win + Rock
                sum = sum + 6 + 1
            end
        end
    end
    f:close()
end

print("Day 2, task 2!")

open_file(arg[1])
print(sum)