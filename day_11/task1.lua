#!/usr/bin/env lua5.4

print("Day 11, task 1!")

local class = require("pl.class")

local Monkey = class()

function Monkey:_init(
    id,
    starting_items,
    operation,
    operation_string,
    divisable_test,
    test_true_monkey,
    test_false_monkey
)
    self.id = id
    self.starting_items = starting_items
    self.operation = operation
    self.operation_string = operation_string
    self.divisable_test = divisable_test
    self.test_true_monkey = test_true_monkey
    self.test_false_monkey = test_false_monkey
    self.inspect_count = 0
end

function Monkey:__tostring()
    local string_starting_items = ""
    for _, item in ipairs(self.starting_items)
    do
        string_starting_items = string_starting_items .. tostring(item) .. ","
    end
    return string.format("Monkey %d: items {%s}, inspect count {%d}, new = %s, test {%d}, true Monkey {%d}, false Monkey {%d}",
        self.id,
        string_starting_items,
        self.inspect_count,
        self.operation_string,
        self.divisable_test,
        self.test_true_monkey.id,
        self.test_false_monkey.id
    )
end

function Monkey:iterate()
    for i, item in ipairs(self.starting_items)
    do
        local new = math.floor(self.operation(item) / 3)
        self.inspect_count = self.inspect_count + 1
        if new % self.divisable_test == 0
        then
            table.insert(self.test_true_monkey.starting_items, new)
        else
            table.insert(self.test_false_monkey.starting_items, new)
        end
    end
    self.starting_items = {}
end

local monkeys = {}

local function print_monkeys()
    -- Print all monkeys:
    for _, monkey in ipairs(monkeys)
    do
        print(monkey)
    end
end

local monkey_template =
[[
Monkey (%d+):
  Starting items: ([%g%s]-)
  Operation: new = ([%g%s]-)
  Test: divisible by (%d+)
    If true: throw to monkey (%d+)
    If false: throw to monkey (%d+)]]

local function open_file(filename)
    -- Read all file:
    local f = io.open(filename)
    local data = f:read("a")
    f:close()

    -- Parse file:
    for id,
        starting_items_buf,
        operation_buf,
        divisable_test,
        test_true_monkey,
        test_false_monkey in data:gmatch(monkey_template)
    do
        local starting_items = {}
        local operation

        -- Parse starting_items
        for item in starting_items_buf:gmatch("(%d+)")
        do
            table.insert(starting_items, tonumber(item))
        end

        -- Parse operation:
        operation = load("return function(old) return " .. operation_buf .. " end")()

        -- Create Monkey:
        table.insert(monkeys, Monkey(
            tonumber(id),
            starting_items,
            operation,
            operation_buf,
            tonumber(divisable_test),
            tonumber(test_true_monkey),
            tonumber(test_false_monkey)
        ))
    end

    -- Fix monkeys links:
    for _, monkey in ipairs(monkeys)
    do
        monkey.test_true_monkey = monkeys[monkey.test_true_monkey+1]
        monkey.test_false_monkey = monkeys[monkey.test_false_monkey+1]
    end

    -- Print all monkeys:
    print("Start monkeys:")
    print_monkeys()
end

local function iterate_monkeys()
    for _, monkey in ipairs(monkeys)
    do
        monkey:iterate()
    end
end

open_file(arg[1])

-- Run 20 rounds:
for i = 1, 20, 1
do
    iterate_monkeys()
end

print("Monkeys after 20 rounds")
print_monkeys()

-- Sort by most active monkeys:
table.sort(monkeys, function(a,b)
    return a.inspect_count > b.inspect_count
end
)

print("Answer:", monkeys[1].inspect_count * monkeys[2].inspect_count)