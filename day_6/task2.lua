#!/usr/bin/env lua5.4

local inspect = require("inspect")

print("Day 6, task 2!")

local Set = {
    new = function(self)
        local o = {
            count = 0,
            set = {},
        }

        setmetatable(o, self)
        self.__index = self
        return o
    end,

    push = function(self, element)
        if not self.set[element]
        then
            self.count = self.count + 1
            self.set[element] = true
        end
    end,
}

local function open_file(filename)
    local f = io.open(filename)
    local data = f:read("a")
    f:close()

    for i = 1, #data-14, 1
    do
        local chunks = {}
        for j = 0, 13, 1
        do
            table.insert(chunks, data:sub(i+j,i+j))
        end

        --print(inspect(chunks))
        local set = Set:new()
        for _, value in ipairs(chunks)
        do
            set:push(value)    
        end

        --print(set.count)
        if set.count == 14
        then
            return i + 13
        end
    end
end

local ret = open_file(arg[1])
print(ret)