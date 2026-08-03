-- DoomScroller Cosmic Moon Engine for Rainmeter
-- High-Precision Moon Phase & Dynamic Sphere Renderer

function getMoonPhaseData()
    local t = os.date("!*t")
    if not t then
        t = {year = 2026, month = 8, day = 3, hour = 13, min = 30}
    end

    local year = t.year
    local month = t.month
    local day = t.day
    local hour = t.hour + (t.min / 60.0)

    if month <= 2 then
        year = year - 1
        month = month + 12
    end

    local A = math.floor(year / 100)
    local B = 2 - A + math.floor(A / 4)
    local JD = math.floor(365.25 * (year + 4716)) + math.floor(30.6001 * (month + 1)) + day + (hour / 24.0) + B - 1524.5

    -- Synodic month reference (New Moon on Jan 6, 2000 18:14 UTC -> JD 2451549.26)
    local daysSinceRef = JD - 2451549.26
    local newMoons = daysSinceRef / 29.53058770576
    local cyclePos = (newMoons - math.floor(newMoons)) * 29.53058770576
    local phaseRatio = cyclePos / 29.53058770576

    local illumination = math.floor(((1 - math.cos(phaseRatio * 2 * math.pi)) / 2 * 100) + 0.5)

    local name = "Luna Nueva"
    local nextName = "Cuarto Creciente"
    local nextDays = 7

    if cyclePos < 1.84566 then
        name = "Luna Nueva"
        nextName = "Cuarto Creciente"
        nextDays = math.floor((7.3826 - cyclePos) + 0.5)
    elseif cyclePos < 5.53699 then
        name = "Creciente Concava"
        nextName = "Cuarto Creciente"
        nextDays = math.floor((7.3826 - cyclePos) + 0.5)
    elseif cyclePos < 9.22831 then
        name = "Cuarto Creciente"
        nextName = "Luna Llena"
        nextDays = math.floor((14.7653 - cyclePos) + 0.5)
    elseif cyclePos < 12.91963 then
        name = "Creciente Convexa"
        nextName = "Luna Llena"
        nextDays = math.floor((14.7653 - cyclePos) + 0.5)
    elseif cyclePos < 16.61096 then
        name = "Luna Llena"
        nextName = "Cuarto Menguante"
        nextDays = math.floor((22.1479 - cyclePos) + 0.5)
    elseif cyclePos < 20.30228 then
        name = "Menguante Convexa"
        nextName = "Cuarto Menguante"
        nextDays = math.floor((22.1479 - cyclePos) + 0.5)
    elseif cyclePos < 23.99361 then
        name = "Cuarto Menguante"
        nextName = "Luna Nueva"
        nextDays = math.floor((29.5306 - cyclePos) + 0.5)
    elseif cyclePos < 27.68493 then
        name = "Menguante Concava"
        nextName = "Luna Nueva"
        nextDays = math.floor((29.5306 - cyclePos) + 0.5)
    else
        name = "Luna Nueva"
        nextName = "Cuarto Creciente"
        nextDays = math.floor((36.9132 - cyclePos) + 0.5)
    end

    if nextDays <= 0 then nextDays = 1 end
    local daysText = nextDays == 1 and "1 dia" or (tostring(nextDays) .. " dias")

    return name, tostring(illumination) .. "%", nextName, daysText, illumination
end

function Initialize()
    Update()
end

function Update()
    local name, illumStr, nextName, nextDays, illumPct = getMoonPhaseData()

    SKIN:Bang("!SetVariable", "MoonPhaseName", name)
    SKIN:Bang("!SetVariable", "MoonIllumination", illumStr)
    SKIN:Bang("!SetVariable", "MoonNextName", nextName)
    SKIN:Bang("!SetVariable", "MoonNextDays", nextDays)
    SKIN:Bang("!SetVariable", "MoonIllumPct", tostring(illumPct or 50))

    SKIN:Bang("!UpdateMeter", "*")
    SKIN:Bang("!Redraw")

    return name
end
