#!/usr/bin/env lua5.4

local stringx = require("pl.stringx")
--local inspect = require("inspect")

print("Day 13, task 1!")

local function check_pair(pair_left, pair_right)
    -- Check exist:
    if pair_left and (not pair_right)
    then
        return false

    elseif (not pair_left) and pair_right
    then
        return true
    end

    -- Check type:
    if (type(pair_left) == "table") and (type(pair_right) == "number")
    then
        pair_right = {pair_right}
    elseif (type(pair_left) == "number") and (type(pair_right) == "table")
    then
        pair_left = {pair_left}
    end

    if (type(pair_left) == "table") and (type(pair_right) == "table")
    then
        -- table:
        local len
        if #pair_left > #pair_right
        then
            len = #pair_left
        else
            len = #pair_right
        end

        for i = 1, len, 1
        do
            local ret = check_pair(pair_left[i], pair_right[i])
            if ret ~= nil
            then
                return ret
            end
        end
    else
        -- number:
        if pair_left < pair_right
        then
            return true

        elseif pair_left > pair_right
        then
            return false
        end
    end
end

local function open_file(filename)
    local pairs = {}
    local i = 1
    local is_left_pair = true
    local f = io.open(filename)
    for line in f:lines()
    do
        if line ~= ""
        then
            line = stringx.replace(line, "[", "{")
            line = stringx.replace(line, "]", "}")
            if is_left_pair
            then
                pairs[i] = {}
                pairs[i].pair_left = load("return " .. line)()
                is_left_pair = false
            else
                pairs[i].pair_right = load("return " .. line)()
                i = i + 1
                is_left_pair = true
            end
        end
    end

    f:close()

    return pairs
end

local pairs = open_file(arg[1])
--print(#pairs)
--print(inspect(pairs))

local sum = 0
for i, x in ipairs(pairs)
do
    if check_pair(x.pair_left, x.pair_right)
    then
        sum = sum + i
    end
end

print("Total sum:", sum)