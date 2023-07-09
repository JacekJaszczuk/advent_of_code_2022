#!/usr/bin/env lua5.4

print("Day 10, task 1!")

local x = 1
local stack = {}

local function noop()
    table.insert(stack, 0)
end

local function addx(num)
    table.insert(stack, 0)
    table.insert(stack, num)
end

local function open_file(filename)
    local f = io.open(filename)
    for line in f:lines()
    do
        if line == "noop"
        then
            noop()
        else
            local num = tonumber(line:sub(6))
            addx(num)
        end
    end
    f:close()
end

local signal_strength_cycle = {
    [20]  = true,
    [60]  = true,
    [100] = true,
    [140] = true,
    [180] = true,
    [220] = true,
}

local function run_stack()
    local signal_strength = 0
    for i, value in ipairs(stack)
    do
        if signal_strength_cycle[i]
        then
            signal_strength = signal_strength + (i*x)
        end

        x = x + value
    end

    return signal_strength
end

open_file(arg[1])
local signal_strength = run_stack()
print("Signal strength:", signal_strength)