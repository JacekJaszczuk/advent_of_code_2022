#!/usr/bin/env lua5.4

--local inspect = require("inspect")
local Matrix = require("lib.matrix")

-- Function checks wheter tail touches head:
local function is_head_touch_tail(head, tail)
    if (math.abs(head.x - tail.x) <= 1) and (math.abs(head.y- tail.y) <= 1)
    then
        return true
    else
        return false
    end
end

-- Function make tail one step:
local function make_tail_one_step(move, head, tail, tail_matrix)
    if move == "U"
    then
        tail.x = head.x
        tail.y = tail.y + 1
    elseif move == "R"
    then
        tail.x = tail.x + 1
        tail.y = head.y
    elseif move == "D"
    then
        tail.x = head.x
        tail.y = tail.y - 1
    elseif move == "L"
    then
        tail.x = tail.x - 1
        tail.y = head.y
    end

    if not tail_matrix[tail.x][tail.y]
    then
        tail.sum = tail.sum + 1
        tail_matrix[tail.x][tail.y] = true
    end
end

-- Function makes head and tail move. In addition, it records what places the tail visited:
local function make_move(move, value, head, tail, tail_matrix)
    if move == "U"
    then
        for _ = 1, value, 1
        do
            head.y = head.y + 1
            if not is_head_touch_tail(head, tail)
            then
                make_tail_one_step(move, head, tail, tail_matrix)
            end
        end
    elseif move == "R"
    then
        for _ = 1, value, 1
        do
            head.x = head.x + 1
            if not is_head_touch_tail(head, tail)
            then
                make_tail_one_step(move, head, tail, tail_matrix)
            end
        end
    elseif move == "D"
    then
        for _ = 1, value, 1
        do
            head.y = head.y - 1
            if not is_head_touch_tail(head, tail)
            then
                make_tail_one_step(move, head, tail, tail_matrix)
            end
        end
    elseif move == "L"
    then
        for _ = 1, value, 1
        do
            head.x = head.x - 1
            if not is_head_touch_tail(head, tail)
            then
                make_tail_one_step(move, head, tail, tail_matrix)
            end
        end
    end
end

local function open_file(filename)
    local head = {
        x = 0,
        y = 0,
    }
    local tail = {
        x = 0,
        y = 0,
        sum = 0,
    }
    local tail_matrix = Matrix:new()

    -- Add start position to matrix:
    tail_matrix[0][0] = true
    tail.sum = tail.sum + 1

    local f = io.open(filename)
    for line in f:lines()
    do
        local move, value = line:match("(%w) (%d+)")
        --print(move, value)
        make_move(move, value, head, tail, tail_matrix)
    end
    f:close()

    return tail.sum
end

print("Day 9, task 1!")
print("Tail sum:", open_file(arg[1]))