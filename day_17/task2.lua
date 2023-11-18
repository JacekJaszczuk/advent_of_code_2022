#!/usr/bin/env lua5.4

print("Day 17, task 2!")

local array2d = require("pl.array2d")

local function open_file(filename)
    local moves = {}

    local f = io.open(filename)
    for move in f:lines(1)
    do
        if move == "<"
        then
            table.insert(moves, {x = -1, y = 0})
        elseif move == ">"
        then
            table.insert(moves, {x = 1, y = 0})
        end
    end
    f:close()

    return moves
end

local function write_map_to_file(map)
    local f = io.open("tmp/map_day17.txt", "w")
    for i = #map, 1, -1
    do
        for j = 1, #map[1], 1
        do
            f:write(map[i][j])

        end
        f:write("\n")
    end
    f:close()
end

local function get_rocks_types()
    local rocks_types = {}

    -- Add "-" rock:
    table.insert(rocks_types, {
        {x = 0, y = 0},
        {x = 1, y = 0},
        {x = 2, y = 0},
        {x = 3, y = 0},
        __name = 'Rock: "-"'
    })
    setmetatable(rocks_types[#rocks_types], rocks_types[#rocks_types])

    -- Add "+" rock:
    table.insert(rocks_types, {
        {x = 1, y = 0},
        {x = 0, y = 1},
        {x = 1, y = 1},
        {x = 2, y = 1},
        {x = 1, y = 2},
        __name = 'Rock: "+"'
    })
    setmetatable(rocks_types[#rocks_types], rocks_types[#rocks_types])

    -- Add "L" rock:
    table.insert(rocks_types, {
        {x = 0, y = 0},
        {x = 1, y = 0},
        {x = 2, y = 0},
        {x = 2, y = 1},
        {x = 2, y = 2},
        __name = 'Rock: "L"'
    })
    setmetatable(rocks_types[#rocks_types], rocks_types[#rocks_types])

    -- Add "I" rock:
    table.insert(rocks_types, {
        {x = 0, y = 0},
        {x = 0, y = 1},
        {x = 0, y = 2},
        {x = 0, y = 3},
        __name = 'Rock: "I"'
    })
    setmetatable(rocks_types[#rocks_types], rocks_types[#rocks_types])

    -- Add square rock:
    table.insert(rocks_types, {
        {x = 0, y = 0},
        {x = 1, y = 0},
        {x = 0, y = 1},
        {x = 1, y = 1},
        __name = 'Rock: square'
    })
    setmetatable(rocks_types[#rocks_types], rocks_types[#rocks_types])

    return rocks_types
end

local function generate_map(row_size, col_size)
    row_size = row_size or 20000
    col_size = col_size or 9

    local map = array2d.new(row_size, col_size, ".")

    -- Add left and right wall:
    for i = 1, row_size, 1
    do
        map[i][1] = "#"
        map[i][9] = "#"
    end

    -- Add floor:
    for i = 1, 9, 1 do
        map[1][i] = "#"
    end

    return map
end

local function get_highest_point(map)
    local highest = 0

    for i = 1, #map, 1
    do
        for j = 2, 8, 1
        do
            if map[i][j] == "#"
            then
                highest = i
            end
        end
    end

    return highest
end

local function do_move(rock, move)
    for _, rock_point in ipairs(rock)
    do
        rock_point.x = rock_point.x + move.x
        rock_point.y = rock_point.y + move.y
    end
end

local function is_move_is_legal(map, rock, move)
    for _, rock_point in ipairs(rock)
    do
        if map[rock_point.y + move.y][rock_point.x + move.x] == "#"
        then
            return false
        end
    end

    return true
end

local function print_rock_to_map(map, rock)
    for _, rock_point in ipairs(rock)
    do
        map[rock_point.y][rock_point.x] = "#"
    end
end

-- Find cycle:
local function find_cycle(map, moves)
    local rocks_types = get_rocks_types()

    local rocks_types_iter = 0
    local moves_iter = 0
    local down_move = {x = 0, y = -1}
    local highest = get_highest_point(map)
    local left_gap = 4
    local high_gap = 4
    local cycle_find_set = {}
    while true do
        -- Get rock type:
        local rock_type = rocks_types[(rocks_types_iter%#rocks_types)+1]
        rocks_types_iter = rocks_types_iter + 1

        -- Generate rock:
        local rock = {}
        for _, rock_type_point in ipairs(rock_type)
        do
            table.insert(rock, {
                x = rock_type_point.x + left_gap,
                y = rock_type_point.y + highest + high_gap,
            })
        end

        while true do
            -- Get move:
            local move = moves[(moves_iter%#moves)+1]
            moves_iter = moves_iter + 1

            -- If move is legal we do:
            if is_move_is_legal(map, rock, move)
            then
                do_move(rock, move)
            end

            -- If move to down is not legal we finish this rock:
            if not is_move_is_legal(map, rock, down_move)
            then
                print_rock_to_map(map, rock)
                break
            else
                do_move(rock, down_move)
            end
        end

        -- Calc highest:
        highest = get_highest_point(map)

        -- If we have all "#" print:
        local is_all_rock = true
        for i = 2, 8, 1
        do
            if map[highest-1][i] ~= "#"
            then
                is_all_rock = false
                break
            end
        end
        if is_all_rock
        then
            local rock_number = rocks_types_iter%#rocks_types
            local move_number = moves_iter%#moves
            print(highest, rock_number, move_number)
            local id = string.format("%01d%05d", rock_number, move_number)
            if cycle_find_set[id]
            then
                print("We find cycle")
                return highest - cycle_find_set[id].highest, rocks_types_iter - cycle_find_set[id].rock_number
            else
                cycle_find_set[id] = {highest = highest, rock_number = rocks_types_iter}
            end
        end
    end
end

-- Simulate rocks:
local function run_rocks(map, moves, rock_to_iter)
    local rocks_types = get_rocks_types()

    local rocks_types_iter = 0
    local moves_iter = 0
    local down_move = {x = 0, y = -1}
    local highest
    local left_gap = 4
    local high_gap = 4
    while true do
        -- Calc highest:
        highest = get_highest_point(map)

        -- Get rock type:
        local rock_type = rocks_types[(rocks_types_iter%#rocks_types)+1]
        rocks_types_iter = rocks_types_iter + 1

        -- Generate rock:
        local rock = {}
        for _, rock_type_point in ipairs(rock_type)
        do
            table.insert(rock, {
                x = rock_type_point.x + left_gap,
                y = rock_type_point.y + highest + high_gap,
            })
        end

        while true do
            -- Get move:
            local move = moves[(moves_iter%#moves)+1]
            moves_iter = moves_iter + 1

            -- If move is legal we do:
            if is_move_is_legal(map, rock, move)
            then
                do_move(rock, move)
            end

            -- If move to down is not legal we finish this rock:
            if not is_move_is_legal(map, rock, down_move)
            then
                print_rock_to_map(map, rock)
                break
            else
                do_move(rock, down_move)
            end
        end

        if rocks_types_iter == rock_to_iter
        then
            write_map_to_file(map)
            return get_highest_point(map)
        end
    end
end

local moves = open_file(arg[1])
local map = generate_map()
local cycle_value, rock_number_in_cycle = find_cycle(map, moves)
print(cycle_value)
local map = generate_map()
local rest = run_rocks(map, moves, 1000000000000%rock_number_in_cycle)
print("Answer:", math.floor(1000000000000/rock_number_in_cycle) * cycle_value + (rest-1))