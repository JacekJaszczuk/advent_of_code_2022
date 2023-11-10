-- Dijkstra alghoritm from day 12.

local heap = require("binaryheap")

local dijkstra = {}

-- Function reset all node.value to math.maxinteger:
function dijkstra.reset_to_max(nodes)
    for _, node in ipairs(nodes)
    do
        node.value = math.maxinteger
    end
end

-- Function calc and save route length to other node:
function dijkstra.calc_route(start_node)
    local visited_nodes = {}
    local heap_nodes = heap.minUnique(
        function(a, b)
            return a.value < b.value
        end
    )

    start_node.value = 0

    -- Add start node:
    heap_nodes:insert(start_node, start_node)

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

    -- Add routes with length do start_node:
    start_node.routes = {}
    for node, _ in pairs(visited_nodes)
    do
        if node ~= start_node
        then
            start_node.routes[node] = node.value
        end
    end
end

return dijkstra