--[[
VoidHub UI Library — main.lua (modern rebuild)
Features:
- Rich glass-like styling with higher transparency
- Runtime theme switching that updates existing widgets
- More themes
- Safer Button / Slider / Dropdown logic
- Same public API shape: Window, Component, Themes, Icons, Colors, Sfx
]]

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local SoundService     = game:GetService("SoundService")
local CoreGui          = game:GetService("CoreGui")
local LocalPlayer      = Players.LocalPlayer

local function rgb(r, g, b)
    return Color3.fromRGB(r, g, b)
end

local WHITE = Color3.new(1, 1, 1)

local THEMES = {
    Void = {
        Bg = rgb(10, 10, 18), BgCard = rgb(15, 15, 28), BgItem = rgb(20, 20, 36), BgHover = rgb(26, 26, 44),
        Border = rgb(42, 42, 70), BorderHi = rgb(84, 50, 145), Accent = rgb(132, 68, 235), AccentHi = rgb(168, 108, 255),
        AccentDim = rgb(72, 26, 140), AccentGlow = rgb(206, 166, 255), Green = rgb(50, 210, 112), GreenDim = rgb(22, 110, 60),
        Red = rgb(240, 78, 78), Yellow = rgb(240, 190, 48), Blue = rgb(70, 145, 255), White = WHITE,
        TextPri = WHITE, TextSec = rgb(185, 180, 215), TextMuted = rgb(104, 100, 140), Discord = rgb(88, 101, 242), DisGreen = rgb(59, 165, 93),
    },
    Midnight = {
        Bg = rgb(7, 12, 22), BgCard = rgb(11, 18, 34), BgItem = rgb(16, 24, 44), BgHover = rgb(21, 31, 56),
        Border = rgb(34, 50, 84), BorderHi = rgb(56, 96, 186), Accent = rgb(62, 122, 245), AccentHi = rgb(94, 160, 255),
        AccentDim = rgb(24, 64, 148), AccentGlow = rgb(138, 190, 255), Green = rgb(50, 210, 122), GreenDim = rgb(20, 110, 60),
        Red = rgb(228, 70, 70), Yellow = rgb(225, 180, 30), Blue = rgb(70, 145, 255), White = WHITE,
        TextPri = WHITE, TextSec = rgb(175, 190, 225), TextMuted = rgb(90, 108, 154), Discord = rgb(88, 101, 242), DisGreen = rgb(59, 165, 93),
    },
    Crimson = {
        Bg = rgb(13, 8, 10), BgCard = rgb(21, 12, 14), BgItem = rgb(29, 16, 18), BgHover = rgb(38, 20, 22),
        Border = rgb(68, 28, 34), BorderHi = rgb(138, 44, 56), Accent = rgb(215, 45, 62), AccentHi = rgb(245, 78, 92),
        AccentDim = rgb(114, 16, 28), AccentGlow = rgb(255, 118, 126), Green = rgb(54, 210, 108), GreenDim = rgb(22, 110, 55),
        Red = rgb(255, 88, 88), Yellow = rgb(235, 180, 28), Blue = rgb(74, 145, 255), White = WHITE,
        TextPri = WHITE, TextSec = rgb(224, 190, 192), TextMuted = rgb(140, 96, 102), Discord = rgb(88, 101, 242), DisGreen = rgb(59, 165, 93),
    },
    Emerald = {
        Bg = rgb(7, 14, 10), BgCard = rgb(11, 20, 14), BgItem = rgb(15, 28, 18), BgHover = rgb(19, 36, 23),
        Border = rgb(28, 58, 34), BorderHi = rgb(42, 116, 60), Accent = rgb(34, 180, 84), AccentHi = rgb(62, 228, 110),
        AccentDim = rgb(12, 92, 38), AccentGlow = rgb(108, 255, 154), Green = rgb(50, 220, 104), GreenDim = rgb(16, 100, 44),
        Red = rgb(230, 68, 68), Yellow = rgb(212, 184, 36), Blue = rgb(72, 142, 245), White = WHITE,
        TextPri = WHITE, TextSec = rgb(178, 220, 184), TextMuted = rgb(82, 130, 92), Discord = rgb(88, 101, 242), DisGreen = rgb(59, 165, 93),
    },
    Gold = {
        Bg = rgb(14, 11, 6), BgCard = rgb(22, 17, 8), BgItem = rgb(30, 23, 10), BgHover = rgb(38, 29, 12),
        Border = rgb(68, 52, 18), BorderHi = rgb(140, 106, 34), Accent = rgb(220, 162, 24), AccentHi = rgb(255, 202, 52),
        AccentDim = rgb(118, 82, 10), AccentGlow = rgb(255, 228, 118), Green = rgb(54, 202, 108), GreenDim = rgb(22, 110, 54),
        Red = rgb(228, 70, 70), Yellow = rgb(255, 202, 54), Blue = rgb(72, 140, 242), White = WHITE,
        TextPri = WHITE, TextSec = rgb(228, 210, 162), TextMuted = rgb(138, 112, 60), Discord = rgb(88, 101, 242), DisGreen = rgb(59, 165, 93),
    },
    Arctic = {
        Bg = rgb(235, 240, 250), BgCard = rgb(221, 229, 243), BgItem = rgb(206, 216, 236), BgHover = rgb(192, 204, 229),
        Border = rgb(160, 176, 210), BorderHi = rgb(102, 138, 215), Accent = rgb(58, 118, 232), AccentHi = rgb(40, 94, 210),
        AccentDim = rgb(182, 201, 242), AccentGlow = rgb(32, 82, 204), Green = rgb(20, 160, 82), GreenDim = rgb(160, 220, 185),
        Red = rgb(215, 48, 48), Yellow = rgb(192, 146, 8), Blue = rgb(42, 102, 218), White = WHITE,
        TextPri = rgb(16, 20, 38), TextSec = rgb(52, 66, 112), TextMuted = rgb(110, 126, 166), Discord = rgb(88, 101, 242), DisGreen = rgb(59, 165, 93),
    },
    Obsidian = {
        Bg = rgb(8, 8, 10), BgCard = rgb(13, 13, 16), BgItem = rgb(18, 18, 22), BgHover = rgb(24, 24, 29),
        Border = rgb(44, 44, 52), BorderHi = rgb(84, 84, 96), Accent = rgb(180, 180, 190), AccentHi = rgb(232, 232, 242),
        AccentDim = rgb(62, 62, 72), AccentGlow = rgb(255, 255, 255), Green = rgb(55, 215, 120), GreenDim = rgb(22, 110, 60),
        Red = rgb(232, 74, 74), Yellow = rgb(234, 184, 42), Blue = rgb(88, 140, 255), White = WHITE,
        TextPri = WHITE, TextSec = rgb(198, 198, 208), TextMuted = rgb(120, 120, 130), Discord = rgb(88, 101, 242), DisGreen = rgb(59, 165, 93),
    },
    Slate = {
        Bg = rgb(15, 17, 21), BgCard = rgb(20, 23, 28), BgItem = rgb(26, 30, 36), BgHover = rgb(33, 38, 46),
        Border = rgb(52, 58, 70), BorderHi = rgb(92, 102, 120), Accent = rgb(110, 122, 140), AccentHi = rgb(170, 182, 200),
        AccentDim = rgb(66, 74, 88), AccentGlow = rgb(210, 218, 228), Green = rgb(54, 208, 112), GreenDim = rgb(22, 110, 60),
        Red = rgb(232, 74, 74), Yellow = rgb(234, 184, 42), Blue = rgb(88, 140, 255), White = WHITE,
        TextPri = WHITE, TextSec = rgb(190, 196, 206), TextMuted = rgb(125, 132, 144), Discord = rgb(88, 101, 242), DisGreen = rgb(59, 165, 93),
    },
    Neon = {
        Bg = rgb(8, 9, 16), BgCard = rgb(13, 14, 24), BgItem = rgb(18, 20, 34), BgHover = rgb(23, 26, 44),
        Border = rgb(58, 42, 92), BorderHi = rgb(104, 70, 170), Accent = rgb(170, 76, 255), AccentHi = rgb(205, 116, 255),
        AccentDim = rgb(82, 24, 150), AccentGlow = rgb(235, 184, 255), Green = rgb(56, 234, 132), GreenDim = rgb(22, 110, 60),
        Red = rgb(244, 84, 84), Yellow = rgb(240, 194, 58), Blue = rgb(90, 154, 255), White = WHITE,
        TextPri = WHITE, TextSec = rgb(210, 196, 230), TextMuted = rgb(130, 112, 170), Discord = rgb(88, 101, 242), DisGreen = rgb(59, 165, 93),
    },
    Sapphire = {
        Bg = rgb(7, 12, 18), BgCard = rgb(12, 18, 28), BgItem = rgb(16, 24, 38), BgHover = rgb(20, 30, 48),
        Border = rgb(30, 50, 84), BorderHi = rgb(48, 96, 170), Accent = rgb(40, 132, 244), AccentHi = rgb(84, 174, 255),
        AccentDim = rgb(18, 68, 150), AccentGlow = rgb(150, 212, 255), Green = rgb(54, 210, 114), GreenDim = rgb(22, 110, 60),
        Red = rgb(230, 70, 70), Yellow = rgb(234, 184, 42), Blue = rgb(90, 154, 255), White = WHITE,
        TextPri = WHITE, TextSec = rgb(176, 194, 224), TextMuted = rgb(86, 106, 150), Discord = rgb(88, 101, 242), DisGreen = rgb(59, 165, 93),
    },
    Rose = {
        Bg = rgb(18, 8, 12), BgCard = rgb(26, 13, 18), BgItem = rgb(34, 17, 24), BgHover = rgb(43, 22, 30),
        Border = rgb(78, 32, 52), BorderHi = rgb(150, 56, 92), Accent = rgb(232, 74, 134), AccentHi = rgb(255, 118, 170),
        AccentDim = rgb(130, 24, 72), AccentGlow = rgb(255, 186, 214), Green = rgb(54, 210, 112), GreenDim = rgb(22, 110, 60),
        Red = rgb(244, 84, 84), Yellow = rgb(240, 194, 58), Blue = rgb(88, 140, 255), White = WHITE,
        TextPri = WHITE, TextSec = rgb(230, 188, 206), TextMuted = rgb(164, 104, 132), Discord = rgb(88, 101, 242), DisGreen = rgb(59, 165, 93),
    },
    Sunset = {
        Bg = rgb(18, 10, 8), BgCard = rgb(28, 16, 12), BgItem = rgb(38, 22, 16), BgHover = rgb(48, 28, 20),
        Border = rgb(82, 46, 26), BorderHi = rgb(160, 86, 42), Accent = rgb(240, 120, 52), AccentHi = rgb(255, 172, 82),
        AccentDim = rgb(132, 62, 20), AccentGlow = rgb(255, 214, 132), Green = rgb(54, 210, 112), GreenDim = rgb(22, 110, 60),
        Red = rgb(244, 84, 84), Yellow = rgb(255, 208, 92), Blue = rgb(88, 140, 255), White = WHITE,
        TextPri = WHITE, TextSec = rgb(236, 204, 180), TextMuted = rgb(164, 118, 96), Discord = rgb(88, 101, 242), DisGreen = rgb(59, 165, 93),
    },
    Mint = {
        Bg = rgb(8, 16, 15), BgCard = rgb(12, 24, 22), BgItem = rgb(16, 32, 30), BgHover = rgb(20, 40, 38),
        Border = rgb(36, 72, 66), BorderHi = rgb(56, 138, 126), Accent = rgb(42, 200, 178), AccentHi = rgb(86, 240, 220),
        AccentDim = rgb(16, 98, 90), AccentGlow = rgb(180, 255, 246), Green = rgb(54, 220, 112), GreenDim = rgb(22, 110, 60),
        Red = rgb(238, 84, 84), Yellow = rgb(240, 196, 58), Blue = rgb(88, 150, 255), White = WHITE,
        TextPri = WHITE, TextSec = rgb(182, 224, 218), TextMuted = rgb(90, 148, 142), Discord = rgb(88, 101, 242), DisGreen = rgb(59, 165, 93),
    },
    Orchid = {
        Bg = rgb(12, 10, 18), BgCard = rgb(18, 14, 26), BgItem = rgb(24, 18, 36), BgHover = rgb(31, 24, 48),
        Border = rgb(58, 42, 94), BorderHi = rgb(114, 78, 176), Accent = rgb(156, 96, 244), AccentHi = rgb(196, 138, 255),
        AccentDim = rgb(82, 40, 146), AccentGlow = rgb(230, 202, 255), Green = rgb(54, 210, 112), GreenDim = rgb(22, 110, 60),
        Red = rgb(238, 84, 84), Yellow = rgb(240, 194, 58), Blue = rgb(88, 140, 255), White = WHITE,
        TextPri = WHITE, TextSec = rgb(214, 198, 236), TextMuted = rgb(132, 110, 162), Discord = rgb(88, 101, 242), DisGreen = rgb(59, 165, 93),
    },
}

local THEME_NAMES = {
    "Void", "Midnight", "Crimson", "Emerald", "Gold", "Arctic", "Obsidian", "Slate", "Neon", "Sapphire", "Rose", "Sunset", "Mint", "Orchid"
}

local Colors = {}
local CURRENT_THEME = "Void"
for k, v in pairs(THEMES.Void) do
    Colors[k] = v
end

local ThemeListeners = {}
local function registerThemeListener(fn)
    table.insert(ThemeListeners, fn)
    local ok, err = pcall(fn)
    if not ok then
        warn("[VoidHubLib] theme sync error:", err)
    end
end

local function applyTheme(name)
    local theme = THEMES[name]
    if not theme then
        warn("[VoidHubLib] unknown theme:", tostring(name), "falling back to Void")
        name = "Void"
        theme = THEMES.Void
    end
    CURRENT_THEME = name
    for k in pairs(Colors) do
        Colors[k] = nil
    end
    for k, v in pairs(theme) do
        Colors[k] = v
    end
    for _, fn in ipairs(ThemeListeners) do
        pcall(fn)
    end
end

local Icons = {
    logo    = "rbxassetid://126161789124643",
    close   = "rbxassetid://10747384394",
    minimize= "rbxassetid://10734895698",
    farm    = "rbxassetid://10723405360",
    lucky   = "rbxassetid://10723396000",
    auto    = "rbxassetid://10734950309",
    player  = "rbxassetid://10747373176",
    world   = "rbxassetid://10723404337",
    tp      = "rbxassetid://10734886004",
    rebirth = "rbxassetid://10734933966",
    shop    = "rbxassetid://10734930886",
    config  = "rbxassetid://10734941499",
    credits = "rbxassetid://10734930886",
    trash   = "rbxassetid://10747362393",
    save    = "rbxassetid://10734941499",
    load    = "rbxassetid://10734886202",
    reset   = "rbxassetid://10734933056",
    sell    = "rbxassetid://10734975692",
    chevD   = "rbxassetid://10709790948",
    discord = "rbxassetid://10709811365",
}

local SFX_IDS = {
    hover = "rbxassetid://9113083740",
    click = "rbxassetid://9114488953",
    on    = "rbxassetid://9114488953",
    off   = "rbxassetid://9113083740",
    ok    = "rbxassetid://9114488953",
    open  = "rbxassetid://9114488953",
    close = "rbxassetid://9113083740",
}

local function sfx(kind)
    local id = SFX_IDS[kind]
    if not id then
        return
    end
    task.spawn(function()
        pcall(function()
            local s = Instance.new("Sound")
            s.SoundId = id
            s.Volume = 0.2
            s.Parent = SoundService
            s:Play()
            task.delay(1.5, function()
                if s then s:Destroy() end
            end)
        end)
    end)
end

local function safeCallback(cb, ...)
    if typeof(cb) ~= "function" then
        return
    end
    local ok, err = pcall(cb, ...)
    if not ok then
        warn("[VoidHubLib] callback error:", err)
    end
end

local function tw(obj, props, t, style, dir)
    if not obj then return end
    local ok = pcall(function()
        TweenService:Create(obj, TweenInfo.new(t or 0.15, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props):Play()
    end)
    if not ok then end
end

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
    return c
end

local function mkStroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or Colors.Border
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Parent = parent
    return s
end

local layoutCounters = {}
local function nextOrder(parent)
    layoutCounters[parent] = (layoutCounters[parent] or 0) + 1
    return layoutCounters[parent]
end

local function mix(a, b, t)
    return Color3.new(
        a.R + (b.R - a.R) * t,
        a.G + (b.G - a.G) * t,
        a.B + (b.B - a.B) * t
    )
end

local function setGradient(grad, c1, c2)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, c1),
        ColorSequenceKeypoint.new(1, c2),
    })
end

local Component = {}

function Component.Section(parent, title)
    local f = Instance.new("Frame")
    f.Name = "Section"
    f.Size = UDim2.new(1, 0, 0, 22)
    f.BackgroundTransparency = 1
    f.LayoutOrder = nextOrder(parent)
    f.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Name = "Title"
    lbl.Text = tostring(title or "SECTION"):upper()
    lbl.Font = Enum.Font.GothamBlack
    lbl.TextSize = 10
    lbl.TextColor3 = Colors.AccentHi
    lbl.Size = UDim2.new(1, -4, 0, 14)
    lbl.Position = UDim2.new(0, 2, 0, 4)
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = f

    local line = Instance.new("Frame")
    line.Name = "Line"
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 1, -1)
    line.BackgroundColor3 = Colors.Accent
    line.BackgroundTransparency = 0.65
    line.BorderSizePixel = 0
    line.Parent = f
    corner(line, 1)

    registerThemeListener(function()
        if f.Parent then
            lbl.TextColor3 = Colors.AccentHi
            line.BackgroundColor3 = Colors.Accent
            line.BackgroundTransparency = 0.65
        end
    end)
    return f
end

function Component.StatusCard(parent, title, defaultText, accentColor)
    local col = accentColor or Colors.Green
    local card = Instance.new("Frame")
    card.Name = "StatusCard"
    card.Size = UDim2.new(1, 0, 0, 56)
    card.LayoutOrder = nextOrder(parent)
    card.BackgroundColor3 = Colors.BgItem
    card.BackgroundTransparency = 0.18
    card.BorderSizePixel = 0
    card.Parent = parent
    corner(card, 12)
    local st = mkStroke(card, Colors.Border, 1, 0.5)

    local overlay = Instance.new("Frame")
    overlay.Name = "Overlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundTransparency = 1
    overlay.BorderSizePixel = 0
    overlay.Parent = card
    corner(overlay, 12)

    local pulse = Instance.new("Frame")
    pulse.Name = "Pulse"
    pulse.Size = UDim2.new(1, 0, 1, 0)
    pulse.BackgroundColor3 = col
    pulse.BackgroundTransparency = 1
    pulse.BorderSizePixel = 0
    pulse.ZIndex = 0
    pulse.Parent = card
    corner(pulse, 12)

    local bar = Instance.new("Frame")
    bar.Name = "AccentBar"
    bar.Size = UDim2.new(0, 3, 0.72, 0)
    bar.Position = UDim2.new(0, 0, 0.14, 0)
    bar.BackgroundColor3 = col
    bar.BorderSizePixel = 0
    bar.Parent = card
    corner(bar, 2)

    local dot = Instance.new("Frame")
    dot.Name = "Dot"
    dot.Size = UDim2.new(0, 8, 0, 8)
    dot.Position = UDim2.new(1, -20, 0, 10)
    dot.BackgroundColor3 = Colors.TextMuted
    dot.BorderSizePixel = 0
    dot.Parent = card
    corner(dot, 4)

    local t1 = Instance.new("TextLabel")
    t1.Name = "Title"
    t1.Text = tostring(title or "STATUS")
    t1.Font = Enum.Font.GothamBold
    t1.TextSize = 9
    t1.TextColor3 = Colors.TextMuted
    t1.Size = UDim2.new(1, -28, 0, 13)
    t1.Position = UDim2.new(0, 14, 0, 9)
    t1.BackgroundTransparency = 1
    t1.TextXAlignment = Enum.TextXAlignment.Left
    t1.Parent = card

    local valueLbl = Instance.new("TextLabel")
    valueLbl.Name = "Value"
    valueLbl.Text = tostring(defaultText or "IDLE")
    valueLbl.Font = Enum.Font.GothamBlack
    valueLbl.TextSize = 16
    valueLbl.TextColor3 = Colors.TextPri
    valueLbl.Size = UDim2.new(1, -28, 0, 24)
    valueLbl.Position = UDim2.new(0, 14, 0, 25)
    valueLbl.BackgroundTransparency = 1
    valueLbl.TextXAlignment = Enum.TextXAlignment.Left
    valueLbl.Parent = card

    local function setActive(active)
        local c = active and col or Colors.TextMuted
        tw(dot, { BackgroundColor3 = c }, 0.18)
        tw(st, { Color = active and col or Colors.Border, Transparency = 0.5 }, 0.18)
        tw(bar, { BackgroundColor3 = c }, 0.18)
    end

    registerThemeListener(function()
        if card.Parent then
            local c = accentColor or Colors.Green
            card.BackgroundColor3 = Colors.BgItem
            card.BackgroundTransparency = 0.18
            st.Color = Colors.Border
            t1.TextColor3 = Colors.TextMuted
            valueLbl.TextColor3 = Colors.TextPri
            dot.BackgroundColor3 = Colors.TextMuted
            bar.BackgroundColor3 = c
            pulse.BackgroundColor3 = c
        end
    end)

    return valueLbl, pulse, setActive
end

function Component.StartPulse(pulse, cond)
    task.spawn(function()
        while pulse and pulse.Parent and cond and cond() do
            tw(pulse, { BackgroundTransparency = 0.85 }, 1.2)
            task.wait(1.2)
            if not (pulse and pulse.Parent and cond and cond()) then break end
            tw(pulse, { BackgroundTransparency = 1 }, 1.2)
            task.wait(1.2)
        end
        if pulse and pulse.Parent then
            pulse.BackgroundTransparency = 1
        end
    end)
end

function Component.Toggle(parent, text, stateTable, key, callback)
    stateTable = stateTable or {}
    stateTable[key] = stateTable[key] == true

    local row = Instance.new("Frame")
    row.Name = "Toggle"
    row.Size = UDim2.new(1, 0, 0, 36)
    row.LayoutOrder = nextOrder(parent)
    row.BackgroundColor3 = Colors.BgItem
    row.BackgroundTransparency = 0.2
    row.BorderSizePixel = 0
    row.Parent = parent
    corner(row, 10)
    local rst = mkStroke(row, Colors.Border, 1, 0.65)

    local lbl = Instance.new("TextLabel")
    lbl.Text = tostring(text or "Toggle")
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = 11
    lbl.TextColor3 = Colors.TextPri
    lbl.Size = UDim2.new(1, -58, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local track = Instance.new("Frame")
    track.Name = "Track"
    track.Size = UDim2.new(0, 38, 0, 20)
    track.Position = UDim2.new(1, -48, 0.5, -10)
    track.BackgroundColor3 = Colors.Border
    track.BorderSizePixel = 0
    track.Parent = row
    corner(track, 10)

    local knob = Instance.new("Frame")
    knob.Name = "Knob"
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new(0, 2, 0.5, -8)
    knob.BackgroundColor3 = Colors.White
    knob.BorderSizePixel = 0
    knob.Parent = track
    corner(knob, 8)

    local function applyVisual(en)
        if en then
            tw(track, { BackgroundColor3 = Colors.Accent }, 0.16)
            tw(knob, { Position = UDim2.new(0, 20, 0.5, -8) }, 0.16)
            tw(rst, { Color = Colors.AccentHi, Transparency = 0.45 }, 0.16)
            lbl.TextColor3 = Colors.TextPri
        else
            tw(track, { BackgroundColor3 = Colors.Border }, 0.16)
            tw(knob, { Position = UDim2.new(0, 2, 0.5, -8) }, 0.16)
            tw(rst, { Color = Colors.Border, Transparency = 0.65 }, 0.16)
            lbl.TextColor3 = Colors.TextPri
        end
    end
    applyVisual(stateTable[key])

    local hit = Instance.new("TextButton")
    hit.Size = UDim2.new(1, 0, 1, 0)
    hit.BackgroundTransparency = 1
    hit.Text = ""
    hit.AutoButtonColor = false
    hit.Parent = row

    hit.MouseButton1Click:Connect(function()
        stateTable[key] = not stateTable[key]
        sfx(stateTable[key] and "on" or "off")
        applyVisual(stateTable[key])
        safeCallback(callback, stateTable[key])
    end)

    row.MouseEnter:Connect(function()
        sfx("hover")
        tw(row, { BackgroundTransparency = 0.08 }, 0.1)
    end)
    row.MouseLeave:Connect(function()
        tw(row, { BackgroundTransparency = 0.2 }, 0.1)
    end)

    registerThemeListener(function()
        if row.Parent then
            row.BackgroundColor3 = Colors.BgItem
            track.BackgroundColor3 = stateTable[key] and Colors.Accent or Colors.Border
            knob.BackgroundColor3 = Colors.White
            lbl.TextColor3 = Colors.TextPri
            rst.Color = stateTable[key] and Colors.AccentHi or Colors.Border
            rst.Transparency = stateTable[key] and 0.45 or 0.65
        end
    end)

    return row, function()
        applyVisual(stateTable[key])
    end
end

function Component.Slider(parent, text, sMin, sMax, sDefault, stateTable, key, callback)
    sMin = tonumber(sMin) or 0
    sMax = tonumber(sMax) or 1
    sDefault = tonumber(sDefault) or sMin
    if sMin > sMax then
        sMin, sMax = sMax, sMin
    end
    local isInt = (sMax - sMin) >= 1

    stateTable = stateTable or {}
    stateTable[key] = tonumber(stateTable[key]) or sDefault
    stateTable[key] = math.clamp(stateTable[key], sMin, sMax)

    local row = Instance.new("Frame")
    row.Name = "Slider"
    row.Size = UDim2.new(1, 0, 0, 54)
    row.LayoutOrder = nextOrder(parent)
    row.BackgroundColor3 = Colors.BgItem
    row.BackgroundTransparency = 0.2
    row.BorderSizePixel = 0
    row.Parent = parent
    corner(row, 10)
    local rst = mkStroke(row, Colors.Border, 1, 0.65)

    local lbl = Instance.new("TextLabel")
    lbl.Text = tostring(text or "Slider")
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = 11
    lbl.TextColor3 = Colors.TextPri
    lbl.Size = UDim2.new(1, -74, 0, 16)
    lbl.Position = UDim2.new(0, 12, 0, 8)
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local vBox = Instance.new("Frame")
    vBox.Name = "ValueBox"
    vBox.Size = UDim2.new(0, 50, 0, 18)
    vBox.Position = UDim2.new(1, -62, 0, 7)
    vBox.BackgroundColor3 = Colors.Bg
    vBox.BackgroundTransparency = 0.12
    vBox.BorderSizePixel = 0
    vBox.Parent = row
    corner(vBox, 6)
    local vStroke = mkStroke(vBox, Colors.AccentHi, 1, 0.6)

    local vLbl = Instance.new("TextBox")
    vLbl.Text = tostring(sDefault)
    vLbl.Font = Enum.Font.GothamBold
    vLbl.TextSize = 11
    vLbl.TextColor3 = Colors.AccentHi
    vLbl.Size = UDim2.new(1, 0, 1, 0)
    vLbl.BackgroundTransparency = 1
    vLbl.ClearTextOnFocus = false
    vLbl.PlaceholderColor3 = Colors.TextMuted
    vLbl.Parent = vBox

    local trackF = Instance.new("Frame")
    trackF.Name = "Track"
    trackF.Size = UDim2.new(1, -24, 0, 5)
    trackF.Position = UDim2.new(0, 12, 0, 37)
    trackF.BackgroundColor3 = Colors.Border
    trackF.BorderSizePixel = 0
    trackF.Parent = row
    corner(trackF, 3)

    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.BackgroundColor3 = Colors.Accent
    fill.BorderSizePixel = 0
    fill.Parent = trackF
    corner(fill, 3)
    local fillGrad = Instance.new("UIGradient")
    fillGrad.Rotation = 0
    fillGrad.Parent = fill

    local knob = Instance.new("Frame")
    knob.Name = "Knob"
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.BackgroundColor3 = Colors.White
    knob.BorderSizePixel = 0
    knob.ZIndex = 3
    knob.Parent = trackF
    corner(knob, 6)
    local knobStroke = mkStroke(knob, Colors.AccentHi, 2, 0)

    local function valueToPercent(v)
        if sMax == sMin then
            return 0
        end
        return math.clamp((v - sMin) / (sMax - sMin), 0, 1)
    end

    local function commit(v)
        v = math.clamp(v, sMin, sMax)
        if isInt then
            v = math.floor(v + 0.5)
        else
            v = math.floor(v * 100 + 0.5) / 100
        end
        stateTable[key] = v
        vLbl.Text = tostring(v)
        local p = valueToPercent(v)
        fill.Size = UDim2.new(p, 0, 1, 0)
        knob.Position = UDim2.new(p, -6, 0.5, -6)
        safeCallback(callback, v)
    end

    local function syncFromBox()
        local num = tonumber(vLbl.Text)
        if num then
            commit(num)
        else
            vLbl.Text = tostring(stateTable[key])
        end
    end

    vLbl.FocusLost:Connect(syncFromBox)

    local dragging = false
    local moveConn, endConn

    local function stopDrag()
        dragging = false
        tw(knob, { Size = UDim2.new(0, 12, 0, 12) }, 0.12)
        if moveConn then moveConn:Disconnect(); moveConn = nil end
        if endConn then endConn:Disconnect(); endConn = nil end
    end

    local function applyInput(inp)
        if sMax == sMin then
            commit(sMin)
            return
        end
        local p = math.clamp((inp.Position.X - trackF.AbsolutePosition.X) / trackF.AbsoluteSize.X, 0, 1)
        commit(sMin + p * (sMax - sMin))
    end

    local function startDrag()
        if dragging then return end
        dragging = true
        tw(knob, { Size = UDim2.new(0, 14, 0, 14) }, 0.12)
        moveConn = UserInputService.InputChanged:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
                applyInput(inp)
            end
        end)
        endConn = UserInputService.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                stopDrag()
            end
        end)
    end

    knob.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            startDrag()
        end
    end)

    trackF.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            applyInput(inp)
            startDrag()
        end
    end)

    row.MouseEnter:Connect(function()
        sfx("hover")
        tw(row, { BackgroundTransparency = 0.08 }, 0.1)
    end)
    row.MouseLeave:Connect(function()
        tw(row, { BackgroundTransparency = 0.2 }, 0.1)
    end)

    local function syncVisual()
        if row.Parent then
            row.BackgroundColor3 = Colors.BgItem
            row.BackgroundTransparency = 0.2
            rst.Color = Colors.Border
            lbl.TextColor3 = Colors.TextPri
            vBox.BackgroundColor3 = Colors.Bg
            vStroke.Color = Colors.AccentHi
            vLbl.TextColor3 = Colors.AccentHi
            trackF.BackgroundColor3 = Colors.Border
            fill.BackgroundColor3 = Colors.Accent
            setGradient(fillGrad, Colors.AccentDim, Colors.AccentGlow)
            knob.BackgroundColor3 = Colors.White
            knobStroke.Color = Colors.AccentHi
            local p = valueToPercent(stateTable[key])
            fill.Size = UDim2.new(p, 0, 1, 0)
            knob.Position = UDim2.new(p, -6, 0.5, -6)
            vLbl.Text = tostring(stateTable[key])
        end
    end

    registerThemeListener(syncVisual)

    commit(stateTable[key])
    return row
end

function Component.Button(parent, text, icon, col, callback)
    local btn = Instance.new("TextButton")
    btn.Name = "Button"
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.LayoutOrder = nextOrder(parent)
    btn.BackgroundColor3 = col or Colors.AccentDim
    btn.BackgroundTransparency = 0.22
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Parent = parent
    corner(btn, 10)
    local bst = mkStroke(btn, col or Colors.AccentHi, 1, 0.55)

    local grad = Instance.new("UIGradient")
    grad.Rotation = 0
    grad.Parent = btn
    setGradient(grad, mix(btn.BackgroundColor3, Colors.Bg, 0.12), btn.BackgroundColor3)

    local im
    if icon then
        im = Instance.new("ImageLabel")
        im.Name = "Icon"
        im.Size = UDim2.new(0, 14, 0, 14)
        im.Position = UDim2.new(0, 11, 0.5, -7)
        im.BackgroundTransparency = 1
        im.Image = icon
        im.ImageColor3 = Colors.TextPri
        im.Parent = btn
    end

    local lbl = Instance.new("TextLabel")
    lbl.Name = "Label"
    lbl.Text = tostring(text or "Button")
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.TextColor3 = Colors.TextPri
    lbl.Size = UDim2.new(1, icon and -30 or -16, 1, 0)
    lbl.Position = UDim2.new(0, icon and 30 or 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = btn

    btn.MouseButton1Click:Connect(function()
        sfx("ok")
        tw(btn, { Size = UDim2.new(0.98, 0, 0, 34) }, 0.07)
        task.delay(0.08, function()
            if btn.Parent then
                tw(btn, { Size = UDim2.new(1, 0, 0, 36) }, 0.12)
            end
        end)
        safeCallback(callback)
    end)
    btn.MouseEnter:Connect(function()
        sfx("hover")
        tw(btn, { BackgroundTransparency = 0.05 }, 0.1)
        tw(bst, { Transparency = 0.2 }, 0.1)
    end)
    btn.MouseLeave:Connect(function()
        tw(btn, { BackgroundTransparency = 0.22 }, 0.1)
        tw(bst, { Transparency = 0.55 }, 0.1)
    end)

    registerThemeListener(function()
        if btn.Parent then
            btn.BackgroundColor3 = col or Colors.AccentDim
            bst.Color = col or Colors.AccentHi
            lbl.TextColor3 = Colors.TextPri
            if im then im.ImageColor3 = Colors.TextPri end
            setGradient(grad, mix((col or Colors.AccentDim), Colors.Bg, 0.12), col or Colors.AccentDim)
        end
    end)

    return btn
end

function Component.Dropdown(parent, label, options, defaultIdx, callback)
    options = options or {}
    local cur = 1
    if typeof(defaultIdx) == "number" then
        cur = math.clamp(math.floor(defaultIdx), 1, math.max(#options, 1))
    elseif typeof(defaultIdx) == "string" then
        for i, opt in ipairs(options) do
            if opt == defaultIdx then
                cur = i
                break
            end
        end
    end
    if #options == 0 then
        options = { "None" }
        cur = 1
    end

    local wrap = Instance.new("Frame")
    wrap.Name = "Dropdown"
    wrap.Size = UDim2.new(1, 0, 0, 36)
    wrap.LayoutOrder = nextOrder(parent)
    wrap.BackgroundTransparency = 1
    wrap.BorderSizePixel = 0
    wrap.Parent = parent

    local header = Instance.new("TextButton")
    header.Size = UDim2.new(1, 0, 0, 36)
    header.BackgroundColor3 = Colors.BgItem
    header.BackgroundTransparency = 0.16
    header.Text = ""
    header.AutoButtonColor = false
    header.Parent = wrap
    corner(header, 10)
    local hst = mkStroke(header, Colors.Border, 1, 0.55)

    local lLbl = Instance.new("TextLabel")
    lLbl.Text = tostring(label or "Dropdown")
    lLbl.Font = Enum.Font.GothamSemibold
    lLbl.TextSize = 10
    lLbl.TextColor3 = Colors.TextMuted
    lLbl.Size = UDim2.new(0.44, 0, 1, 0)
    lLbl.Position = UDim2.new(0, 12, 0, 0)
    lLbl.BackgroundTransparency = 1
    lLbl.TextXAlignment = Enum.TextXAlignment.Left
    lLbl.Parent = header

    local vLbl = Instance.new("TextLabel")
    vLbl.Font = Enum.Font.GothamBlack
    vLbl.TextSize = 12
    vLbl.TextColor3 = Colors.AccentHi
    vLbl.Size = UDim2.new(0.46, 0, 1, 0)
    vLbl.Position = UDim2.new(0.44, 0, 0, 0)
    vLbl.BackgroundTransparency = 1
    vLbl.TextXAlignment = Enum.TextXAlignment.Left
    vLbl.Text = tostring(options[cur])
    vLbl.Parent = header

    local arrow = Instance.new("ImageLabel")
    arrow.Size = UDim2.new(0, 12, 0, 12)
    arrow.Position = UDim2.new(1, -22, 0.5, -6)
    arrow.BackgroundTransparency = 1
    arrow.Image = Icons.chevD
    arrow.ImageColor3 = Colors.TextMuted
    arrow.Parent = header

    local list = Instance.new("Frame")
    list.Name = "List"
    list.Size = UDim2.new(1, 0, 0, 0)
    list.Position = UDim2.new(0, 0, 0, 40)
    list.BackgroundColor3 = Colors.BgCard
    list.BackgroundTransparency = 0.1
    list.BorderSizePixel = 0
    list.ClipsDescendants = true
    list.Visible = false
    list.Parent = wrap
    corner(list, 10)
    local lstStroke = mkStroke(list, Colors.AccentHi, 1, 0.35)
    local lLayout = Instance.new("UIListLayout")
    lLayout.SortOrder = Enum.SortOrder.LayoutOrder
    lLayout.Padding = UDim.new(0, 4)
    lLayout.Parent = list
    local lPad = Instance.new("UIPadding")
    lPad.PaddingTop = UDim.new(0, 4)
    lPad.PaddingBottom = UDim.new(0, 4)
    lPad.PaddingLeft = UDim.new(0, 4)
    lPad.PaddingRight = UDim.new(0, 4)
    lPad.Parent = list

    local rows = {}
    local open = false
    local rowH = 30
    local targetH = #options * (rowH + 4) + 8

    local function setSelection(idx)
        cur = math.clamp(idx, 1, #options)
        vLbl.Text = tostring(options[cur])
        for i, row in ipairs(rows) do
            local active = i == cur
            row.BackgroundColor3 = active and Colors.AccentDim or Colors.BgHover
            row.BackgroundTransparency = active and 0.18 or 0.44
            row.TextColor3 = active and Colors.AccentHi or Colors.TextSec
        end
    end

    for i, opt in ipairs(options) do
        local row = Instance.new("TextButton")
        row.Size = UDim2.new(1, 0, 0, rowH)
        row.LayoutOrder = i
        row.BackgroundColor3 = i == cur and Colors.AccentDim or Colors.BgHover
        row.BackgroundTransparency = i == cur and 0.18 or 0.44
        row.Text = tostring(opt)
        row.Font = Enum.Font.GothamBold
        row.TextSize = 11
        row.TextColor3 = i == cur and Colors.AccentHi or Colors.TextSec
        row.AutoButtonColor = false
        row.Parent = list
        corner(row, 7)
        rows[i] = row

        row.MouseButton1Click:Connect(function()
            sfx("click")
            setSelection(i)
            open = false
            tw(list, { Size = UDim2.new(1, 0, 0, 0) }, 0.16)
            tw(arrow, { Rotation = 0 }, 0.16)
            tw(hst, { Color = Colors.Border, Transparency = 0.55 }, 0.16)
            task.delay(0.16, function()
                if list.Parent then list.Visible = false end
            end)
            wrap.Size = UDim2.new(1, 0, 0, 36)
            safeCallback(callback, i, opt)
        end)

        row.MouseEnter:Connect(function()
            if i ~= cur then
                tw(row, { BackgroundTransparency = 0.25 }, 0.08)
            end
        end)
        row.MouseLeave:Connect(function()
            if i ~= cur then
                tw(row, { BackgroundTransparency = 0.44 }, 0.08)
            end
        end)
    end

    header.MouseButton1Click:Connect(function()
        sfx("click")
        open = not open
        if open then
            list.Visible = true
            list.Size = UDim2.new(1, 0, 0, 0)
            tw(list, { Size = UDim2.new(1, 0, 0, targetH) }, 0.2, Enum.EasingStyle.Back)
            tw(arrow, { Rotation = 180 }, 0.16)
            tw(hst, { Color = Colors.AccentHi, Transparency = 0.2 }, 0.16)
            wrap.Size = UDim2.new(1, 0, 0, 36 + targetH + 4)
        else
            tw(list, { Size = UDim2.new(1, 0, 0, 0) }, 0.15)
            tw(arrow, { Rotation = 0 }, 0.15)
            tw(hst, { Color = Colors.Border, Transparency = 0.55 }, 0.15)
            task.delay(0.15, function()
                if list.Parent then list.Visible = false end
            end)
            wrap.Size = UDim2.new(1, 0, 0, 36)
        end
    end)

    header.MouseEnter:Connect(function()
        sfx("hover")
        tw(header, { BackgroundTransparency = 0.02 }, 0.1)
    end)
    header.MouseLeave:Connect(function()
        tw(header, { BackgroundTransparency = 0.16 }, 0.1)
    end)

    registerThemeListener(function()
        if wrap.Parent then
            header.BackgroundColor3 = Colors.BgItem
            lLbl.TextColor3 = Colors.TextMuted
            vLbl.TextColor3 = Colors.AccentHi
            arrow.ImageColor3 = Colors.TextMuted
            list.BackgroundColor3 = Colors.BgCard
            lstStroke.Color = Colors.AccentHi
            hst.Color = Colors.Border
            setSelection(cur)
        end
    end)

    setSelection(cur)
    safeCallback(callback, cur, options[cur])
    return wrap
end

function Component.RarityDropdown(parent, rarities, rarColors, stateTable)
    rarities = rarities or {}
    rarColors = rarColors or {}
    stateTable = stateTable or {}
    local ITEM_H = 30

    local function enabledCount()
        local n = 0
        for _, r in ipairs(rarities) do
            if stateTable[r] then n = n + 1 end
        end
        return n
    end

    local wrap = Instance.new("Frame")
    wrap.Name = "RarityDropdown"
    wrap.Size = UDim2.new(1, 0, 0, 36)
    wrap.LayoutOrder = nextOrder(parent)
    wrap.BackgroundTransparency = 1
    wrap.BorderSizePixel = 0
    wrap.Parent = parent

    local header = Instance.new("TextButton")
    header.Size = UDim2.new(1, 0, 0, 36)
    header.BackgroundColor3 = Colors.BgItem
    header.BackgroundTransparency = 0.16
    header.Text = ""
    header.AutoButtonColor = false
    header.Parent = wrap
    corner(header, 10)
    local hst = mkStroke(header, Colors.Border, 1, 0.55)

    local lLbl = Instance.new("TextLabel")
    lLbl.Text = "Rarities"
    lLbl.Font = Enum.Font.GothamSemibold
    lLbl.TextSize = 10
    lLbl.TextColor3 = Colors.TextMuted
    lLbl.Size = UDim2.new(0.44, 0, 1, 0)
    lLbl.Position = UDim2.new(0, 12, 0, 0)
    lLbl.BackgroundTransparency = 1
    lLbl.TextXAlignment = Enum.TextXAlignment.Left
    lLbl.Parent = header

    local vLbl = Instance.new("TextLabel")
    vLbl.Font = Enum.Font.GothamBlack
    vLbl.TextSize = 11
    vLbl.Size = UDim2.new(0.44, 0, 1, 0)
    vLbl.Position = UDim2.new(0.44, 0, 0, 0)
    vLbl.BackgroundTransparency = 1
    vLbl.TextXAlignment = Enum.TextXAlignment.Left
    vLbl.Parent = header

    local arrow = Instance.new("ImageLabel")
    arrow.Size = UDim2.new(0, 12, 0, 12)
    arrow.Position = UDim2.new(1, -22, 0.5, -6)
    arrow.BackgroundTransparency = 1
    arrow.Image = Icons.chevD
    arrow.ImageColor3 = Colors.TextMuted
    arrow.Parent = header

    local list = Instance.new("Frame")
    list.Size = UDim2.new(1, 0, 0, 0)
    list.Position = UDim2.new(0, 0, 0, 40)
    list.BackgroundColor3 = Colors.BgCard
    list.BackgroundTransparency = 0.1
    list.BorderSizePixel = 0
    list.ClipsDescendants = true
    list.Visible = false
    list.Parent = wrap
    corner(list, 10)
    local lstStroke = mkStroke(list, Colors.AccentHi, 1, 0.35)
    local lLayout = Instance.new("UIListLayout")
    lLayout.SortOrder = Enum.SortOrder.LayoutOrder
    lLayout.Padding = UDim.new(0, 4)
    lLayout.Parent = list
    local lPad = Instance.new("UIPadding")
    lPad.PaddingTop = UDim.new(0, 4)
    lPad.PaddingBottom = UDim.new(0, 4)
    lPad.PaddingLeft = UDim.new(0, 4)
    lPad.PaddingRight = UDim.new(0, 4)
    lPad.Parent = list

    local rows = {}
    local open = false
    local targetH = #rarities * (ITEM_H + 4) + 8

    local function refreshSummary()
        local n = enabledCount()
        vLbl.Text = string.format("%d / %d ON", n, #rarities)
        vLbl.TextColor3 = (n == 0 and Colors.Red) or (n == #rarities and Colors.Green) or Colors.AccentHi
    end

    local function setRowVisual(row, dot, track, knob, rst, col, enabled)
        tw(track, { BackgroundColor3 = enabled and col or Colors.Border }, 0.12)
        tw(knob, { Position = enabled and UDim2.new(0, 18, 0.5, -6) or UDim2.new(0, 2, 0.5, -6) }, 0.12)
        tw(rst, { Color = enabled and col or Colors.Border, Transparency = enabled and 0.4 or 0.7 }, 0.12)
        dot.BackgroundColor3 = col
        row.BackgroundTransparency = enabled and 0.24 or 0.44
    end

    for idx, rarity in ipairs(rarities) do
        local col = rarColors[rarity] or Colors.TextMuted
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, ITEM_H)
        row.LayoutOrder = idx
        row.BackgroundColor3 = Colors.BgHover
        row.BackgroundTransparency = 0.44
        row.BorderSizePixel = 0
        row.Parent = list
        corner(row, 8)
        local rst = mkStroke(row, Colors.Border, 1, 0.7)

        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, 7, 0, 7)
        dot.Position = UDim2.new(0, 9, 0.5, -3.5)
        dot.BorderSizePixel = 0
        dot.Parent = row
        corner(dot, 4)

        local nameLbl = Instance.new("TextLabel")
        nameLbl.Text = tostring(rarity)
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.TextSize = 11
        nameLbl.TextColor3 = Colors.TextPri
        nameLbl.Size = UDim2.new(1, -74, 1, 0)
        nameLbl.Position = UDim2.new(0, 22, 0, 0)
        nameLbl.BackgroundTransparency = 1
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left
        nameLbl.Parent = row

        local track = Instance.new("Frame")
        track.Size = UDim2.new(0, 32, 0, 16)
        track.Position = UDim2.new(1, -40, 0.5, -8)
        track.BorderSizePixel = 0
        track.Parent = row
        corner(track, 8)

        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 12, 0, 12)
        knob.BorderSizePixel = 0
        knob.Parent = track
        corner(knob, 6)

        local hit = Instance.new("TextButton")
        hit.Size = UDim2.new(1, 0, 1, 0)
        hit.BackgroundTransparency = 1
        hit.Text = ""
        hit.AutoButtonColor = false
        hit.Parent = row

        hit.MouseButton1Click:Connect(function()
            stateTable[rarity] = not stateTable[rarity]
            sfx(stateTable[rarity] and "on" or "off")
            setRowVisual(row, dot, track, knob, rst, col, stateTable[rarity])
            refreshSummary()
        end)

        row.MouseEnter:Connect(function()
            tw(row, { BackgroundTransparency = 0.26 }, 0.1)
        end)
        row.MouseLeave:Connect(function()
            tw(row, { BackgroundTransparency = stateTable[rarity] and 0.24 or 0.44 }, 0.1)
        end)

        rows[idx] = {
            row = row, dot = dot, track = track, knob = knob, rst = rst, col = col, nameLbl = nameLbl,
        }
        setRowVisual(row, dot, track, knob, rst, col, stateTable[rarity] == true)
    end

    header.MouseButton1Click:Connect(function()
        sfx("click")
        open = not open
        if open then
            list.Visible = true
            list.Size = UDim2.new(1, 0, 0, 0)
            tw(list, { Size = UDim2.new(1, 0, 0, targetH) }, 0.2, Enum.EasingStyle.Back)
            tw(arrow, { Rotation = 180 }, 0.16)
            tw(hst, { Color = Colors.AccentHi, Transparency = 0.2 }, 0.16)
            wrap.Size = UDim2.new(1, 0, 0, 36 + targetH + 4)
        else
            tw(list, { Size = UDim2.new(1, 0, 0, 0) }, 0.15)
            tw(arrow, { Rotation = 0 }, 0.15)
            tw(hst, { Color = Colors.Border, Transparency = 0.55 }, 0.15)
            task.delay(0.15, function()
                if list.Parent then list.Visible = false end
            end)
            wrap.Size = UDim2.new(1, 0, 0, 36)
        end
    end)

    header.MouseEnter:Connect(function()
        sfx("hover")
        tw(header, { BackgroundTransparency = 0.02 }, 0.1)
    end)
    header.MouseLeave:Connect(function()
        tw(header, { BackgroundTransparency = 0.16 }, 0.1)
    end)

    registerThemeListener(function()
        if wrap.Parent then
            header.BackgroundColor3 = Colors.BgItem
            lLbl.TextColor3 = Colors.TextMuted
            arrow.ImageColor3 = Colors.TextMuted
            list.BackgroundColor3 = Colors.BgCard
            lstStroke.Color = Colors.AccentHi
            hst.Color = Colors.Border
            refreshSummary()
            for _, info in ipairs(rows) do
                local en = stateTable[info.nameLbl.Text] == true
                info.dot.BackgroundColor3 = info.col
                info.nameLbl.TextColor3 = Colors.TextPri
                info.track.BackgroundColor3 = en and info.col or Colors.Border
                info.knob.BackgroundColor3 = Colors.White
                info.rst.Color = en and info.col or Colors.Border
            end
        end
    end)

    refreshSummary()
    return wrap
end

function Component.InfoStrip(parent, text, col)
    local f = Instance.new("Frame")
    f.Name = "InfoStrip"
    f.Size = UDim2.new(1, 0, 0, 30)
    f.LayoutOrder = nextOrder(parent)
    f.BackgroundColor3 = col or Colors.GreenDim
    f.BackgroundTransparency = 0.82
    f.BorderSizePixel = 0
    f.Parent = parent
    corner(f, 8)
    local st = mkStroke(f, col or Colors.Green, 1, 0.8)

    local l = Instance.new("TextLabel")
    l.Text = tostring(text or "Info")
    l.Font = Enum.Font.GothamSemibold
    l.TextSize = 10
    l.TextColor3 = Colors.TextSec
    l.Size = UDim2.new(1, -14, 1, 0)
    l.Position = UDim2.new(0, 7, 0, 0)
    l.BackgroundTransparency = 1
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextWrapped = true
    l.Parent = f

    registerThemeListener(function()
        if f.Parent then
            f.BackgroundColor3 = col or Colors.GreenDim
            st.Color = col or Colors.Green
            l.TextColor3 = Colors.TextSec
        end
    end)

    return f, l
end

local Tab = {}
Tab.__index = Tab

function Tab:Section(title) return Component.Section(self._page, title) end
function Tab:StatusCard(title, defaultText, col) return Component.StatusCard(self._page, title, defaultText, col) end
function Tab:StartPulse(pulse, cond) return Component.StartPulse(pulse, cond) end
function Tab:Toggle(text, stateTable, key, callback) return Component.Toggle(self._page, text, stateTable, key, callback) end
function Tab:Slider(text, mn, mx, def, stateTable, key, callback) return Component.Slider(self._page, text, mn, mx, def, stateTable, key, callback) end
function Tab:Button(text, icon, col, callback) return Component.Button(self._page, text, icon, col, callback) end
function Tab:Dropdown(label, options, defaultIdx, callback) return Component.Dropdown(self._page, label, options, defaultIdx, callback) end
function Tab:RarityDropdown(rarities, rarColors, stateTable) return Component.RarityDropdown(self._page, rarities, rarColors, stateTable) end
function Tab:InfoStrip(text, col) return Component.InfoStrip(self._page, text, col) end
function Tab:Clear()
    for _, child in ipairs(self._page:GetChildren()) do
        if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
            child:Destroy()
        end
    end
    layoutCounters[self._page] = 0
end
function Tab:GetPage() return self._page end

local function Window(cfg)
    cfg = cfg or {}
    local TITLE = cfg.title or "Void Hub"
    local BADGE = cfg.badge or "v3"
    local LOGO = cfg.logo or Icons.logo
    local W = cfg.width or 520
    local H = cfg.height or 380
    local GNAME = cfg.guiName or "VoidHubLib"

    applyTheme(cfg.theme or CURRENT_THEME or "Void")

    local prev = CoreGui:FindFirstChild(GNAME)
    if prev then
        prev:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = GNAME
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 10
    ScreenGui.Parent = CoreGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "Main"
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.BackgroundColor3 = Colors.Bg
    MainFrame.BackgroundTransparency = 0.06
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Active = true
    MainFrame.Parent = ScreenGui
    corner(MainFrame, 16)
    local mainStroke = mkStroke(MainFrame, Colors.Accent, 1.5, 0.5)
    local mainGrad = Instance.new("UIGradient")
    mainGrad.Rotation = 90
    mainGrad.Parent = MainFrame
    setGradient(mainGrad, mix(Colors.BgCard, Colors.Bg, 0.35), Colors.Bg)

    task.spawn(function()
        MainFrame:TweenSizeAndPosition(
            UDim2.new(0, W, 0, H),
            UDim2.new(0.5, -W/2, 0.5, -H/2),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Back,
            0.45,
            true
        )
    end)

    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 48)
    TopBar.BackgroundColor3 = Colors.BgCard
    TopBar.BackgroundTransparency = 0.1
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    local tbLine = Instance.new("Frame", TopBar)
    tbLine.Size = UDim2.new(1, 0, 0, 1)
    tbLine.Position = UDim2.new(0, 0, 1, -1)
    tbLine.BackgroundColor3 = Colors.Accent
    tbLine.BackgroundTransparency = 0.6
    tbLine.BorderSizePixel = 0

    local LogoImg = Instance.new("ImageLabel")
    LogoImg.Name = "Logo"
    LogoImg.Size = UDim2.new(0, 28, 0, 28)
    LogoImg.Position = UDim2.new(0, 14, 0.5, -14)
    LogoImg.BackgroundTransparency = 1
    LogoImg.Image = LOGO
    LogoImg.Parent = TopBar

    local words = {}
    for w in tostring(TITLE):gmatch("%S+") do
        table.insert(words, w)
    end
    local word1 = words[1] or TITLE
    local word2 = (#words > 1) and table.concat(words, " ", 2) or nil

    local lv = Instance.new("TextLabel")
    lv.Text = word1
    lv.Font = Enum.Font.GothamBlack
    lv.TextSize = 18
    lv.TextColor3 = Colors.AccentHi
    lv.BackgroundTransparency = 1
    lv.TextXAlignment = Enum.TextXAlignment.Left
    lv.Size = UDim2.new(0, math.max(70, #word1 * 11), 1, 0)
    lv.Position = UDim2.new(0, 48, 0, 0)
    lv.Parent = TopBar

    local badgeOffsetX = 48 + math.max(70, #word1 * 11) + 4
    local lh
    local grad
    if word2 then
        lh = Instance.new("TextLabel")
        lh.Text = word2
        lh.Font = Enum.Font.GothamBlack
        lh.TextSize = 18
        lh.TextColor3 = Colors.TextPri
        lh.BackgroundTransparency = 1
        lh.TextXAlignment = Enum.TextXAlignment.Left
        lh.Size = UDim2.new(0, math.max(60, #word2 * 11), 1, 0)
        lh.Position = UDim2.new(0, 48 + math.max(70, #word1 * 11) + 4, 0, 0)
        lh.Parent = TopBar
        grad = Instance.new("UIGradient")
        grad.Parent = lh
        setGradient(grad, Colors.TextPri, Colors.AccentGlow)
        badgeOffsetX = badgeOffsetX + math.max(60, #word2 * 11) + 6
    end

    local VBadge = Instance.new("Frame")
    VBadge.Name = "Badge"
    VBadge.Size = UDim2.new(0, 56, 0, 18)
    VBadge.Position = UDim2.new(0, badgeOffsetX, 0.5, -9)
    VBadge.BackgroundColor3 = Colors.AccentDim
    VBadge.BackgroundTransparency = 0.2
    VBadge.BorderSizePixel = 0
    VBadge.Parent = TopBar
    corner(VBadge, 9)
    local vLbl2 = Instance.new("TextLabel")
    vLbl2.Text = BADGE
    vLbl2.Font = Enum.Font.GothamBold
    vLbl2.TextSize = 10
    vLbl2.TextColor3 = Colors.AccentGlow
    vLbl2.BackgroundTransparency = 1
    vLbl2.Size = UDim2.new(1, 0, 1, 0)
    vLbl2.Parent = VBadge

    local function ctrlBtn(icon, col, offX)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 30, 0, 30)
        b.Position = UDim2.new(1, offX, 0.5, -15)
        b.BackgroundColor3 = Colors.BgCard
        b.BackgroundTransparency = 0.28
        b.Text = ""
        b.AutoButtonColor = false
        b.Parent = TopBar
        corner(b, 8)
        local st = mkStroke(b, Colors.Border, 1, 0.8)
        local img = Instance.new("ImageLabel")
        img.Size = UDim2.new(0, 14, 0, 14)
        img.Position = UDim2.new(0.5, -7, 0.5, -7)
        img.BackgroundTransparency = 1
        img.Image = icon
        img.ImageColor3 = col
        img.Parent = b
        b.MouseEnter:Connect(function()
            sfx("hover")
            tw(b, { BackgroundTransparency = 0.04 }, 0.12)
            tw(st, { Color = col }, 0.12)
        end)
        b.MouseLeave:Connect(function()
            tw(b, { BackgroundTransparency = 0.28 }, 0.12)
            tw(st, { Color = Colors.Border }, 0.12)
        end)
        return b
    end

    local MinBtn = ctrlBtn(Icons.minimize, Colors.Yellow, -74)
    local CloseBtn = ctrlBtn(Icons.close, Colors.Red, -38)

    local SIDEBAR_W = 132
    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, SIDEBAR_W, 1, -48)
    Sidebar.Position = UDim2.new(0, 0, 0, 48)
    Sidebar.BackgroundColor3 = Colors.BgCard
    Sidebar.BackgroundTransparency = 0.14
    Sidebar.BorderSizePixel = 0
    Sidebar.ScrollBarThickness = 0
    Sidebar.ScrollingDirection = Enum.ScrollingDirection.Y
    Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
    Sidebar.ClipsDescendants = true
    Sidebar.Parent = MainFrame
    local sbL = Instance.new("UIListLayout")
    sbL.SortOrder = Enum.SortOrder.LayoutOrder
    sbL.Padding = UDim.new(0, 4)
    sbL.Parent = Sidebar
    local sbP = Instance.new("UIPadding")
    sbP.PaddingTop = UDim.new(0, 8)
    sbP.PaddingBottom = UDim.new(0, 8)
    sbP.PaddingLeft = UDim.new(0, 8)
    sbP.PaddingRight = UDim.new(0, 8)
    sbP.Parent = Sidebar

    local sbDiv = Instance.new("Frame")
    sbDiv.Size = UDim2.new(0, 1, 1, -48)
    sbDiv.Position = UDim2.new(0, SIDEBAR_W, 0, 48)
    sbDiv.BackgroundColor3 = Colors.Accent
    sbDiv.BackgroundTransparency = 0.72
    sbDiv.BorderSizePixel = 0
    sbDiv.Parent = MainFrame

    local ContentArea = Instance.new("Frame")
    ContentArea.Size = UDim2.new(1, -SIDEBAR_W - 1, 1, -48)
    ContentArea.Position = UDim2.new(0, SIDEBAR_W + 1, 0, 48)
    ContentArea.BackgroundTransparency = 1
    ContentArea.ClipsDescendants = true
    ContentArea.Parent = MainFrame

    local tabs = {}
    local activeTab = nil
    local tabOrder = 0

    local function activateTab(td)
        sfx("click")
        for _, t in ipairs(tabs) do
            t._page.Visible = false
            t._active = false
        end
        td._page.Visible = true
        td._active = true
        activeTab = td._name
        for _, t in ipairs(tabs) do
            local active = t._active == true
            tw(t._btn, { BackgroundTransparency = active and 0.18 or 0.72, BackgroundColor3 = active and Colors.AccentDim or Colors.BgHover }, 0.14)
            tw(t._bar, { Size = active and UDim2.new(0, 3, 0, 22) or UDim2.new(0, 3, 0, 0), Position = active and UDim2.new(0, 0, 0.5, -11) or UDim2.new(0, 0, 0.5, 0) }, 0.14)
            tw(t._ico, { ImageColor3 = active and Colors.AccentHi or Colors.TextMuted }, 0.14)
            tw(t._lbl, { TextColor3 = active and Colors.TextPri or Colors.TextMuted }, 0.14)
            tw(t._stroke, { Color = active and Colors.AccentHi or Colors.Border, Transparency = active and 0.3 or 0.8 }, 0.14)
        end
    end

    local isDragging, dragInput, dragStart, dragOrigin = false, nil, nil, nil
    TopBar.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStart = inp.Position
            dragOrigin = MainFrame.Position
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then
                    isDragging = false
                end
            end)
        end
    end)
    TopBar.InputChanged:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
            dragInput = inp
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if inp == dragInput and isDragging then
            local d = inp.Position - dragStart
            MainFrame.Position = UDim2.new(dragOrigin.X.Scale, dragOrigin.X.Offset + d.X, dragOrigin.Y.Scale, dragOrigin.Y.Offset + d.Y)
        end
    end)

    local menuOpen = true
    local function closeMenu()
        menuOpen = false
        MainFrame:TweenSizeAndPosition(UDim2.new(0, 0, 0, 0), UDim2.new(0.5, 0, 0.5, 0), Enum.EasingDirection.In, Enum.EasingStyle.Back, 0.28, true)
        tw(MainFrame, { BackgroundTransparency = 1 }, 0.22)
        task.delay(0.3, function()
            if MainFrame.Parent then
                MainFrame.Visible = false
            end
        end)
    end
    local function openMenu()
        menuOpen = true
        MainFrame.Visible = true
        MainFrame:TweenSizeAndPosition(UDim2.new(0, W, 0, H), UDim2.new(0.5, -W / 2, 0.5, -H / 2), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.38, true)
        tw(MainFrame, { BackgroundTransparency = 0.06 }, 0.22)
    end

    MinBtn.MouseButton1Click:Connect(function()
        sfx("close")
        closeMenu()
    end)
    CloseBtn.MouseButton1Click:Connect(function()
        sfx("close")
        ScreenGui:Destroy()
    end)

    local ToggleBtn = Instance.new("ImageButton")
    ToggleBtn.Name = "VHToggle"
    ToggleBtn.Size = UDim2.new(0, 48, 0, 48)
    ToggleBtn.Position = UDim2.new(0, 14, 0.5, -24)
    ToggleBtn.BackgroundColor3 = Colors.Bg
    ToggleBtn.BackgroundTransparency = 0.08
    ToggleBtn.Image = LOGO
    ToggleBtn.ScaleType = Enum.ScaleType.Fit
    ToggleBtn.ZIndex = 20
    ToggleBtn.Parent = ScreenGui
    corner(ToggleBtn, 24)
    local tbSt = mkStroke(ToggleBtn, Colors.AccentHi, 2, 0.15)

    local glowRing = Instance.new("Frame")
    glowRing.Size = UDim2.new(1, 10, 1, 10)
    glowRing.Position = UDim2.new(0, -5, 0, -5)
    glowRing.BackgroundTransparency = 1
    glowRing.BorderSizePixel = 0
    glowRing.ZIndex = 19
    glowRing.Parent = ToggleBtn
    corner(glowRing, 28)
    local gRingSt = mkStroke(glowRing, Colors.AccentHi, 2, 0.1)

    task.spawn(function()
        while ToggleBtn.Parent do
            tw(gRingSt, { Transparency = 0.85 }, 1.3, Enum.EasingStyle.Sine)
            task.wait(1.3)
            if not ToggleBtn.Parent then break end
            tw(gRingSt, { Transparency = 0.1 }, 1.3, Enum.EasingStyle.Sine)
            task.wait(1.3)
        end
    end)

    local tbDrag, tbDragStart, tbDragOrigin, tbDragDist = false, nil, nil, 0
    ToggleBtn.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            tbDrag = true
            tbDragDist = 0
            tbDragStart = inp.Position
            tbDragOrigin = ToggleBtn.Position
            local c
            c = inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then
                    tbDrag = false
                    if c then c:Disconnect() end
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if tbDrag and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            local d = inp.Position - tbDragStart
            tbDragDist = math.abs(d.X) + math.abs(d.Y)
            if tbDragDist > 4 then
                ToggleBtn.Position = UDim2.new(tbDragOrigin.X.Scale, tbDragOrigin.X.Offset + d.X, tbDragOrigin.Y.Scale, tbDragOrigin.Y.Offset + d.Y)
            end
        end
    end)
    ToggleBtn.MouseButton1Click:Connect(function()
        if tbDragDist > 7 then return end
        if menuOpen then
            sfx("close")
            closeMenu()
        else
            sfx("open")
            openMenu()
        end
    end)
    ToggleBtn.MouseEnter:Connect(function()
        tw(tbSt, { Transparency = 0.4 }, 0.15)
    end)
    ToggleBtn.MouseLeave:Connect(function()
        tw(tbSt, { Transparency = 0.15 }, 0.15)
    end)

    local win = {}

    function win:Tab(name, icon)
        tabOrder = tabOrder + 1
        local btn = Instance.new("TextButton")
        btn.Name = tostring(name) .. "Btn"
        btn.Size = UDim2.new(1, 0, 0, 36)
        btn.BackgroundColor3 = Colors.BgHover
        btn.BackgroundTransparency = 0.72
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.LayoutOrder = tabOrder
        btn.Parent = Sidebar
        corner(btn, 10)
        local btnSt = mkStroke(btn, Colors.Border, 1, 0.8)

        local bIco = Instance.new("ImageLabel")
        bIco.Size = UDim2.new(0, 14, 0, 14)
        bIco.Position = UDim2.new(0, 10, 0.5, -7)
        bIco.BackgroundTransparency = 1
        bIco.Image = icon or ""
        bIco.ImageColor3 = Colors.TextMuted
        bIco.Parent = btn

        local bTxt = Instance.new("TextLabel")
        bTxt.Text = tostring(name)
        bTxt.Font = Enum.Font.GothamBold
        bTxt.TextSize = 11
        bTxt.TextColor3 = Colors.TextMuted
        bTxt.Size = UDim2.new(1, -30, 1, 0)
        bTxt.Position = UDim2.new(0, 28, 0, 0)
        bTxt.BackgroundTransparency = 1
        bTxt.TextXAlignment = Enum.TextXAlignment.Left
        bTxt.Parent = btn

        local bar = Instance.new("Frame")
        bar.Size = UDim2.new(0, 3, 0, 0)
        bar.Position = UDim2.new(0, 0, 0.5, 0)
        bar.BackgroundColor3 = Colors.AccentHi
        bar.BorderSizePixel = 0
        bar.Parent = btn
        corner(bar, 2)

        local page = Instance.new("ScrollingFrame")
        page.Name = tostring(name) .. "Page"
        page.Size = UDim2.new(1, -6, 1, -6)
        page.Position = UDim2.new(0, 3, 0, 3)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = Colors.Accent
        page.ScrollingDirection = Enum.ScrollingDirection.Y
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.Visible = false
        page.Parent = ContentArea
        local pL = Instance.new("UIListLayout")
        pL.SortOrder = Enum.SortOrder.LayoutOrder
        pL.Padding = UDim.new(0, 4)
        pL.Parent = page
        local pP = Instance.new("UIPadding")
        pP.PaddingTop = UDim.new(0, 6)
        pP.PaddingBottom = UDim.new(0, 10)
        pP.PaddingLeft = UDim.new(0, 4)
        pP.PaddingRight = UDim.new(0, 4)
        pP.Parent = page

        local td = {
            _name = tostring(name), _btn = btn, _page = page, _bar = bar, _ico = bIco, _lbl = bTxt, _stroke = btnSt, _active = false,
        }
        table.insert(tabs, td)
        setmetatable(td, Tab)

        btn.MouseButton1Click:Connect(function()
            activateTab(td)
        end)
        btn.MouseEnter:Connect(function()
            if activeTab ~= td._name then
                sfx("hover")
                tw(btn, { BackgroundTransparency = 0.54 }, 0.1)
            end
        end)
        btn.MouseLeave:Connect(function()
            if activeTab ~= td._name then
                tw(btn, { BackgroundTransparency = 0.72 }, 0.1)
            end
        end)

        if #tabs == 1 then
            activateTab(td)
        end

        registerThemeListener(function()
            if btn.Parent then
                local active = td._active == true
                btn.BackgroundColor3 = active and Colors.AccentDim or Colors.BgHover
                btn.BackgroundTransparency = active and 0.18 or 0.72
                btnSt.Color = active and Colors.AccentHi or Colors.Border
                btnSt.Transparency = active and 0.3 or 0.8
                bIco.ImageColor3 = active and Colors.AccentHi or Colors.TextMuted
                bTxt.TextColor3 = active and Colors.TextPri or Colors.TextMuted
                bar.BackgroundColor3 = Colors.AccentHi
                page.ScrollBarImageColor3 = Colors.Accent
            end
        end)

        return td
    end

    local function syncChrome()
        MainFrame.BackgroundColor3 = Colors.Bg
        mainStroke.Color = Colors.Accent
        MainFrame.BackgroundTransparency = 0.06
        TopBar.BackgroundColor3 = Colors.BgCard
        tbLine.BackgroundColor3 = Colors.Accent
        tbLine.BackgroundTransparency = 0.6
        Sidebar.BackgroundColor3 = Colors.BgCard
        sbDiv.BackgroundColor3 = Colors.Accent
        sbDiv.BackgroundTransparency = 0.72
        ToggleBtn.BackgroundColor3 = Colors.Bg
        tbSt.Color = Colors.AccentHi
        gRingSt.Color = Colors.AccentHi
        LogoImg.Image = LOGO
        VBadge.BackgroundColor3 = Colors.AccentDim
        vLbl2.TextColor3 = Colors.AccentGlow
        if lh then
            lh.TextColor3 = Colors.TextPri
            if grad then
                setGradient(grad, Colors.TextPri, Colors.AccentGlow)
            end
        end
        if MainFrame.Parent then
            setGradient(mainGrad, mix(Colors.BgCard, Colors.Bg, 0.35), Colors.Bg)
        end
        for _, t in ipairs(tabs) do
            local active = t._active == true
            t._btn.BackgroundColor3 = active and Colors.AccentDim or Colors.BgHover
            t._btn.BackgroundTransparency = active and 0.18 or 0.72
            t._stroke.Color = active and Colors.AccentHi or Colors.Border
            t._stroke.Transparency = active and 0.3 or 0.8
            t._ico.ImageColor3 = active and Colors.AccentHi or Colors.TextMuted
            t._lbl.TextColor3 = active and Colors.TextPri or Colors.TextMuted
            t._bar.BackgroundColor3 = Colors.AccentHi
            t._page.ScrollBarImageColor3 = Colors.Accent
        end
    end
    registerThemeListener(syncChrome)

    function win:SetTheme(name)
        applyTheme(name)
        return CURRENT_THEME
    end
    function win:GetTheme()
        return CURRENT_THEME
    end
    function win:GetThemes()
        local out = {}
        for i, v in ipairs(THEME_NAMES) do
            out[i] = v
        end
        return out
    end
    function win:RefreshTheme()
        return self:SetTheme(CURRENT_THEME)
    end
    function win:Open()
        openMenu()
    end
    function win:Close()
        closeMenu()
    end
    function win:Destroy()
        if ScreenGui then
            ScreenGui:Destroy()
        end
    end
    function win:GetGui()
        return ScreenGui
    end

    return win
end

return {
    Window = Window,
    Component = Component,
    Colors = Colors,
    Themes = THEMES,
    Icons = Icons,
    Sfx = sfx,
}
