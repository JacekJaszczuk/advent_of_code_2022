#!/usr/bin/env lua5.4

print("Day 15, task 1!")

local function open_file(filename)
    local sensors = {}
    local beacons = {}
    local pattern = "Sensor at x=(%-?%d+), y=(%-?%d+): closest beacon is at x=(%-?%d+), y=(%-?%d+)"

    local f = io.open(filename)
    for line in f:lines()
    do
        local sx, sy, bx, by = line:match(pattern)
        sx = tonumber(sx)
        sy = tonumber(sy)
        bx = tonumber(bx)
        by = tonumber(by)

        -- Add sensor:
        local sensor = {
            x = sx,
            y = sy,
            distance = math.abs(sx - bx) + math.abs(sy - by),
        }

        table.insert(sensors, sensor)

        -- Add beacon:
        local beacon = {
            x = bx,
            y = by,
        }
        local beacon_key = string.format("%010d%010d", beacon.x, beacon.y)
        beacons[beacon_key] = beacon
    end
    f:close()

    return sensors, beacons
end

local function check_line(line_number, sensors, beacons)
    print(string.format("Check line %d", line_number))
    local min_x = math.maxinteger
    local max_x = math.mininteger
    local add = 1

    -- Checks sensors:
    for _, sensor in ipairs(sensors)
    do
        local distance_to_line = math.abs(line_number - sensor.y)
        local distance_in_line = sensor.distance - distance_to_line
        if distance_in_line > 0
        then
            local now_min_x = sensor.x - distance_in_line
            local now_max_x = sensor.x + distance_in_line

            if now_min_x < min_x
            then
                min_x = now_min_x
            end

            if now_max_x > max_x
            then
                max_x = now_max_x
            end
        end
    end

    -- Check beacon in arrangment:
    for _, beacon in pairs(beacons)
    do
        if beacon.y == line_number
        then
            if (beacon.x > min_x) and (beacon.x < max_x)
            then
                add = add - 1
            end
        end
    end

    print(max_x - min_x + add)
end

local sensors, beacons = open_file(arg[1])
check_line(tonumber(arg[2]), sensors, beacons)