-- DoomScroller Circadian Engine for Rainmeter
-- Clean ASCII text engine with Action-Oriented Biohacking Guidance

local Milestones = {
    { hour = 2.0,  title = "Sueno Profundo", category = "SUENO", desc = "Reparacion celular profunda. Mantener habitacion oscura y fresca para optima regeneracion.", color = "140,120,255" },
    { hour = 4.3,  title = "Temp. Corporal Minima", category = "SUENO", desc = "Punto termico mas bajo del dia. Evitar despertares bruscos y mantener abrigo estable.", color = "80,180,255" },
    { hour = 6.0,  title = "Secrecion de Cortisol", category = "ALERTA", desc = "Elevacion paulatina de alerta. Momento ideal para recibir luz solar natural directa.", color = "255,180,60" },
    { hour = 7.5,  title = "Cese de Melatonina", category = "ALERTA", desc = "Glandula pineal inactiva ante la luz. Exponerse a luz brillante matutina.", color = "255,215,0" },
    { hour = 8.5,  title = "Pico Cortisol Matutino", category = "ALERTA", desc = "CAR vigoroso. Excelente momento para hidratarse y postergar el cafe 90 minutos.", color = "255,140,0" },
    { hour = 9.0,  title = "Pico de Testosterona", category = "FISICO", desc = "Pico androgenico diario. Ideal para tareas de alta determinacion o entreno intenso.", color = "255,80,80" },
    { hour = 10.0, title = "Maxima Alerta y Foco", category = "ALERTA", desc = "Pico de rendimiento cognitivo. Enfocate en trabajo profundo y decisiones complejas.", color = "0,230,255" },
    { hour = 12.0, title = "Pico Metabolico", category = "METABOLISMO", desc = "Sensibilidad maxima a insulina. Ventana ideal para la comida principal del dia.", color = "0,230,120" },
    { hour = 14.5, title = "Coordinacion Motora", category = "FISICO", desc = "Reflejos y espacio tridimensional en cima. Gran momento para deportes de precision.", color = "200,100,255" },
    { hour = 15.5, title = "Eficiencia Cardiovascular", category = "FISICO", desc = "Fuerza muscular y vasos elasticos. Ventana perfecta para gimnasio o cardio exigente.", color = "255,60,100" },
    { hour = 17.0, title = "Eficiencia Pulmonar", category = "FISICO", desc = "Maxima capacidad VO2. Ideal para sesiones de alta intensidad (HIIT) o carrera.", color = "0,200,200" },
    { hour = 18.5, title = "Presion y Temp. Maximas", category = "METABOLISMO", desc = "Cima termica diaria. Comienza la desaceleracion; evita entrenar muy tarde.", color = "255,120,60" },
    { hour = 21.0, title = "Inicio de Melatonina", category = "SUENO", desc = "Glandula pineal activa. Bloquea luces azules artificiales y atenua las luces.", color = "120,100,255" },
    { hour = 22.3, title = "Calma Digestiva Nocturna", category = "SUENO", desc = "Intestino ralentiza motilidad. Evita cenar o consumir alimentos pesados.", color = "160,120,240" },
    { hour = 23.5, title = "Pico Hormona Crecimiento", category = "SUENO", desc = "Sintesis de GH en su cima. Desconecta pantallas y descansa para regeneracion.", color = "200,80,255" }
}

local function isBetween(val, startHour, endHour)
    if startHour < endHour then
        return val >= startHour and val <= endHour
    else
        return val >= startHour or val <= endHour
    end
end

local function calculateHormones(currentTime, wakeTime, sleepTime)
    local o = (currentTime + 24) % 24
    local q = wakeTime or 7.0
    local A = sleepTime or 23.0

    -- Melatonina
    local melatonin = 2
    local sleepDur = A > q and (24 - A + q) or (q - A)
    local sleepMid = (A + sleepDur / 2) % 24
    local melStart = (A - 2 + 24) % 24
    local melEnd = (q + 1) % 24

    if isBetween(o, melStart, melEnd) then
        local dist = math.abs(o - sleepMid)
        if dist > 12 then dist = 24 - dist end
        local fl = sleepDur / 1.5
        melatonin = 5 + 90 * math.exp(-((dist / fl) ^ 2))
    else
        local dist = (o - q + 24) % 24
        if dist < 4 then
            melatonin = 20 * (1 - dist / 4) + 2
        else
            melatonin = 2
        end
    end

    -- Cortisol
    local cortisol = 5
    local wakePlus = (q + 0.5) % 24
    local sleepPlus = (A + 1.5) % 24
    if o >= wakePlus or o <= sleepPlus then
        if o >= wakePlus then
            local range = (sleepPlus - wakePlus + 24) % 24
            local frac = range > 0 and ((o - wakePlus) / range) or 0
            cortisol = 8 + 87 * math.exp(-3 * frac)
            if o >= 13 and o <= 16 then
                cortisol = cortisol + math.sin((o - 13) / 3 * math.pi) * 15
            end
        else
            local range = (wakePlus - sleepPlus + 24) % 24
            local frac = range > 0 and (((o - sleepPlus + 24) % 24) / range) or 0
            cortisol = 8 + 87 * (frac ^ 3)
        end
    else
        cortisol = 5
    end
    cortisol = math.max(5, math.min(100, cortisol))

    -- Adenosina (Presion de sueno)
    local adenosine = 0
    local awakeDur = (A - q + 24) % 24
    local sleepDur2 = 24 - awakeDur
    if isBetween(o, q, A) then
        local dist = (o - q + 24) % 24
        adenosine = 5 + 93 * (1 - math.exp(-2.5 * (dist / (awakeDur > 0 and awakeDur or 1))))
    else
        local dist = (o - A + 24) % 24
        adenosine = 98 * math.exp(-3.5 * (dist / (sleepDur2 > 0 and sleepDur2 or 1))) + 2
    end
    adenosine = math.max(2, math.min(100, adenosine))

    -- Hormona de crecimiento (GH)
    local growthHormone = 2
    local ghStart = (A + 0.5) % 24
    local ghEnd = (A + 3.5) % 24
    if isBetween(o, ghStart, ghEnd) then
        local dist = (o - ghStart + 24) % 24
        if dist < 1 then
            growthHormone = 2 + 93 * dist
        else
            growthHormone = 95 * math.exp(-1.5 * (dist - 1)) + 2
        end
    elseif o >= 14 and o <= 15 then
        growthHormone = 2 + 10 * math.sin((o - 14) * math.pi)
    else
        growthHormone = 2
    end
    growthHormone = math.max(2, math.min(100, growthHormone))

    -- Temperatura y Sensibilidad a la Insulina
    local bodyTemp = 50 + 40 * math.sin((o - 11) / 24 * 2 * math.pi)
    local insulinSensitivity = 50 + 45 * math.sin((o - 4) / 24 * 2 * math.pi)

    return math.floor(melatonin + 0.5),
           math.floor(cortisol + 0.5),
           math.floor(adenosine + 0.5),
           math.floor(growthHormone + 0.5),
           math.floor(bodyTemp + 0.5),
           math.floor(insulinSensitivity + 0.5)
end

function Initialize()
    Update()
end

function Update()
    local dateTable = os.date("*t")
    local currentHour = dateTable.hour + (dateTable.min / 60) + (dateTable.sec / 3600)

    local wakeTime = tonumber(SKIN:GetVariable("WakeTime", "7.0")) or 7.0
    local sleepTime = tonumber(SKIN:GetVariable("SleepTime", "23.0")) or 23.0

    local mel, cort, adeno, gh, temp, ins = calculateHormones(currentHour, wakeTime, sleepTime)

    -- Determinar Hito Actual e Hito Siguiente
    local currentMilestone = Milestones[#Milestones]
    local nextMilestone = Milestones[1]

    for i = 1, #Milestones do
        if currentHour >= Milestones[i].hour then
            currentMilestone = Milestones[i]
            nextMilestone = Milestones[(i % #Milestones) + 1]
        end
    end

    -- Tiempo restante para el siguiente hito
    local diffHours = (nextMilestone.hour - currentHour + 24) % 24
    local diffMinutes = math.floor(diffHours * 60)
    local remHours = math.floor(diffMinutes / 60)
    local remMins = diffMinutes % 60
    local timeToNextStr = ""
    if remHours > 0 then
        timeToNextStr = string.format("%dh %dm", remHours, remMins)
    else
        timeToNextStr = string.format("%dm", remMins)
    end

    -- Actualizar Variables en Rainmeter
    SKIN:Bang("!SetVariable", "CircadianPhaseTitle", currentMilestone.title)
    SKIN:Bang("!SetVariable", "CircadianPhaseCategory", currentMilestone.category)
    SKIN:Bang("!SetVariable", "CircadianPhaseDesc", currentMilestone.desc)
    SKIN:Bang("!SetVariable", "CircadianPhaseColor", currentMilestone.color)
    SKIN:Bang("!SetVariable", "NextMilestoneTitle", nextMilestone.title)
    SKIN:Bang("!SetVariable", "MinutesToNext", timeToNextStr)

    SKIN:Bang("!SetVariable", "MelatoninPct", tostring(mel))
    SKIN:Bang("!SetVariable", "CortisolPct", tostring(cort))
    SKIN:Bang("!SetVariable", "AdenosinePct", tostring(adeno))
    SKIN:Bang("!SetVariable", "GrowthHormonePct", tostring(gh))
    SKIN:Bang("!SetVariable", "BodyTempPct", tostring(temp))
    SKIN:Bang("!SetVariable", "InsulinPct", tostring(ins))

    SKIN:Bang("!UpdateMeter", "*")
    SKIN:Bang("!Redraw")

    return currentMilestone.title
end
