-- DoomScroller Step Tracker Engine for Rainmeter
-- Reads local steps.json updated via phone Wi-Fi sync or local sensor bridge.

local function formatNumber(num)
    num = tonumber(num) or 0
    local formatted = tostring(num)
    while true do
        local k
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return formatted
end

function Initialize()
    Update()
end

function ProcessSteps()
    local filePath = SKIN:GetVariable("@") .. "steps.json"
    local file = io.open(filePath, "r")
    if not file then
        return
    end

    local jsonStr = file:read("*a")
    file:close()

    if not jsonStr or jsonStr == "" then
        return
    end

    local today = string.match(jsonStr, '"steps_today"%s*:%s*(%d+)')
    local week = string.match(jsonStr, '"steps_week"%s*:%s*(%d+)')
    local goal = string.match(jsonStr, '"daily_goal"%s*:%s*(%d+)')
    local cal = string.match(jsonStr, '"calories"%s*:%s*(%d+)')
    local dist = string.match(jsonStr, '"distance_km"%s*:%s*([%d%.%-]+)')
    local lastSync = string.match(jsonStr, '"last_sync"%s*:%s*"(.-)"')

    if today then
        local todayVal = tonumber(today) or 0
        SKIN:Bang("!SetVariable", "StepsToday", formatNumber(todayVal))
        
        local goalVal = tonumber(goal) or 10000
        local pct = math.floor((todayVal / goalVal) * 100 + 0.5)
        if pct > 100 then pct = 100 end
        SKIN:Bang("!SetVariable", "StepsGoalPct", tostring(pct))
    end

    if week then
        SKIN:Bang("!SetVariable", "StepsWeek", formatNumber(tonumber(week) or 0))
    end
    if goal then
        SKIN:Bang("!SetVariable", "StepsGoal", formatNumber(tonumber(goal) or 10000))
    end
    if cal then
        SKIN:Bang("!SetVariable", "StepsCalories", tostring(cal))
    end
    if dist then
        SKIN:Bang("!SetVariable", "StepsDistance", tostring(dist))
    end
    if lastSync then
        SKIN:Bang("!SetVariable", "StepsLastSync", lastSync)
    end

    SKIN:Bang("!UpdateMeter", "*")
    SKIN:Bang("!Redraw")
end

function Update()
    ProcessSteps()
    return "Steps Engine Active"
end
