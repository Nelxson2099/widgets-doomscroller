-- DoomScroller Calendar Engine for Rainmeter
-- Handles date math, month grid generation, Spanish localization, and month navigation.

local monthsUpper = {
    "ENERO", "FEBRERO", "MARZO", "ABRIL", "MAYO", "JUNIO",
    "JULIO", "AGOSTO", "SEPTIEMBRE", "OCTUBRE", "NOVIEMBRE", "DICIEMBRE"
}

local monthsTitle = {
    "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",
    "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"
}

local weekdaysUpper = {
    [1] = "DOMINGO", [2] = "LUNES", [3] = "MARTES",
    [4] = "MIERCOLES", [5] = "JUEVES", [6] = "VIERNES", [7] = "SABADO"
}

local viewYear = nil
local viewMonth = nil

function Initialize()
    local now = os.date("*t")
    viewYear = now.year
    viewMonth = now.month
    calculate()
end

function Update()
    calculate()
    return viewMonth
end

function PrevMonth()
    viewMonth = viewMonth - 1
    if viewMonth < 1 then
        viewMonth = 12
        viewYear = viewYear - 1
    end
    calculate()
    SKIN:Bang('!Redraw')
end

function NextMonth()
    viewMonth = viewMonth + 1
    if viewMonth > 12 then
        viewMonth = 1
        viewYear = viewYear + 1
    end
    calculate()
    SKIN:Bang('!Redraw')
end

function ResetToday()
    local now = os.date("*t")
    viewYear = now.year
    viewMonth = now.month
    calculate()
    SKIN:Bang('!Redraw')
end

function isLeapYear(year)
    return (year % 4 == 0 and year % 100 ~= 0) or (year % 400 == 0)
end

function getDaysInMonth(year, month)
    local days = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
    if month == 2 and isLeapYear(year) then
        return 29
    end
    return days[month]
end

function calculate()
    local now = os.date("*t")
    local realYear = now.year
    local realMonth = now.month
    local realDay = now.day
    local realWday = now.wday -- 1=Sun, 2=Mon...7=Sat

    if not viewYear or not viewMonth then
        viewYear = realYear
        viewMonth = realMonth
    end

    local isCurrentMonthView = (viewYear == realYear and viewMonth == realMonth)

    -- Primary Titles
    local headerTitle = monthsUpper[viewMonth] .. " " .. viewYear
    local heroDayNum = string.format("%02d", realDay)
    local heroDayName = weekdaysUpper[realWday]
    local heroSubText = monthsTitle[realMonth] .. " " .. realYear .. " | Sem. " .. os.date("%V")

    SKIN:Bang('!SetVariable', 'CalHeaderTitle', headerTitle)
    SKIN:Bang('!SetVariable', 'CalHeroDayNum', heroDayNum)
    SKIN:Bang('!SetVariable', 'CalHeroDayName', heroDayName)
    SKIN:Bang('!SetVariable', 'CalHeroSubText', heroSubText)

    -- Calculate first day of viewMonth (1=Mon, 7=Sun)
    local firstTime = os.time({year = viewYear, month = viewMonth, day = 1, hour = 12})
    local firstDate = os.date("*t", firstTime)
    local startWday = (firstDate.wday == 1) and 7 or (firstDate.wday - 1)

    local totalDaysInView = getDaysInMonth(viewYear, viewMonth)

    -- Prev month days
    local prevYear = viewYear
    local prevMonth = viewMonth - 1
    if prevMonth < 1 then
        prevMonth = 12
        prevYear = viewYear - 1
    end
    local totalDaysInPrev = getDaysInMonth(prevYear, prevMonth)

    local highlightSlot = -1

    for slot = 1, 42 do
        local dayNum = 0
        local isCurrentMonthCell = false

        if slot < startWday then
            -- Prev month
            dayNum = totalDaysInPrev - (startWday - 1 - slot)
            isCurrentMonthCell = false
        elseif slot >= startWday and slot < (startWday + totalDaysInView) then
            -- Current view month
            dayNum = slot - startWday + 1
            isCurrentMonthCell = true
            if isCurrentMonthView and dayNum == realDay then
                highlightSlot = slot
            end
        else
            -- Next month
            dayNum = slot - (startWday + totalDaysInView - 1)
            isCurrentMonthCell = false
        end

        local fontColor = isCurrentMonthCell and "#ColorTextPrimary#" or "#ColorTextMuted#"
        local fontWeight = isCurrentMonthCell and "600" or "400"
        
        if isCurrentMonthView and dayNum == realDay and isCurrentMonthCell then
            fontColor = "#ColorAccent#"
            fontWeight = "800"
        end

        SKIN:Bang('!SetVariable', 'DayVal' .. slot, tostring(dayNum))
        SKIN:Bang('!SetVariable', 'DayColor' .. slot, fontColor)
        SKIN:Bang('!SetVariable', 'DayWeight' .. slot, fontWeight)
    end

    -- Highlight Pill coordinates
    if highlightSlot > 0 then
        local col = (highlightSlot - 1) % 7
        local row = math.floor((highlightSlot - 1) / 7)
        local posX = 20 + col * 36
        local posY = 158 + row * 24
        SKIN:Bang('!SetVariable', 'HighlightX', tostring(posX))
        SKIN:Bang('!SetVariable', 'HighlightY', tostring(posY))
        SKIN:Bang('!SetVariable', 'HighlightAlpha', "255")
    else
        SKIN:Bang('!SetVariable', 'HighlightAlpha', "0")
    end
end
