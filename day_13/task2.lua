#!/usr/bin/env lua5.4

local stringx = require("pl.stringx")
--local inspect = require("inspect")

print("Day 13, task 2!")

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
    local f = io.open(filename)
    for line in f:lines()
    do
        if line ~= ""
        then
            line = stringx.replace(line, "[", "{")
            line = stringx.replace(line, "]", "}")
            table.insert(pairs, load("return " .. line)())
        end
    end

    f:close()

    return pairs
end

local pairs = open_file(arg[1])
local pair_a = {{2}}
local pair_b = {{6}}
table.insert(pairs, pair_a)
table.insert(pairs, pair_b)

table.sort(pairs, check_pair)
local pair_a_index
local pair_b_index
for i, pair in ipairs(pairs)
do
    if pair == pair_a
    then
        pair_a_index = i
    end

    if pair == pair_b
    then
        pair_b_index = i
    end
end

print("Answer:", pair_a_index * pair_b_index)