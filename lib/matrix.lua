-- Lazy Matrix implementation:
local Matrix = {}

-- New method:
function Matrix.new(self, depth)
    depth = depth or 2
    local o = {
        depth = depth-1
    }

    setmetatable(o, self)

    return o
end

-- Run if index do not exist:
function Matrix.__index(table, key)
    if type(key) == "number"
    then
        if table.depth > 0
        then
            table[key] = getmetatable(table):new(table.depth)
            return table[key]
        else
            return nil
        end
    else
        return getmetatable(table)[key]
    end
end

-- Method print matrix:
function Matrix.print(self, x, y)
    for i = 1, x, 1
    do
        for j = 1, y, 1
        do
            if self[i][j]
            then
                io.stdout:write("1")
            else
                io.stdout:write("0")
            end
        end
        io.stdout:write("\n")
    end
end

Matrix.__name = "Matrix"

return Matrix