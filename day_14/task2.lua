#!/usr/bin/env lua5.4
print("Day 14, task 1!")

local array2d = require("pl.array2d")

local function add_stone(matrix, vertex_left, vertex_right)
    if vertex_left.x > vertex_right.x
    then
        local y = vertex_left.y
        for j = vertex_left.x, vertex_right.x, -1
        do
            matrix[y][j] = "#"
        end
    elseif vertex_left.x < vertex_right.x
    then
        local y = vertex_left.y
        for j = vertex_left.x, vertex_right.x, 1
        do
            matrix[y][j] = "#"
        end
    end

    if vertex_left.y > vertex_right.y
    then
        local x = vertex_left.x
        for j = vertex_left.y, vertex_right.y, -1
        do
            matrix[j][x] = "#"
        end
    elseif vertex_left.y < vertex_right.y
    then
        local x = vertex_left.x
        for j = vertex_left.y, vertex_right.y, 1
        do
            matrix[j][x] = "#"
        end
    end
end

local function open_file(filename, matrix)
    local max_y = 0
    local f = io.open(filename)
    for line in f:lines()
    do
        local vertex_list = {}
        for x,y in line:gmatch("(%d+),(%d+)")
        do
            x = tonumber(x)
            y = tonumber(y)
            table.insert(vertex_list, {x = x, y = y})
            if max_y < y
            then
                max_y = y
            end
        end

        for i = 1, #vertex_list-1, 1
        do
            local vertex_left  = vertex_list[i]
            local vertex_right = vertex_list[i+1]
            add_stone(matrix, vertex_left, vertex_right)
        end
    end
    f:close()

    -- Add last floor:
    max_y = max_y + 2
    add_stone(matrix, {x = 1, y = max_y}, {x = 1000, y = max_y})
end

local function put_sand(matrix)
    local move_list = {
        {x =  0, y = 1},
        {x = -1, y = 1},
        {x =  1, y = 1},
    }

    local sand = {
        x = 500,
        y = 0,
    }

    while sand.y < 1000 do
        local move_ok = false

        for _, move in ipairs(move_list)
        do
            if matrix[sand.y+move.y][sand.x+move.x] == "."
            then
                sand.y = sand.y + move.y
                sand.x = sand.x + move.x
                move_ok = true
                break
            end
        end

        if not move_ok
        then
            -- If sand return to source, we finsh:
            if sand.y == 0
            then
                return false
            end

            matrix[sand.y][sand.x] = "o"
            return true
        end
    end

    return false
end

local matrix = array2d.new(1000, 1000, ".")
open_file(arg[1], matrix)
array2d.write(matrix, io.stdout, "%s", 1, 490, 20, 510)

local sum_of_sand = 0
while put_sand(matrix) do
    sum_of_sand = sum_of_sand + 1
end

-- Add source sand:
sum_of_sand = sum_of_sand + 1

print("Sum of sand:", sum_of_sand)