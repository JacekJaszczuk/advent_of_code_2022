#!/usr/bin/env lua5.4

print("Day 18, task 1!")

local function get_hash(x, y, z)
    return string.format("%03d%03d%03d", x, y, z)
end

local function check_neighbors(cubes, cube)
    local free_wall = 0
    local neighbors = {
        {x = 0, y = 0, z = 1},
        {x = 0, y = 0, z = -1},
        {x = 0, y = 1, z = 0},
        {x = 0, y = -1, z = 0},
        {x = 1, y = 0, z = 0},
        {x = -1, y = 0, z = 0},
    }

    -- Check neighbors:
    for _, neighbor in ipairs(neighbors)
    do
        if not cubes[get_hash(
            cube.x + neighbor.x,
            cube.y + neighbor.y,
            cube.z + neighbor.z
        )]
        then
            free_wall = free_wall + 1
        end
    end

    return free_wall
end

local function open_file(filename)
    local cubes = {}

    local f = io.open(filename)
    local data = f:read("a")
    f:close()
    for x, y, z in data:gmatch("(%d+),(%d+),(%d+)")
    do
        cubes[get_hash(x, y, z)] = {
            x = x,
            y = y,
            z = z,
        }
    end

    return cubes
end

-- Count all cubes:
local function count_all(cubes)
    local all_free = 0
    for _, cube in pairs(cubes)
    do
        all_free = all_free + check_neighbors(cubes, cube)
    end

    return all_free
end

local cubes = open_file(arg[1])
local all_free = count_all(cubes)
print("Answer:", all_free)
