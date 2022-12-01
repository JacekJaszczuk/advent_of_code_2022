#!/usr/bin/env lua5.4

local inspect = require("inspect")

local calories_list = {0}
local calories_list_ptr = 1

local function open_file(filename)
    local f = io.open(filename)
    for line in f:lines()
    do
        --print(line)
        if line == ""
        then
            calories_list_ptr = calories_list_ptr + 1
            calories_list[calories_list_ptr] = 0
        else
            calories_list[calories_list_ptr] = calories_list[calories_list_ptr] + tonumber(line)
        end
    end
    f:close()
end

print("Task 1!")

open_file(arg[1])

table.sort(calories_list)
print(inspect(calories_list))
print(calories_list[#calories_list])
