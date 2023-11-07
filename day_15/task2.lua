#!/usr/bin/env lua5.4

print("Day 15, task 2!")

local inspect = require("inspect")

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

-- Function check two ranges have common part:
local function check_is_common(x, y)
    if ((x.start >= y.start) and (x.start <= y.stop)) or
       ((x.stop  >= y.start) and (x.stop  <= y.stop)) or
       ((y.start >= x.start) and (y.start <= x.stop)) or
       ((y.stop  >= x.start) and (y.stop  <= x.stop))
    then
        return true
    else
        return false
    end
end

-- Function check two ranges is neighbors:
local function check_is_neighbors(x, y)
    if (x.stop + 1 == y.start) or
       (y.stop + 1 == x.start)
    then
        return true
    else
        return false
    end
end

-- Function reduce two ranges:
local function reduce_two_range(x, y)
    local buf = {x.start, x.stop, y.start, y.stop}
    table.sort(buf)
    buf = {start = buf[1], stop = buf[#buf]}
    return buf
end

-- Function reduction ranges:
local function reduce_ranges(ranges)
    local ranges_buf = {}

    for range_a in function() return table.remove(ranges) end
    do
        local is_reduced = false
        for i, range_b in ipairs(ranges)
        do
            if (check_is_common(range_a, range_b) or check_is_neighbors(range_a, range_b))
            then
                is_reduced = true
                table.remove(ranges, i)
                table.insert(ranges, reduce_two_range(range_a, range_b))
                break
            end
        end

        if not is_reduced
        then
            table.insert(ranges_buf, range_a)
        end
    end

    return ranges_buf
end

local function check_line(line_number, sensors)

    -- Checks sensors:
    local ranges = {}
    for _, sensor in ipairs(sensors)
    do
        local distance_to_line = math.abs(line_number - sensor.y)
        local distance_in_line = sensor.distance - distance_to_line
        if distance_in_line > 0
        then
            local start = sensor.x - distance_in_line
            local stop  = sensor.x + distance_in_line

            if start < 0
            then
                start = 0
            end

            if stop > 4000000
            then
                stop = 4000000
            end

            table.insert(ranges,{
                start = start,
                stop = stop
            })
        end
    end

    -- Do reduction:
    ranges = reduce_ranges(ranges)

    -- If have 2 reduction, we print answer:
    if #ranges == 2
    then
        local x
        local y = line_number
        if ranges[2].stop + 1 > ranges[1].stop + 1
        then
            x = ranges[1].stop + 1
        else
            x = ranges[2].stop + 1
        end

        print(x, y, 4000000*x+y)
    end
end

local sensors, _ = open_file(arg[1])

for i = 1, 4000000, 1
do
    check_line(i, sensors)
end