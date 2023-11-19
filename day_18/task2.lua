#!/usr/bin/env lua5.4

print("Day 18, task 2!")

local function get_hash(x, y, z)
    return string.format("%03d%03d%03d", x, y, z)
end

local neighbors = {
    {x = 0, y = 0, z = 1},
    {x = 0, y = 0, z = -1},
    {x = 0, y = 1, z = 0},
    {x = 0, y = -1, z = 0},
    {x = 1, y = 0, z = 0},
    {x = -1, y = 0, z = 0},
}

local function get_free_wall(cubes, cube)
    local free_wall = 0

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

local function check_neighbors(cubes, cube, visited)
    --print("Start", get_hash(cube.x, cube.y, cube.z))

    visited = visited or {}
    -- If cube is visited we exit:
    if visited[get_hash(cube.x, cube.y, cube.z)]
    then
        return false
    else
        visited[get_hash(cube.x, cube.y, cube.z)] = true
    end

    -- If we have 20 or more value this node is not inside:
    if cube.x >= 19 or cube.y >= 19 or cube.z >= 19
    then
        return true
    end

    -- If we have 0 or less value this node is not inside:
    if cube.x <= 0 or cube.y <= 0 or cube.z <= 0
    then
        return true
    end

    -- Check neighbors:
    for _, neighbor in ipairs(neighbors)
    do
        local real_neighbor = {
            x = cube.x + neighbor.x,
            y = cube.y + neighbor.y,
            z = cube.z + neighbor.z,
        }
        -- Check neighbor is not exist:
        if not cubes[get_hash(
            real_neighbor.x,
            real_neighbor.y,
            real_neighbor.z
        )]
        then
            --print("Neig", get_hash(neighbor.x, neighbor.y, neighbor.z))
            if check_neighbors(cubes, real_neighbor, visited) == true
            then
                return true
            end
        end
        --print("End loop")
    end

    return false
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
        all_free = all_free + get_free_wall(cubes, cube)
    end

    return all_free
end

-- Find cubes inside:
local function find_free_wall_cubes_inside(cubes)
    local cubes_inside = {}

    for x = 0, 19, 1
    do
        for y = 0, 19, 1
        do
            for z = 0, 19, 1
            do
                if not cubes[get_hash(x, y, z)]
                then
                    local buf_cube = {x = x, y = y, z = z}
                    if not check_neighbors(cubes, buf_cube)
                    then
                        --cubes_inside = cubes_inside + 1
                        cubes_inside[get_hash(
                            buf_cube.x,
                            buf_cube.y,
                            buf_cube.z
                        )] = buf_cube
                    end
                end
            end
        end
    end

    return count_all(cubes_inside)
end

local cubes = open_file(arg[1])
local all_free = count_all(cubes)
local free_wall_inside = find_free_wall_cubes_inside(cubes)
--print(free_wall_inside)
print("Answer:", all_free - free_wall_inside)
