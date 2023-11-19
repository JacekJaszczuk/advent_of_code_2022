#!/usr/bin/env lua5.4

local tablex = require("pl.tablex")

print("Day 19, task 1!")

local function open_file(filename)
    local blueprints = {}

    local template = "Blueprint (%d+): Each ore robot costs (%d+) ore. Each clay robot costs (%d+) ore. Each obsidian robot costs (%d+) ore and (%d+) clay. Each geode robot costs (%d+) ore and (%d+) obsidian."

    local f = io.open(filename)
    local data = f:read("a")
    f:close()

    for blueprint_id,
        robot_ore_ore,
        robot_clay_ore,
        robot_obsidian_ore,
        robot_obsidian_clay,
        robot_geode_ore,
        robot_geode_obsidian in data:gmatch(template)
    do
        table.insert(blueprints, {
            robot_ore_ore        = tonumber(robot_ore_ore),
            robot_clay_ore       = tonumber(robot_clay_ore),
            robot_obsidian_ore   = tonumber(robot_obsidian_ore),
            robot_obsidian_clay  = tonumber(robot_obsidian_clay),
            robot_geode_ore      = tonumber(robot_geode_ore),
            robot_geode_obsidian = tonumber(robot_geode_obsidian),
        }
    )
    end

    return blueprints
end

local function add_resources(node)
    node.ore      = node.ore      + node.robot_ore
    node.clay     = node.clay     + node.robot_clay
    node.obsidian = node.obsidian + node.robot_obsidian
    node.geode    = node.geode    + node.robot_geode
end

local function perform_action(node, action)
    node.robot_ore      = node.robot_ore      + action.robot_ore
    node.robot_clay     = node.robot_clay     + action.robot_clay
    node.robot_obsidian = node.robot_obsidian + action.robot_obsidian
    node.robot_geode    = node.robot_geode    + action.robot_geode
    node.ore            = node.ore            + action.ore
    node.clay           = node.clay           + action.clay
    node.obsidian       = node.obsidian       + action.obsidian
    node.geode          = node.geode          + action.geode
end

local function generate_possible_actions(blueprint, node)
    local actions = {}

    -- Check add ore robot:
    if blueprint.robot_ore_ore <= node.ore
    then
        table.insert(actions, {
            robot_ore = 1,
            robot_clay = 0,
            robot_obsidian = 0,
            robot_geode = 0,
            ore = -blueprint.robot_ore_ore,
            clay = 0,
            obsidian = 0,
            geode = 0,
        })
    end

    -- Check add clay robot:
    if blueprint.robot_clay_ore <= node.ore
    then
        table.insert(actions, {
            robot_ore = 0,
            robot_clay = 1,
            robot_obsidian = 0,
            robot_geode = 0,
            ore = -blueprint.robot_clay_ore,
            clay = 0,
            obsidian = 0,
            geode = 0,
        })
    end

    -- Check add obsidian robot:
    if (blueprint.robot_obsidian_ore <= node.ore) and (blueprint.robot_obsidian_clay <= node.clay)
    then
        table.insert(actions, {
            robot_ore = 0,
            robot_clay = 0,
            robot_obsidian = 1,
            robot_geode = 0,
            ore = -blueprint.robot_obsidian_ore,
            clay = -blueprint.robot_obsidian_clay,
            obsidian = 0,
            geode = 0,
        })
    end

    -- Check add obsidian robot:
    if (blueprint.robot_geode_ore <= node.ore) and (blueprint.robot_geode_obsidian <= node.obsidian)
    then
        table.insert(actions, {
            robot_ore = 0,
            robot_clay = 0,
            robot_obsidian = 0,
            robot_geode = 1,
            ore = -blueprint.robot_geode_ore,
            clay = 0,
            obsidian = -blueprint.robot_geode_obsidian,
            geode = 0,
        })
    end

    -- Insert empty action:
    table.insert(actions, {
        robot_ore = 0,
        robot_clay = 0,
        robot_obsidian = 0,
        robot_geode = 0,
        ore = 0,
        clay = 0,
        obsidian = 0,
        geode = 0,
    })

    return actions
end

local function make_blueprint(blueprint, start_node, time, action, geode_max)
    start_node = start_node or {
        robot_ore = 1,
        robot_clay = 0,
        robot_obsidian = 0,
        robot_geode = 0,
        ore = 0,
        clay = 0,
        obsidian = 0,
        geode = 0,
    }
    time = time or 1
    action = action or {
        robot_ore = 0,
        robot_clay = 0,
        robot_obsidian = 0,
        robot_geode = 0,
        ore = 0,
        clay = 0,
        obsidian = 0,
        geode = 0,
    }
    geode_max = geode_max or {geode_max = 0}

    -- Check time is over:
    if time > 21
    then
        return start_node.geode
    end

    -- Add minute:
    time = time + 1
    --print(time)

    -- Make new node:
    local node = tablex.copy(start_node)

    -- Add resources:
    add_resources(node)

    -- Perform action:
    perform_action(node, action)

    -- Generate possible action:
    local actions = generate_possible_actions(blueprint, node)
    --print("Actions:", #actions)
    for _, action in ipairs(actions)
    do
        local geode = make_blueprint(blueprint, node, time, action, geode_max)
        --print("Geode:", geode)
        --print("Geode_MAX:", geode_max.geode_max)
        if geode > geode_max.geode_max
        then
            geode_max.geode_max = geode
        end
    end

    return geode_max.geode_max
end

local function make_blueprints(blueprints)
    for _, blueprint in ipairs(blueprints)
    do
        print("Geode_MAX:", make_blueprint(blueprint))
        os.exit(11)
    end
end

local blueprints = open_file(arg[1])

make_blueprints(blueprints)