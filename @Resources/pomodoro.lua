-- DoomScroller Pomodoro Focus Timer Engine for Rainmeter
-- Handles Work / Break timers, sessions tracking, and smooth progress calculation

local workDuration = 25 * 60     -- 25 min default
local shortBreakDuration = 5 * 60 -- 5 min default
local longBreakDuration = 15 * 60 -- 15 min default
local targetSessionsBeforeLongBreak = 4

local isRunning = false
local currentMode = "Work" -- "Work", "Break", "LongBreak"
local timeRemaining = workDuration
local completedSessions = 0

function Initialize()
    updateUI()
end

function Update()
    if isRunning then
        if timeRemaining > 0 then
            timeRemaining = timeRemaining - 1
        else
            -- Timer finished
            if currentMode == "Work" then
                completedSessions = completedSessions + 1
                if completedSessions % targetSessionsBeforeLongBreak == 0 then
                    currentMode = "LongBreak"
                    timeRemaining = longBreakDuration
                else
                    currentMode = "Break"
                    timeRemaining = shortBreakDuration
                end
                SKIN:Bang('!PlaySound', 'SystemAsterisk')
            else
                currentMode = "Work"
                timeRemaining = workDuration
                SKIN:Bang('!PlaySound', 'SystemExclamation')
            end
        end
    end
    updateUI()
    return timeRemaining
end

function ToggleTimer()
    isRunning = not isRunning
    updateUI()
end

function ResetTimer()
    isRunning = false
    currentMode = "Work"
    timeRemaining = workDuration
    updateUI()
end

function SkipPhase()
    isRunning = false
    if currentMode == "Work" then
        completedSessions = completedSessions + 1
        currentMode = "Break"
        timeRemaining = shortBreakDuration
    else
        currentMode = "Work"
        timeRemaining = workDuration
    end
    updateUI()
end

function SetMode25_5()
    workDuration = 25 * 60
    shortBreakDuration = 5 * 60
    ResetTimer()
end

function SetMode50_10()
    workDuration = 50 * 60
    shortBreakDuration = 10 * 60
    ResetTimer()
end

function updateUI()
    local minutes = math.floor(timeRemaining / 60)
    local seconds = timeRemaining % 60
    local timerFormatted = string.format("%02d:%02d", minutes, seconds)
    
    local totalDuration = workDuration
    if currentMode == "Break" then
        totalDuration = shortBreakDuration
    elseif currentMode == "LongBreak" then
        totalDuration = longBreakDuration
    end
    
    local progressRaw = 1.0 - (timeRemaining / totalDuration)
    if progressRaw < 0 then progressRaw = 0 end
    if progressRaw > 1 then progressRaw = 1 end
    local progressRawStr = string.format("%.4f", progressRaw)
    
    local stateText = "ENFOQUE PROFUNDO"
    if not isRunning then
        stateText = "PAUSADO"
    elseif currentMode == "Break" then
        stateText = "DESCANSO CORTO"
    elseif currentMode == "LongBreak" then
        stateText = "DESCANSO LARGO"
    end

    local btnText = isRunning and "PAUSA" or "PLAY"

    SKIN:Bang('!SetVariable', 'PomoTimerFormatted', timerFormatted)
    SKIN:Bang('!SetVariable', 'PomoStateText', stateText)
    SKIN:Bang('!SetVariable', 'PomoBtnText', btnText)
    SKIN:Bang('!SetVariable', 'PomoSessions', tostring(completedSessions))
    SKIN:Bang('!SetVariable', 'PomoProgressRaw', progressRawStr)
    SKIN:Bang('!SetVariable', 'PomoIsRunning', isRunning and "1" or "0")
end
