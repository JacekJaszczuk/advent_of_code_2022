#!/usr/bin/env lua5.4

local inspect = require("inspect")

local most_total_size = 100000

local function open_file(filename)
    local path_list = {}

    local dirs_size = {}

    local f = io.open(filename)

    -- Read file line by line:
    for line in f:lines()
    do
        --print(line)
        --print(line:sub(1, 4))

        -- Check "cd":
        if line:sub(1, 4) == "$ cd"
        then
            --print(line:sub(6, #line))

            if line:sub(6, #line) == "/"
            then
                path_list = {"/"}
            elseif line:sub(6, #line) == ".."
            then
                table.remove(path_list)
            else
                table.insert(path_list, line:sub(6, #line))
            end
        else
            -- Get file size if file size:
            local _, _, file_size = line:find("(%d+) %S+")
            --print(file_size)

            if file_size
            then
                file_size = tonumber(file_size)
                for i, _ in ipairs(path_list)
                do
                        local dir = table.concat(path_list, "/", 1, i)
                        if not dirs_size[dir]
                        then
                            dirs_size[dir] = file_size
                        else
                            dirs_size[dir] = dirs_size[dir] + file_size
                        end
                end
            end
        end

        --print(inspect(path_list))
    end

    print(inspect(dirs_size))

    local total_sum = 0
    for _, value in pairs(dirs_size)do
        if value <= most_total_size
        then
            total_sum = total_sum + value
        end
    end

    print(total_sum)

    -- Find directory to delete:
    local filesystem_size = dirs_size["/"]
    local to_free = 30000000 - (70000000 - filesystem_size)

    print("To free:", to_free)

    -- Move table to list and sort:
    local dirs_list = {}
    for _, value in pairs(dirs_size)
    do
        table.insert(dirs_list, value)
    end
    table.sort(dirs_list)
    --print(inspect(dirs_list))

    -- Find good value:
    for _, value in ipairs(dirs_list)
    do
        if value > to_free
        then
            print("To delete:", value)
            break
        end
    end

    f:close()
end

print("Day 7, task 2!")

open_file(arg[1])