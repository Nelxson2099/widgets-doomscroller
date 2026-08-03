-- DoomScroller Habits Calculation & Styling Engine for Rainmeter

function Initialize()
    updateHabits()
end

function Update()
    updateHabits()
    return count
end

function updateHabits()
    local h1 = tonumber(SKIN:GetVariable('Habit1', '0')) or 0
    local h2 = tonumber(SKIN:GetVariable('Habit2', '0')) or 0
    local h3 = tonumber(SKIN:GetVariable('Habit3', '0')) or 0
    local h4 = tonumber(SKIN:GetVariable('Habit4', '0')) or 0
    local h5 = tonumber(SKIN:GetVariable('Habit5', '0')) or 0
    
    local total = h1 + h2 + h3 + h4 + h5
    local pct = math.floor((total / 5) * 100)
    
    SKIN:Bang('!SetVariable', 'HabitsCompleted', tostring(total))
    SKIN:Bang('!SetVariable', 'HabitsPct', tostring(pct) .. '%')
    SKIN:Bang('!SetVariable', 'HabitsPctRaw', string.format("%.2f", total / 5))
    
    applyHabitStyle(1, h1)
    applyHabitStyle(2, h2)
    applyHabitStyle(3, h3)
    applyHabitStyle(4, h4)
    applyHabitStyle(5, h5)
end

function applyHabitStyle(index, isDone)
    local cardBg = SKIN:GetVariable('ColorCardBg', '22,26,36,180')
    local border = SKIN:GetVariable('ColorBorder', '255,255,255,30')
    local accent = SKIN:GetVariable('ColorAccent', '255,160,0,255')
    local textPrimary = SKIN:GetVariable('ColorTextPrimary', '245,247,250,255')
    local textSecondary = SKIN:GetVariable('ColorTextSecondary', '140,148,165,255')
    local textMuted = SKIN:GetVariable('ColorTextMuted', '90,98,115,255')
    
    local y = 58 + (index - 1) * 40
    
    if isDone == 1 then
        SKIN:Bang('!SetOption', 'MeterHabit' .. index .. 'Box', 'Shape', 'Rectangle 20,' .. y .. ',300,34,6 | Fill Color 40,30,10,220 | Stroke Color ' .. accent .. ' | StrokeWidth 1')
        SKIN:Bang('!SetOption', 'MeterHabit' .. index .. 'Icon', 'Text', '[X]')
        SKIN:Bang('!SetOption', 'MeterHabit' .. index .. 'Icon', 'FontColor', accent)
        SKIN:Bang('!SetOption', 'MeterHabit' .. index .. 'Text', 'FontColor', textPrimary)
        SKIN:Bang('!SetOption', 'MeterHabit' .. index .. 'Text', 'FontWeight', '700')
    else
        SKIN:Bang('!SetOption', 'MeterHabit' .. index .. 'Box', 'Shape', 'Rectangle 20,' .. y .. ',300,34,6 | Fill Color ' .. cardBg .. ' | Stroke Color ' .. border .. ' | StrokeWidth 0.5')
        SKIN:Bang('!SetOption', 'MeterHabit' .. index .. 'Icon', 'Text', '[  ]')
        SKIN:Bang('!SetOption', 'MeterHabit' .. index .. 'Icon', 'FontColor', textMuted)
        SKIN:Bang('!SetOption', 'MeterHabit' .. index .. 'Text', 'FontColor', textSecondary)
        SKIN:Bang('!SetOption', 'MeterHabit' .. index .. 'Text', 'FontWeight', '500')
    end
end
