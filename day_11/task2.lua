#!/usr/bin/env lua5.4

print("Day 11, task 2!")

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
    return string.format("Monkey %d: inspect count {%d}, new = %s, test {%d}, true Monkey {%d}, false Monkey {%d}",
        self.id,
        self.inspect_count,
        self.operation_string,
        self.divisable_test,
        self.test_true_monkey.id,
        self.test_false_monkey.id
    )
end

function Monkey:iterate()
    for _, item in ipairs(self.starting_items)
    do
        for divisable, value in pairs(item)
        do
            item[divisable] = self.operation(item[divisable]) % divisable
        end

        self.inspect_count = self.inspect_count + 1

        if item[self.divisable_test] == 0
        then
            table.insert(self.test_true_monkey.starting_items, item)
        else
            table.insert(self.test_false_monkey.starting_items, item)
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

    local divisables = {}
    -- Parse file divisables:
    for divisable in data:gmatch("Test: divisible by (%d+)")
    do
        table.insert(divisables, tonumber(divisable))
    end

    -- Parse file Monkey:
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
        for value in starting_items_buf:gmatch("(%d+)")
        do
            local item = {}
            for _, divisable in ipairs(divisables)
            do
                item[divisable] = tonumber(value) % divisable
            end
            table.insert(starting_items, item)
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

-- Run 1000 rounds:
for i = 1, 10000, 1
do
    iterate_monkeys()
end

print("Monkeys after 10000 rounds")
print_monkeys()

-- Sort by most active monkeys:
table.sort(monkeys, function(a,b)
    return a.inspect_count > b.inspect_count
end
)

print("Answer:", monkeys[1].inspect_count * monkeys[2].inspect_count)