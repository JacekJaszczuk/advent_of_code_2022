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
                -- Rock + Draw:
                sum = sum + 1 + 3
            elseif elf == "Y"
            then
                -- Paper + Win
                sum = sum + 2 + 6
            elseif elf == "Z"
            then
                -- Scissors + Loss
                sum = sum + 3 + 0
            end
        end

        -- Paper:
        if opponent == "B"
        then
            if elf == "X"
            then
                -- Rock + Loss:
                sum = sum + 1 + 0
            elseif elf == "Y"
            then
                -- Paper + Draw
                sum = sum + 2 + 3
            elseif elf == "Z"
            then
                -- Scissors + Win
                sum = sum + 3 + 6
            end
        end

        -- Scissors:
        if opponent == "C"
        then
            if elf == "X"
            then
                -- Rock + Win:
                sum = sum + 1 + 6
            elseif elf == "Y"
            then
                -- Paper + Loss
                sum = sum + 2 + 0
            elseif elf == "Z"
            then
                -- Scissors + Draw
                sum = sum + 3 + 3
            end
        end
    end
    f:close()
end

print("Day 2, task 1!")

open_file(arg[1])
print(sum)