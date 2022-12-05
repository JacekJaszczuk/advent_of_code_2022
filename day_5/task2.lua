#!/usr/bin/env lua5.4

local inspect = require("inspect")

print("Day 5, task 2!")

local function get_stacks_size(first_line_len)
    return ((first_line_len - 3) / 4 + 1)
end

local function print_stacks(stacks)
    for i, stack in ipairs(stacks)
    do
        print("Stack", i, inspect(stack))
    end
end

local function open_file(filename)
    -- Open file:
    local f = io.open(filename)

    -- Get first line:
    local first_line = f:read("l")
    local stacks_size = get_stacks_size(#first_line)

    print("Stacks size:", stacks_size)

    -- Generate stacks:
    local stacks = {}
    for i = 1, stacks_size, 1
    do
        table.insert(stacks, {})
    end

    -- Return to file begin:
    f:seek("set", 0)

    -- Read stacks:
    for line in f:lines()
    do
        -- Check this is end:
        if line:sub(2, 2) == "1"
        then
            break
        end

        -- Read stacks level:
        for i = 1, stacks_size, 1
        do
            local element_index = 2 + 4*(i-1)
            local element = line:sub(element_index, element_index)

            -- Add element to correct stack if no space key:
            if element ~= " "
            then
                table.insert(stacks[i], 1, element)
            end
        end
    end

    -- Print all stacks:
    print("Begin stacks state:")
    print_stacks(stacks)

    -- Remove null line:
    local _ = f:read("l")

    -- Read and do movies:
    for line in f:lines()
    do
        -- Get move:
        local size_of_move, from, to = line:match("move (%d+) from (%d+) to (%d+)")
        size_of_move = tonumber(size_of_move)
        from = tonumber(from)
        to = tonumber(to)

        -- Do move:
        local from_stack = stacks[from]
        local to_stack = stacks[to]
        -- Insert new element:
        for i = 1, size_of_move, 1
        do
            local element = from_stack[#from_stack-size_of_move+i]
            table.insert(to_stack, element)
        end
        -- Remove old element:
        for i = 1, size_of_move, 1
        do
            table.remove(from_stack)
        end
    end

    -- Print all stacks:
    print("Finish stacks state:")
    print_stacks(stacks)

    -- Print answer:
    print("Answer:")
    for _, stack in ipairs(stacks)
    do
        io.stdout:write(stack[#stack])
    end
    print()

    -- Close file:
    f:close()
end

open_file(arg[1])