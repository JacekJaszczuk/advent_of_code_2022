#!/usr/bin/env lua5.4

print("Day 17, task 1!")

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

local function run_rocks(map, moves)
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

        --if rocks_types_iter == 2
        --then
        --    -- Print rock:
        --    --print(is_move_is_legal(map, rock, {x = 1, y = -1}))
        --    --do_move(rock, {x = 1, y = -1})
        --    print_rock_to_map(map, rock)
        --    write_map_to_file(map)
        --    os.exit(11)
        --end

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

        if rocks_types_iter == 2022
        then
            write_map_to_file(map)
            return get_highest_point(map)
        end
    end
end

local moves = open_file(arg[1])
local map = generate_map()
print("Answer:", run_rocks(map, moves) - 1)