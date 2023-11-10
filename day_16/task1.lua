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

-- Function calc pressure for sequence and start_node:
local function calc_pressue(sequence, start_node)
    local minutes = 30 - start_node.routes[sequence[1]]

    local pressure = 0

    for i = 1, #sequence, 1
    do
        -- If not have time we, and:
        if minutes <= 1
        then
            break
        end

        -- Get nodes:
        local node_a = sequence[i]
        local node_b = sequence[i+1]

        -- Calc pressure
        minutes = minutes - 1
        pressure = pressure + node_a.rate*minutes

        if node_b
        then
            minutes = minutes - node_a.routes[node_b]
        end
    end

    return pressure
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
        table.insert(good_nodes, node)
    end
end

-- Get start node:
local start_node = nodes[1]

-- Find max pressure:
local best_pressure = 0
local best_sequence = ""
for sequence in permute.order_iter(good_nodes)
do
    local now_pressure = calc_pressue(sequence, start_node)
    if now_pressure > best_pressure
    then
        best_pressure = now_pressure
        best_sequence = ""
        for _, node in ipairs(sequence)
        do
            best_sequence = best_sequence .. node.id
        end
    end
end

print("Answer:", best_pressure, best_sequence)