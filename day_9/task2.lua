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

local function get_length_head_and_tail(head, tail)
    local length = 0
    length = length + math.abs(head.x - tail.x)
    length = length + math.abs(head.y - tail.y)
    return length
end

local moves = {
    {x =  0, y =  1, length = 1}, -- U
    {x =  1, y =  1, length = 1}, -- RU
    {x =  1, y =  0, length = 1}, -- R
    {x =  1, y = -1, length = 1}, -- RD
    {x =  0, y = -1, length = 1}, -- D
    {x = -1, y = -1, length = 1}, -- LD
    {x = -1, y =  0, length = 1}, -- L
    {x = -1, y =  1, length = 1}, -- LU
    {x =  1, y =  1, length = 2}, -- RU2
    {x =  1, y = -1, length = 2}, -- RD2
    {x = -1, y = -1, length = 2}, -- LD2
    {x = -1, y =  1, length = 2}, -- LU2
}

-- Function make tail one step:
local function make_tail_one_step(nodes, nodes_id, move)
    local head = nodes[nodes_id]
    local tail = nodes[nodes_id + 1]

    -- If node non-exist or current tail touch head:
    if (not tail) or (is_head_touch_tail(head, tail))
    then
        return
    end

    -- Make move:
    local tail_buf = {}
    for _, move in ipairs(moves)
    do
        tail_buf.x = tail.x + move.x
        tail_buf.y = tail.y + move.y
        if get_length_head_and_tail(head, tail_buf) == move.length
        then
            tail.x = tail_buf.x
            tail.y = tail_buf.y
            break
        end
    end

    -- Check this position is exist:
    if not tail.matrix[tail.x][tail.y]
    then
        tail.sum = tail.sum + 1
        tail.matrix[tail.x][tail.y] = true
    end

    -- Check is good move:
    if not is_head_touch_tail(head, tail)
    then
        error(string.format("Tail not touch head after move! tail{%d,%d} head{%d,%d} move{%s} nodes_id{%d}", tail.x, tail.y, head.x, head.y, move, nodes_id))
    end

    make_tail_one_step(nodes, nodes_id + 1, move)
end

-- Function makes nodes move:
local function make_move(move, value, nodes)
    local head = nodes[1]

    -- Move head:
    for _ = 1, value, 1
    do
        -- Move head:
        if move == "U"
        then
            head.y = head.y + 1
        elseif move == "R"
        then
            head.x = head.x + 1
        elseif move == "D"
        then
            head.y = head.y - 1
        elseif move == "L"
        then
            head.x = head.x - 1
        end

        -- Check this position is exist:
        if not head.matrix[head.x][head.y]
        then
            head.sum = head.sum + 1
            head.matrix[head.x][head.y] = true
        end

        -- Move tail:
        make_tail_one_step(nodes, 1, move)
    end
end

local function open_file(filename)
    -- Create all nodes, 1 -> head
    local nodes = {}
    for i = 1, 10, 1
    do
        nodes[i] = {
            x = 0,
            y = 0,
            sum = 1,
            matrix = Matrix:new(),
        }
        nodes[i].matrix[0][0] = true
    end

    -- Read file:
    local f = io.open(filename)
    for line in f:lines()
    do
        local move, value = line:match("(%w) (%d+)")
        make_move(move, value, nodes)

    end
    f:close()

    return nodes[10].sum
end

print("Day 9, task 2!")
print("Tail sum:", open_file(arg[1]))