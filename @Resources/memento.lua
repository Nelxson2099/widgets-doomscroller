-- DoomScroller Memento Mori Calculation Engine for Rainmeter
-- Calculates Days Lived, Weeks Lived, and Life Percentage accurately

function Initialize()
    updateCalculations()
end

function Update()
    updateCalculations()
    return daysLived
end

function formatNumber(amount)
    local formatted = tostring(amount)
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return formatted
end

function updateCalculations()
    local birthStr = SKIN:GetVariable('BirthDate', '2000-01-01')
    local targetAge = tonumber(SKIN:GetVariable('TargetAge', '80')) or 80
    
    local y, m, d = birthStr:match("(%d%d%d%d)%-(%d%d)%-(%d%d)")
    
    local birthTimeStamp = 0
    if y and m and d then
        local birthTable = {
            year = tonumber(y),
            month = tonumber(m),
            day = tonumber(d),
            hour = 0,
            min = 0,
            sec = 0
        }
        birthTimeStamp = os.time(birthTable)
    else
        birthTimeStamp = os.time()
    end
    
    local now = os.time()
    local diffSeconds = os.difftime(now, birthTimeStamp)
    if diffSeconds < 0 then diffSeconds = 0 end
    
    daysLived = math.floor(diffSeconds / 86400)
    weeksLived = math.floor(daysLived / 7)
    
    local totalDaysTarget = targetAge * 365.2425
    local lifePct = (daysLived / totalDaysTarget) * 100
    if lifePct > 100 then lifePct = 100 end
    if lifePct < 0 then lifePct = 0 end
    
    -- Horas restantes para el año 2100 (2100-01-01 00:00:00)
    local target2100Table = {
        year = 2100,
        month = 1,
        day = 1,
        hour = 0,
        min = 0,
        sec = 0
    }
    local target2100TimeStamp = os.time(target2100Table)
    local diff2100Seconds = os.difftime(target2100TimeStamp, now)
    if diff2100Seconds < 0 then diff2100Seconds = 0 end
    local hoursTo2100 = math.floor(diff2100Seconds / 3600)
    
    -- Día del año y total de días del año
    local dateTable = os.date("*t", now)
    local currentYear = dateTable.year
    local dayOfYear = dateTable.yday
    local isLeap = (currentYear % 4 == 0 and currentYear % 100 ~= 0) or (currentYear % 400 == 0)
    local totalDaysInYear = isLeap and 366 or 365
    
    -- Formatear números con comas (ej. 9,542)
    local daysFormatted = formatNumber(daysLived)
    local weeksFormatted = formatNumber(weeksLived)
    local hours2100Formatted = formatNumber(hoursTo2100)
    local pctFormatted = string.format("%.1f%%", lifePct)
    local rawPct = string.format("%.4f", lifePct / 100)

    SKIN:Bang('!SetVariable', 'DaysLivedFormatted', daysFormatted)
    SKIN:Bang('!SetVariable', 'WeeksLivedFormatted', weeksFormatted)
    SKIN:Bang('!SetVariable', 'HoursTo2100Formatted', hours2100Formatted)
    SKIN:Bang('!SetVariable', 'DayOfYear', tostring(dayOfYear))
    SKIN:Bang('!SetVariable', 'TotalDaysInYear', tostring(totalDaysInYear))
    SKIN:Bang('!SetVariable', 'LifePctFormatted', pctFormatted)
    SKIN:Bang('!SetVariable', 'LifePctRaw', rawPct)
end
