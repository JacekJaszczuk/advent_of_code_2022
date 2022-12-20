#!/usr/bin/env lua5.4

local inspect = require("inspect")

local function open_file(filename)
    local tree_matrix = {}
    local tree_bool_matrix = {}

    local f = io.open(filename)
    for line in f:lines()
    do
        table.insert(tree_matrix, {})
        for x in line:gmatch(".")
        do
            x = tonumber(x)
            table.insert(tree_matrix[#tree_matrix], x)
        end
    end
    f:close()

    return (tree_matrix)
end

local function check_up_visable(tree_matrix, i, j)
    local value = tree_matrix[i][j]
    for x = 1, i-1, 1
    do
        local check_tree_value = tree_matrix[x][j]
        if check_tree_value >= value
        then
            return false
        end
    end

    return true
end

local function check_down_visable(tree_matrix, i, j)
    local value = tree_matrix[i][j]
    for x = i+1, #tree_matrix, 1
    do
        local check_tree_value = tree_matrix[x][j]
        if check_tree_value >= value
        then
            return false
        end
    end

    return true
end

local function check_left_visable(tree_matrix, i, j)
    local value = tree_matrix[i][j]
    for x = 1, j-1, 1
    do
        local check_tree_value = tree_matrix[i][x]
        if check_tree_value >= value
        then
            return false
        end
    end

    return true
end

local function check_right_visable(tree_matrix, i, j)
    local value = tree_matrix[i][j]
    for x = j+1, #tree_matrix[i], 1
    do
        local check_tree_value = tree_matrix[i][x]
        if check_tree_value >= value
        then
            return false
        end
    end

    return true
end

local function task(tree_matrix)
    local visable_sum = 0

    for i = 1, #tree_matrix, 1
    do
        for j = 1, #tree_matrix[i], 1
        do
            -- Check this tree:
            --print(tree_matrix[i][j])
            if check_up_visable(tree_matrix, i, j) or
            check_down_visable(tree_matrix, i, j) or
            check_left_visable(tree_matrix, i, j) or
            check_right_visable(tree_matrix, i, j)
            then
                --print(i, j, tree_matrix[i][j])
                visable_sum = visable_sum + 1
            end
        end 
    end

    print("Trees:", visable_sum)
end

print("Day 8, task 1!")

local tree_matrix = open_file(arg[1])
task(tree_matrix)