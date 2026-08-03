-- DoomScroller Weather Engine for Caracas (Open-Meteo Integration)
-- Provides live weather for Today & Tomorrow with high legibility and instant fallback.

local weatherCodeMap = {
    [0] = "Soleado / Despejado",
    [1] = "Mayormente Despejado",
    [2] = "Parcialmente Nublado",
    [3] = "Nublado",
    [45] = "Niebla en El Avila",
    [48] = "Niebla Densa",
    [51] = "Llovizna Ligera",
    [53] = "Llovizna Moderada",
    [55] = "Llovizna Densa",
    [61] = "Lluvia Ligera",
    [63] = "Lluvia Moderada",
    [65] = "Lluvia Torrencial",
    [80] = "Chubascos Dispersos",
    [81] = "Chubascos Fuertes",
    [82] = "Chubascos Violentos",
    [95] = "Tormenta Electrica",
    [96] = "Tormenta con Granizo",
    [99] = "Tormenta Severa"
}

local function getWeatherDesc(code)
    code = tonumber(code) or 2
    return weatherCodeMap[code] or "Parcialmente Nublado"
end

function Initialize()
    SetFallbackData()
    Update()
end

function SetFallbackData()
    SKIN:Bang("!SetVariable", "WeatherTempCurrent", "25")
    SKIN:Bang("!SetVariable", "WeatherFeelsLike", "26")
    SKIN:Bang("!SetVariable", "WeatherHumidity", "68")
    SKIN:Bang("!SetVariable", "WeatherWind", "8.5")
    SKIN:Bang("!SetVariable", "WeatherConditionToday", "Parcialmente Nublado")
    SKIN:Bang("!SetVariable", "WeatherMaxToday", "29")
    SKIN:Bang("!SetVariable", "WeatherMinToday", "19")
    SKIN:Bang("!SetVariable", "WeatherRainToday", "35")
    
    SKIN:Bang("!SetVariable", "WeatherConditionTomorrow", "Chubascos Dispersos")
    SKIN:Bang("!SetVariable", "WeatherMaxTomorrow", "28")
    SKIN:Bang("!SetVariable", "WeatherMinTomorrow", "20")
    SKIN:Bang("!SetVariable", "WeatherRainTomorrow", "55")
    SKIN:Bang("!SetVariable", "WeatherLastUpdate", "Caracas (Modo Offline)")
end

function ProcessWeather()
    local rawWeb = SKIN:GetMeasure("MeasureWeatherWeb"):GetStringValue()
    if not rawWeb or rawWeb == "" then
        return
    end

    local currentBlock = string.match(rawWeb, '"current"%s*:%s*{(.-)}')
    local dailyBlock = string.match(rawWeb, '"daily"%s*:%s*{(.-)}')

    if currentBlock then
        local temp = string.match(currentBlock, '"temperature_2m"%s*:%s*([%d%.%-]+)')
        local humidity = string.match(currentBlock, '"relative_humidity_2m"%s*:%s*(%d+)')
        local feelsLike = string.match(currentBlock, '"apparent_temperature"%s*:%s*([%d%.%-]+)')
        local code = string.match(currentBlock, '"weather_code"%s*:%s*(%d+)')
        local wind = string.match(currentBlock, '"wind_speed_10m"%s*:%s*([%d%.%-]+)')

        if temp then
            local tempInt = tostring(math.floor(tonumber(temp) + 0.5))
            SKIN:Bang("!SetVariable", "WeatherTempCurrent", tempInt)
        end
        if feelsLike then
            local feelsInt = tostring(math.floor(tonumber(feelsLike) + 0.5))
            SKIN:Bang("!SetVariable", "WeatherFeelsLike", feelsInt)
        end
        if humidity then
            SKIN:Bang("!SetVariable", "WeatherHumidity", humidity)
        end
        if wind then
            local windVal = string.format("%.1f", tonumber(wind) or 8.0)
            SKIN:Bang("!SetVariable", "WeatherWind", windVal)
        end
        if code then
            SKIN:Bang("!SetVariable", "WeatherConditionToday", getWeatherDesc(code))
        end
    end

    if dailyBlock then
        local codesTod, codesTom = string.match(dailyBlock, '"weather_code"%s*:%s*%[%s*(%d+)%s*,%s*(%d+)%s*%]')
        local maxTod, maxTom = string.match(dailyBlock, '"temperature_2m_max"%s*:%s*%[%s*([%d%.%-]+)%s*,%s*([%d%.%-]+)%s*%]')
        local minTod, minTom = string.match(dailyBlock, '"temperature_2m_min"%s*:%s*%[%s*([%d%.%-]+)%s*,%s*([%d%.%-]+)%s*%]')
        local rainTod, rainTom = string.match(dailyBlock, '"precipitation_probability_max"%s*:%s*%[%s*(%d+)%s*,%s*(%d+)%s*%]')

        if maxTod then SKIN:Bang("!SetVariable", "WeatherMaxToday", tostring(math.floor(tonumber(maxTod) + 0.5))) end
        if maxTom then SKIN:Bang("!SetVariable", "WeatherMaxTomorrow", tostring(math.floor(tonumber(maxTom) + 0.5))) end
        if minTod then SKIN:Bang("!SetVariable", "WeatherMinToday", tostring(math.floor(tonumber(minTod) + 0.5))) end
        if minTom then SKIN:Bang("!SetVariable", "WeatherMinTomorrow", tostring(math.floor(tonumber(minTom) + 0.5))) end
        if rainTod then SKIN:Bang("!SetVariable", "WeatherRainToday", rainTod) end
        if rainTom then SKIN:Bang("!SetVariable", "WeatherRainTomorrow", rainTom) end
        if codesTom then SKIN:Bang("!SetVariable", "WeatherConditionTomorrow", getWeatherDesc(codesTom)) end
    end

    local timeNow = os.date("%H:%M")
    SKIN:Bang("!SetVariable", "WeatherLastUpdate", "En vivo " .. timeNow)

    SKIN:Bang("!UpdateMeter", "*")
    SKIN:Bang("!Redraw")
end

function Update()
    return "Weather Active"
end
