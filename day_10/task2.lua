#!/usr/bin/env lua5.4

print("Day 10, task 1!")

local x = 1
local x_sprite = {
    [0] = true,
    [1] = true,
    [2] = true,
}
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

local function run_stack()
    local crt_screen = {}
    local row = ""
    for i, value in ipairs(stack)
    do
        if x_sprite[(i-1)%40]
        then
            row = row .. "#"
        else
            row = row .. "."
        end

        x = x + value
        x_sprite = {
            [x-1] = true,
            [x]   = true,
            [x+1] = true,
        }

        if (i-1)%40 == 39
        then
            table.insert(crt_screen, row)
            row = ""
        end
    end

    return crt_screen
end

open_file(arg[1])
local crt_screen = run_stack()

for i = 1, 6, 1
do
    print(crt_screen[i])
end