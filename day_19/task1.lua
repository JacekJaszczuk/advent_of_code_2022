#!/usr/bin/env lua5.4

local tablex = require("pl.tablex")
--local inspect = require("inspect")

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
        robot_ore_ore        = tonumber(robot_ore_ore)
        robot_clay_ore       = tonumber(robot_clay_ore)
        robot_obsidian_ore   = tonumber(robot_obsidian_ore)
        robot_obsidian_clay  = tonumber(robot_obsidian_clay)
        robot_geode_ore      = tonumber(robot_geode_ore)
        robot_geode_obsidian = tonumber(robot_geode_obsidian)

        -- Find max ore robots:
        local max_ore = {
            --robot_ore_ore,
            robot_clay_ore,
            robot_obsidian_ore,
            robot_geode_ore
        }
        table.sort(max_ore)

        -- Insert blueprint:
        table.insert(blueprints, {
            robot_ore_ore        = robot_ore_ore,
            robot_clay_ore       = robot_clay_ore,
            robot_obsidian_ore   = robot_obsidian_ore,
            robot_obsidian_clay  = robot_obsidian_clay,
            robot_geode_ore      = robot_geode_ore,
            robot_geode_obsidian = robot_geode_obsidian,
            max_ore_robots       = max_ore[#max_ore],
            max_clay_robots      = robot_obsidian_clay,
            max_obsidian_robots  = robot_geode_obsidian,
        })
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

    local can_make_all_robots = 0

    -- Check add geode robot (if we can this only action):
    if (blueprint.robot_geode_ore <= node.ore) and (blueprint.robot_geode_obsidian <= node.obsidian)
    then
        can_make_all_robots = can_make_all_robots + 1
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

        return actions
    end

    -- Check add ore robot:
    if blueprint.robot_ore_ore <= node.ore
    then
        can_make_all_robots = can_make_all_robots + 1
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
        can_make_all_robots = can_make_all_robots + 1
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
        can_make_all_robots = can_make_all_robots + 1
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

    -- Insert empty action (only if can_make_all_robots less than 4):
    if can_make_all_robots < 4
    then
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
    end

    return actions
end

local function check_robots(blueprint, node, time, max_time)
    -- Check ore robots:
    if node.robot_ore > blueprint.max_ore_robots
    then
        return true
    end

    -- Check clay robots:
    if node.robot_clay > blueprint.max_clay_robots
    then
        return true
    end

    -- Check obsidian
    if node.robot_obsidian > blueprint.max_obsidian_robots
    then
        return true
    end

    return false
end

local copy_clock_all = 0
local check_robot_clock_all = 0
local all_iteration = 0

local function make_blueprint(blueprint, max_time, start_node, time, action, geode_max)
    all_iteration = all_iteration + 1

    --start_node = start_node or {
    --    robot_ore = 1,
    --    robot_clay = 0,
    --    robot_obsidian = 0,
    --    robot_geode = 0,
    --    ore = 0,
    --    clay = 0,
    --    obsidian = 0,
    --    geode = 0,
    --}
    --time = time or 1
    --action = action or {
    --    robot_ore = 0,
    --    robot_clay = 0,
    --    robot_obsidian = 0,
    --    robot_geode = 0,
    --    ore = 0,
    --    clay = 0,
    --    obsidian = 0,
    --    geode = 0,
    --}
    --geode_max = geode_max or {geode_max = 0, first_geode_minute = 50}

    -- Check time is over:
    if time > max_time
    then
        return start_node.geode
    end

    -- If we have late and not geode robots:
    if (time >= geode_max.first_geode_minute) and start_node.robot_geode == 0
    then
        return start_node.geode
    end

    -- Add minute:
    time = time + 1
    --print(time)

    -- Make new node:
    local clock_start = os.clock()
    local node = tablex.copy(start_node)
    local clock_stop = os.clock()
    copy_clock_all = copy_clock_all + (clock_stop - clock_start)

    -- Add resources:
    add_resources(node)

    -- Perform action:
    perform_action(node, action)

    local clock_start = os.clock()
    -- If we have too many or to small robots we end:
    if check_robots(blueprint, node, time, max_time)
    then
        return node.geode
    end
    local clock_stop = os.clock()
    check_robot_clock_all = check_robot_clock_all + (clock_stop - clock_start)

    -- Generate possible action:
    local actions = generate_possible_actions(blueprint, node)
    --print("Actions:", #actions)
    for _, action in ipairs(actions)
    do
        local geode = make_blueprint(blueprint, max_time, node, time, action, geode_max)
        --print("Geode:", geode)
        --print("Geode_MAX:", geode_max.geode_max)
        if geode > geode_max.geode_max
        then
            geode_max.geode_max = geode
            if geode == 1
            then
                geode_max.first_geode_minute = time
            end
        end
    end

    return geode_max.geode_max
end

local start_clock = os.clock()

local function make_blueprints(blueprints, max_time)

    start_node = {
        robot_ore = 1,
        robot_clay = 0,
        robot_obsidian = 0,
        robot_geode = 0,
        ore = 0,
        clay = 0,
        obsidian = 0,
        geode = 0,
    }
    time = 1
    action = {
        robot_ore = 0,
        robot_clay = 0,
        robot_obsidian = 0,
        robot_geode = 0,
        ore = 0,
        clay = 0,
        obsidian = 0,
        geode = 0,
    }
    geode_max = {geode_max = 0, first_geode_minute = 50}

    for _, blueprint in ipairs(blueprints)
    do
        print("Geode_MAX:", make_blueprint(blueprint, max_time, start_node, time, action, geode_max))
        local stop_clock = os.clock()
        print("Clock", stop_clock - start_clock)
        print("Copy all", copy_clock_all)
        print("Robot clock:", check_robot_clock_all)
        print("All iteration:", all_iteration)
        os.exit(11)
    end
end

local blueprints = open_file(arg[1])

make_blueprints(blueprints, tonumber(arg[2]))