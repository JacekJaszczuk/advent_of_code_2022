#!/usr/bin/env lua5.4

print("Day 16, task 1!")

local dijkstra = require("lib.dijkstra")
local permute = require("pl.permute")
local inspect = require("inspect")

local function open_file(filename)
    local nodes = {}
    local nodes_by_id = {}
    local template = "Valve (%g+) has flow rate=(%d+); tunnel%w- lead%w- to valve%w- ([%g%s]+)$"

    local f = io.open(filename)
    for line in f:lines()
    do
        -- Create node:
        local node = {}
        local node_id, node_rate, node_neighbors_id = line:match(template)
        node.id = node_id
        node.rate = tonumber(node_rate)
        node.neighbors_id = {}

        -- Add all neighbors:
        for neighbor_node_id in node_neighbors_id:gmatch("%w+")
        do
            table.insert(node.neighbors_id, neighbor_node_id)
        end

        -- Add node to nodes:
        table.insert(nodes, node)
        nodes_by_id[node.id] = node
    end
    f:close()

    -- Fix nodes neighbors:
    for _, node in ipairs(nodes)
    do
        node.neighbors = {}
        for _, node_id in ipairs(node.neighbors_id)
        do
            table.insert(node.neighbors, nodes_by_id[node_id])
        end
    end

    return nodes
end

-- Function find end return AA node:
function get_aa_node(nodes)
    for _, node in ipairs(nodes)
    do
        if node.id == "AA"
        then
            return node
        end
    end
end

-- Function calc best approximation from seqence:
local function best_approx_value(minutes, sequence)
    local sum = 0
    for _, node in ipairs(sequence)
    do
        sum = sum + node.rate
    end

    return sum * minutes
end

-- Function run permutation:
local function run_permutation(best_value, now_value, now_value_sequence, minutes, sequence, old_node)
    -- Copy sequence:
    local copy_sequence = {}
    for node, value in pairs(sequence)
    do
        copy_sequence[node] = true
    end

    -- Get new now_node end run calc:
    for now_node, _ in pairs(copy_sequence)
    do
        -- Calc new pressure:
        local copy_minutes = minutes
        local copy_now_value = now_value
        local copy_now_value_sequence = now_value_sequence

        copy_minutes = copy_minutes - old_node.routes[now_node]
        copy_minutes = copy_minutes - 1

        -- If we have time:
        if copy_minutes > 0
        then
            copy_now_value = copy_now_value + now_node.rate * copy_minutes
            copy_now_value_sequence = copy_now_value_sequence .. now_node.id

            -- If now_value is more than best we save it:
            if copy_now_value > best_value.best_value
            then
                best_value.best_value = copy_now_value
                best_value.best_sequence = copy_now_value_sequence
                print("Best:", best_value.best_value, best_value.best_sequence)
            end

            -- Run next iteration:
            copy_sequence[now_node] = nil
            run_permutation(best_value, copy_now_value, copy_now_value_sequence, copy_minutes, copy_sequence, now_node)
            copy_sequence[now_node] = true
        end
    end
end

-- Load data:
local nodes = open_file(arg[1])

-- Calc routes:
for _, node in ipairs(nodes)
do
    dijkstra.reset_to_max(nodes)
    dijkstra.calc_route(node)
end

-- Find good nodes:
local good_nodes = {}
for _, node in ipairs(nodes)
do
    if node.rate > 0
    then
        good_nodes[node] = true
    end
end

-- Get start node:
local start_node = get_aa_node(nodes)

-- Find max pressure:
local best_value = {
    best_value = 0,
    best_sequence = "",
}
run_permutation(best_value, 0, "", 30, good_nodes, start_node)

print("Answer:", best_value.best_value, best_value.best_sequence)