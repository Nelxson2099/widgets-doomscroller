-- DoomScroller RGB Chroma Engine for Rainmeter

local hue = 0

function Initialize()
end

function Update()
    local isRgb = SKIN:GetVariable('RgbMode', '0')
    if isRgb == '1' then
        hue = (hue + 2.5) % 360
        local r, g, b = hslToRgb(hue / 360, 1.0, 0.55)
        local colorStr = string.format("%d,%d,%d,255", r, g, b)
        local glowStr = string.format("%d,%d,%d,40", r, g, b)
        
        SKIN:Bang('!SetVariable', 'ColorAccent', colorStr)
        SKIN:Bang('!SetVariable', 'ColorAccentGlow', glowStr)
    end
end

function hslToRgb(h, s, l)
    local r, g, b
    if s == 0 then
        r, g, b = l, l, l
    else
        local function hue2rgb(p, q, t)
            if t < 0 then t = t + 1 end
            if t > 1 then t = t - 1 end
            if t < 1/6 then return p + (q - p) * 6 * t end
            if t < 1/2 then return q end
            if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end
            return p
        end
        local q = l < 0.5 and l * (1 + s) or l + s - l * s
        local p = 2 * l - q
        r = hue2rgb(p, q, h + 1/3)
        g = hue2rgb(p, q, h)
        b = hue2rgb(p, q, h - 1/3)
    end
    return math.floor(r * 255 + 0.5), math.floor(g * 255 + 0.5), math.floor(b * 255 + 0.5)
end
