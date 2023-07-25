#!/usr/bin/env lua5.4

print("Day 12, task 2!")

local array2d = require("pl.array2d")
local heap = require("binaryheap")

local function get_matrix_size_from_file(filename)
    local x = 0
    local y = 0
    local f = io.open(filename)
    for line in f:lines()
    do
        y = y + 1
        x = #line
    end
    f:close()

    return x, y
end

local function print_all_matrix(matrix)
    --array2d.write(matrix, io.stdout, "%s")
    array2d.forall(matrix,
        function(row, j) io.stdout:write(row[j].char) end,
        function(i) io.stdout:write("\n") end
    )
end

local function open_file(filename)
    local x, y = get_matrix_size_from_file(filename)

    local matrix = array2d.new(y, x)
    local starts = {}
    local finish

    -- Read file:
    local f = io.open(filename)
    for i = 1, y
    do
        for j = 1, x, 1
        do
            -- Read char:
            local char = "\n"
            while char == "\n"
            do
                char = f:read(1)
            end

            -- Create one node:
            local node = {
                char = char,
                value = math.maxinteger,
                neighbors = {}
            }

            -- Check is this start or finish:
            if (node.char == "S") or (node.char == "a")
            then
                node.char = "a"
                node.value = 0
                table.insert(starts, node)
            elseif node.char == "E"
            then
                node.char = "z"
                finish = node
            end

            matrix[i][j] = node
        end
    end

    -- Fill neighbors:
    for i, j, node in array2d.iter(matrix, true)
    do
        local potential_neighbors = {
            matrix[i-1] and matrix[i-1][j  ], -- UP
            matrix[i  ] and matrix[i  ][j+1], -- RIGHT
            matrix[i+1] and matrix[i+1][j  ], -- DOWN
            matrix[i  ] and matrix[i  ][j-1], -- LEFT
        }
        for k = 1, 4, 1
        do
            local neighbor_node = potential_neighbors[k]
            -- Check neighbor is exist:
            if neighbor_node
            then
                -- Check is good neighbor (max 1 above char):
                if string.byte(neighbor_node.char) <= (string.byte(node.char) + 1)
                then
                    table.insert(node.neighbors, neighbor_node)
                end
            end
        end
    end

    --print_all_matrix(matrix)

    f:close()

    return matrix, starts, finish
end

local function dijkstra(matrix, start, finish)
    local visited_nodes = {}
    local heap_nodes = heap.minUnique(
        function(a, b)
            return a.value < b.value
        end
    )

    -- Add start node:
    heap_nodes:insert(start, start)

    -- Do Dijkstra alghoritm, pop all node::
    for node in function() return heap_nodes:pop() end
    do
        -- Check neighbors:
        for _, neighbor_node in ipairs(node.neighbors)
        do
            if not visited_nodes[node]
            then
                if neighbor_node.value > node.value + 1
                then
                    -- Better value, remeber this:
                    neighbor_node.value = node.value + 1

                    -- Update or add to heap:
                    if heap_nodes:valueByPayload(neighbor_node)
                    then
                        heap_nodes:update(neighbor_node, neighbor_node)
                    else
                        heap_nodes:insert(neighbor_node, neighbor_node)
                    end
                end
            end
        end

        -- Add to visited nodes:
        visited_nodes[node] = true
    end

    return finish.value
end

local matrix, starts, finish = open_file(arg[1])
local best_answer = math.maxinteger
for _, start in ipairs(starts)
do
    local answer = dijkstra(matrix, start, finish)
    if answer < best_answer
    then
        best_answer = answer
    end
end

print("Finish value:", best_answer)