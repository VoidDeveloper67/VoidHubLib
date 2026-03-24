--[[
╔══════════════════════════════════════════════════════════════════╗
║              VoidHub UI Library  —  main.lua  v2.1              ║
║         Extracted from VoidHub v2  (vonplayz_real &             ║
║                       DarealBloxfruiter)                        ║
║               discord.gg/C5gUXQ5qYN                             ║
╚══════════════════════════════════════════════════════════════════╝

  QUICK START
  ───────────
    local VHL = loadstring(game:HttpGet("YOUR_RAW_URL"))()

    local win = VHL.Window({
        title  = "My Hub",
        badge  = "v1",
        theme  = "Void",        -- optional, default "Void"
        width  = 480,
        height = 360,
    })

    local farmTab = win:Tab("Farm", VHL.Icons.farm)

    farmTab:Section("Settings")
    farmTab:Toggle("Enable Farm", myState, "FarmEnabled", function(state) end)
    farmTab:Slider("Speed", 0.05, 1, 0.15, myState, "FarmSpeed")
    farmTab:Button("Go!", VHL.Icons.farm, nil, function() end)
    farmTab:Dropdown("Mode", {"1","5","10"}, 1, function(idx, opt) end)
    farmTab:InfoStrip("ℹ  Some hint text here")
    local valueLbl, pulse, setActive = farmTab:StatusCard("Status","IDLE")

  THEMES  (pass theme = "Name" to Window)
  ─────────────────────────────────────────
    "Void"      — deep purple/violet (default, original VoidHub look)
    "Midnight"  — cool navy-blue dark
    "Crimson"   — red + dark steel
    "Emerald"   — forest green on near-black
    "Gold"      — warm amber on dark charcoal
    "Arctic"    — light icy whites and pale blues (light theme)

  Change theme at runtime:  win:SetTheme("Crimson")
]]

-- ═══════════════════════════════════════════════════════════════════
--  SERVICES
-- ═══════════════════════════════════════════════════════════════════

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local SoundService     = game:GetService("SoundService")
local CoreGui          = game:GetService("CoreGui")
local LocalPlayer      = Players.LocalPlayer

-- ═══════════════════════════════════════════════════════════════════
--  THEME DEFINITIONS
--  Each theme is a full palette table.  Keys must match exactly.
-- ═══════════════════════════════════════════════════════════════════

local function rgb(r,g,b) return Color3.fromRGB(r,g,b) end
local WHITE = Color3.new(1,1,1)

local THEMES = {

    -- ── Void  (original VoidHub purple) ──────────────────────────
    Void = {
        Bg         = rgb(11,11,20),
        BgCard     = rgb(17,17,30),
        BgItem     = rgb(22,22,38),
        BgHover    = rgb(28,28,46),
        Border     = rgb(42,42,68),
        BorderHi   = rgb(70,40,120),
        Accent     = rgb(130,60,230),
        AccentHi   = rgb(165,90,255),
        AccentDim  = rgb(75,20,150),
        AccentGlow = rgb(190,130,255),
        Green      = rgb(40,200,100),
        GreenDim   = rgb(20,110,55),
        Red        = rgb(235,65,65),
        Yellow     = rgb(230,175,10),
        Blue       = rgb(60,130,245),
        White      = WHITE,
        TextPri    = WHITE,
        TextSec    = rgb(185,180,215),
        TextMuted  = rgb(105,100,140),
        Discord    = rgb(88,101,242),
        DisGreen   = rgb(59,165,93),
    },

    -- ── Midnight  (cool navy) ─────────────────────────────────────
    Midnight = {
        Bg         = rgb(8,12,22),
        BgCard     = rgb(12,18,34),
        BgItem     = rgb(16,24,44),
        BgHover    = rgb(20,30,54),
        Border     = rgb(30,45,80),
        BorderHi   = rgb(50,90,180),
        Accent     = rgb(50,110,240),
        AccentHi   = rgb(80,150,255),
        AccentDim  = rgb(20,60,140),
        AccentGlow = rgb(130,185,255),
        Green      = rgb(40,200,120),
        GreenDim   = rgb(20,110,60),
        Red        = rgb(220,60,60),
        Yellow     = rgb(220,175,20),
        Blue       = rgb(60,130,245),
        White      = WHITE,
        TextPri    = WHITE,
        TextSec    = rgb(170,185,220),
        TextMuted  = rgb(80,100,145),
        Discord    = rgb(88,101,242),
        DisGreen   = rgb(59,165,93),
    },

    -- ── Crimson  (deep red steel) ─────────────────────────────────
    Crimson = {
        Bg         = rgb(14,8,10),
        BgCard     = rgb(22,12,14),
        BgItem     = rgb(30,16,18),
        BgHover    = rgb(38,20,22),
        Border     = rgb(65,28,32),
        BorderHi   = rgb(130,40,50),
        Accent     = rgb(210,35,55),
        AccentHi   = rgb(245,65,80),
        AccentDim  = rgb(110,15,25),
        AccentGlow = rgb(255,110,120),
        Green      = rgb(50,200,100),
        GreenDim   = rgb(20,110,55),
        Red        = rgb(255,80,80),
        Yellow     = rgb(230,175,10),
        Blue       = rgb(70,140,255),
        White      = WHITE,
        TextPri    = WHITE,
        TextSec    = rgb(220,185,185),
        TextMuted  = rgb(130,90,95),
        Discord    = rgb(88,101,242),
        DisGreen   = rgb(59,165,93),
    },

    -- ── Emerald  (forest green) ───────────────────────────────────
    Emerald = {
        Bg         = rgb(8,14,10),
        BgCard     = rgb(12,20,14),
        BgItem     = rgb(16,28,18),
        BgHover    = rgb(20,36,23),
        Border     = rgb(28,55,32),
        BorderHi   = rgb(40,110,55),
        Accent     = rgb(30,175,80),
        AccentHi   = rgb(50,220,100),
        AccentDim  = rgb(12,90,38),
        AccentGlow = rgb(100,255,150),
        Green      = rgb(40,220,100),
        GreenDim   = rgb(15,100,45),
        Red        = rgb(220,65,65),
        Yellow     = rgb(210,185,30),
        Blue       = rgb(60,140,240),
        White      = WHITE,
        TextPri    = WHITE,
        TextSec    = rgb(175,215,180),
        TextMuted  = rgb(80,130,90),
        Discord    = rgb(88,101,242),
        DisGreen   = rgb(59,165,93),
    },

    -- ── Gold  (warm amber charcoal) ───────────────────────────────
    Gold = {
        Bg         = rgb(14,11,6),
        BgCard     = rgb(22,17,8),
        BgItem     = rgb(30,23,10),
        BgHover    = rgb(38,29,12),
        Border     = rgb(65,50,18),
        BorderHi   = rgb(130,100,30),
        Accent     = rgb(210,155,20),
        AccentHi   = rgb(250,195,40),
        AccentDim  = rgb(110,78,8),
        AccentGlow = rgb(255,225,110),
        Green      = rgb(50,195,100),
        GreenDim   = rgb(20,105,52),
        Red        = rgb(225,65,65),
        Yellow     = rgb(255,200,40),
        Blue       = rgb(70,140,240),
        White      = WHITE,
        TextPri    = WHITE,
        TextSec    = rgb(225,205,160),
        TextMuted  = rgb(130,105,55),
        Discord    = rgb(88,101,242),
        DisGreen   = rgb(59,165,93),
    },

    -- ── Arctic  (icy light theme) ─────────────────────────────────
    Arctic = {
        Bg         = rgb(235,240,250),
        BgCard     = rgb(220,228,242),
        BgItem     = rgb(205,215,235),
        BgHover    = rgb(190,202,228),
        Border     = rgb(160,175,210),
        BorderHi   = rgb(100,135,210),
        Accent     = rgb(60,120,230),
        AccentHi   = rgb(40,95,210),
        AccentDim  = rgb(180,200,240),
        AccentGlow = rgb(30,80,200),
        Green      = rgb(20,160,80),
        GreenDim   = rgb(160,220,185),
        Red        = rgb(210,45,45),
        Yellow     = rgb(190,145,5),
        Blue       = rgb(40,100,215),
        White      = WHITE,
        TextPri    = rgb(15,20,40),
        TextSec    = rgb(50,65,110),
        TextMuted  = rgb(110,125,165),
        Discord    = rgb(88,101,242),
        DisGreen   = rgb(59,165,93),
    },
}

-- Active palette (starts as Void, swapped by SetTheme)
local P = {}
for k,v in pairs(THEMES.Void) do P[k] = v end

local function applyTheme(name)
    local t = THEMES[name]
    if not t then
        warn("[VoidHubLib] Unknown theme: '"..tostring(name).."'. Using Void.")
        t = THEMES.Void
    end
    for k,v in pairs(t) do P[k] = v end
end

-- ═══════════════════════════════════════════════════════════════════
--  ICON ASSET IDS
-- ═══════════════════════════════════════════════════════════════════

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

-- ═══════════════════════════════════════════════════════════════════
--  SFX
-- ═══════════════════════════════════════════════════════════════════

local SFX_IDS = {
    hover = "rbxassetid://9113083740",
    click = "rbxassetid://9114488953",
    on    = "rbxassetid://9114488953",
    off   = "rbxassetid://9113083740",
    ok    = "rbxassetid://9114488953",
    open  = "rbxassetid://9114488953",
    close = "rbxassetid://9113083740",
}

local function sfx(t)
    local id = SFX_IDS[t]
    if not id then return end
    task.spawn(function()
        pcall(function()
            local s = Instance.new("Sound")
            s.SoundId = id; s.Volume = 0.22; s.Parent = SoundService
            s:Play()
            task.delay(1.5, function() if s then s:Destroy() end end)
        end)
    end)
end

-- ═══════════════════════════════════════════════════════════════════
--  CONFETTI
-- ═══════════════════════════════════════════════════════════════════

local activeConfetti = 0

local function spawnConfetti(screenGui, pos)
    if activeConfetti > 60 then return end
    local cols = {P.AccentHi, P.Green, P.Red, P.Yellow, P.Blue,
        rgb(255,80,80), rgb(80,220,80), rgb(255,200,60)}
    for _ = 1, 12 do
        activeConfetti += 1
        local f = Instance.new("Frame")
        f.Size = UDim2.new(0, math.random(5,9), 0, math.random(5,9))
        f.Position = pos
        f.BackgroundColor3 = cols[math.random(1,#cols)]
        f.BorderSizePixel = 0; f.Rotation = math.random(0,360); f.ZIndex = 999
        f.Parent = screenGui
        local c = Instance.new("UICorner", f); c.CornerRadius = UDim.new(0,2)
        local a = math.random(0,360)*(math.pi/180)
        local d = math.random(60,170)
        TweenService:Create(f, TweenInfo.new(math.random(8,12)/10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(pos.X.Scale, pos.X.Offset+math.cos(a)*d,
                                 pos.Y.Scale, pos.Y.Offset+math.sin(a)*d+110),
            Rotation = math.random(360,720), BackgroundTransparency = 1,
        }):Play()
        task.delay(1.2, function()
            if f then f:Destroy() end
            activeConfetti = math.max(0, activeConfetti-1)
        end)
    end
end

-- ═══════════════════════════════════════════════════════════════════
--  INTERNAL HELPERS
-- ═══════════════════════════════════════════════════════════════════

local function tw(obj, props, t, style, dir)
    TweenService:Create(obj,
        TweenInfo.new(t or 0.15, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out),
        props):Play()
end

local function corner(parent, radius)
    local c = Instance.new("UICorner", parent)
    c.CornerRadius = UDim.new(0, radius or 8)
    return c
end

local function mkStroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke", parent)
    s.Color = color or P.Border
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    return s
end

local layoutCounters = {}
local function nextOrder(parent)
    layoutCounters[parent] = (layoutCounters[parent] or 0) + 1
    return layoutCounters[parent]
end

-- ═══════════════════════════════════════════════════════════════════
--  COMPONENT LIBRARY
--  All functions accept a parent Frame/ScrollingFrame as first arg.
--  They do NOT assume a specific global state table – you pass your
--  own stateTable + key to Toggle and Slider.
-- ═══════════════════════════════════════════════════════════════════

local Component = {}

-- ─── Section ─────────────────────────────────────────────────────
--  Renders a labelled divider row.
--  Returns: Frame
function Component.Section(parent, title)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1,0,0,22)
    f.BackgroundTransparency = 1
    f.LayoutOrder = nextOrder(parent)

    local lbl = Instance.new("TextLabel", f)
    lbl.Text = title:upper()
    lbl.Font = Enum.Font.GothamBlack; lbl.TextSize = 10
    lbl.TextColor3 = P.AccentHi
    lbl.Size = UDim2.new(1,-4,0,14); lbl.Position = UDim2.new(0,2,0,4)
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local line = Instance.new("Frame", f)
    line.Size = UDim2.new(1,0,0,1); line.Position = UDim2.new(0,0,1,-1)
    line.BackgroundColor3 = P.Accent
    line.BackgroundTransparency = 0.62; line.BorderSizePixel = 0
    corner(line, 1)
    return f
end

-- ─── StatusCard ───────────────────────────────────────────────────
--  Animated info card showing a title + large value string.
--  Returns: valueLbl (TextLabel), pulseFrame (Frame), setActive (func)
--    setActive(bool) — lights up or dims the card's indicators.
--  Use StartPulse(pulseFrame, conditionFunc) to animate the glow.
function Component.StatusCard(parent, title, defaultText, accentColor)
    local col = accentColor or P.Green
    local card = Instance.new("Frame", parent)
    card.Size = UDim2.new(1,0,0,54)
    card.LayoutOrder = nextOrder(parent)
    card.BackgroundColor3 = P.BgItem
    card.BackgroundTransparency = 0.1
    card.BorderSizePixel = 0
    corner(card, 10)
    local st = mkStroke(card, P.Border, 1, 0.5)

    local acBar = Instance.new("Frame", card)
    acBar.Size = UDim2.new(0,3,0.7,0); acBar.Position = UDim2.new(0,0,0.15,0)
    acBar.BackgroundColor3 = col; acBar.BorderSizePixel = 0; corner(acBar, 2)

    local dot = Instance.new("Frame", card)
    dot.Size = UDim2.new(0,8,0,8); dot.Position = UDim2.new(1,-20,0,10)
    dot.BackgroundColor3 = P.TextMuted; dot.BorderSizePixel = 0; corner(dot, 4)

    local pulse = Instance.new("Frame", card)
    pulse.Size = UDim2.new(1,0,1,0)
    pulse.BackgroundColor3 = col
    pulse.BackgroundTransparency = 1; pulse.ZIndex = 0; pulse.BorderSizePixel = 0
    corner(pulse, 10)

    local t1 = Instance.new("TextLabel", card)
    t1.Text = title; t1.Font = Enum.Font.GothamBold; t1.TextSize = 9
    t1.TextColor3 = P.TextMuted
    t1.Size = UDim2.new(1,-28,0,13); t1.Position = UDim2.new(0,14,0,9)
    t1.BackgroundTransparency = 1; t1.TextXAlignment = Enum.TextXAlignment.Left

    local valueLbl = Instance.new("TextLabel", card)
    valueLbl.Text = defaultText
    valueLbl.Font = Enum.Font.GothamBlack; valueLbl.TextSize = 16
    valueLbl.TextColor3 = P.TextPri
    valueLbl.Size = UDim2.new(1,-28,0,24); valueLbl.Position = UDim2.new(0,14,0,24)
    valueLbl.BackgroundTransparency = 1; valueLbl.TextXAlignment = Enum.TextXAlignment.Left

    local function setActive(active)
        local c = active and col or P.TextMuted
        tw(dot,   {BackgroundColor3 = c},                          0.2)
        tw(st,    {Color = active and col or P.Border, Transparency = 0.5}, 0.2)
        tw(acBar, {BackgroundColor3 = c},                          0.2)
    end

    return valueLbl, pulse, setActive
end

-- ─── StartPulse ───────────────────────────────────────────────────
--  Drives the glow pulse on a pulseFrame returned from StatusCard.
--  Runs until cond() returns false.
function Component.StartPulse(pulse, cond)
    task.spawn(function()
        while pulse and pulse.Parent and cond() do
            tw(pulse, {BackgroundTransparency = 0.82}, 1.5)
            task.wait(1.5)
            if not (pulse and pulse.Parent and cond()) then break end
            tw(pulse, {BackgroundTransparency = 1}, 1.5)
            task.wait(1.5)
        end
        if pulse and pulse.Parent then pulse.BackgroundTransparency = 1 end
    end)
end

-- ─── Toggle ───────────────────────────────────────────────────────
--  On/off toggle row.  stateTable[key] is read and written directly.
--  Returns: row (Frame), refresh (func)  — call refresh() to force
--  the visual to sync if you change stateTable[key] externally.
function Component.Toggle(parent, text, stateTable, key, callback)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1,0,0,34)
    row.LayoutOrder = nextOrder(parent)
    row.BackgroundColor3 = P.BgItem
    row.BackgroundTransparency = 0.35; row.BorderSizePixel = 0
    corner(row)
    local rst = mkStroke(row, P.Border, 1, 0.65)

    local lbl = Instance.new("TextLabel", row)
    lbl.Text = text; lbl.Font = Enum.Font.GothamSemibold; lbl.TextSize = 11
    lbl.TextColor3 = P.TextPri
    lbl.Size = UDim2.new(1,-58,1,0); lbl.Position = UDim2.new(0,12,0,0)
    lbl.BackgroundTransparency = 1; lbl.TextXAlignment = Enum.TextXAlignment.Left

    local track = Instance.new("Frame", row)
    track.Size = UDim2.new(0,36,0,18); track.Position = UDim2.new(1,-46,0.5,-9)
    track.BackgroundColor3 = P.Border; track.BorderSizePixel = 0; corner(track, 9)
    local knob = Instance.new("Frame", track)
    knob.Size = UDim2.new(0,14,0,14); knob.Position = UDim2.new(0,2,0.5,-7)
    knob.BackgroundColor3 = P.White; knob.BorderSizePixel = 0; corner(knob, 7)

    local function applyVisual(en)
        if en then
            tw(track, {BackgroundColor3 = P.Accent},                   0.18)
            tw(knob,  {Position = UDim2.new(0,20,0.5,-7)},             0.18)
            tw(rst,   {Color = P.AccentHi, Transparency = 0.5},        0.18)
        else
            tw(track, {BackgroundColor3 = P.Border},                   0.18)
            tw(knob,  {Position = UDim2.new(0,2,0.5,-7)},              0.18)
            tw(rst,   {Color = P.Border, Transparency = 0.65},         0.18)
        end
    end
    applyVisual(stateTable[key] == true)

    local hit = Instance.new("TextButton", row)
    hit.Size = UDim2.new(1,0,1,0); hit.BackgroundTransparency = 1; hit.Text = ""
    hit.MouseButton1Click:Connect(function()
        stateTable[key] = not stateTable[key]
        sfx(stateTable[key] and "on" or "off")
        applyVisual(stateTable[key])
        if callback then callback(stateTable[key]) end
    end)
    row.MouseEnter:Connect(function() sfx("hover"); tw(row, {BackgroundTransparency=0.15}, 0.1) end)
    row.MouseLeave:Connect(function() tw(row, {BackgroundTransparency=0.35}, 0.1) end)

    return row, function() applyVisual(stateTable[key] == true) end
end

-- ─── Slider ───────────────────────────────────────────────────────
--  Drag slider + editable text box.  stateTable[key] is written.
--  Returns: row (Frame)
function Component.Slider(parent, text, sMin, sMax, sDefault, stateTable, key, callback)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1,0,0,50)
    row.LayoutOrder = nextOrder(parent)
    row.BackgroundColor3 = P.BgItem
    row.BackgroundTransparency = 0.35; row.BorderSizePixel = 0
    corner(row); mkStroke(row, P.Border, 1, 0.65)

    local lbl = Instance.new("TextLabel", row)
    lbl.Text = text; lbl.Font = Enum.Font.GothamSemibold; lbl.TextSize = 11
    lbl.TextColor3 = P.TextPri
    lbl.Size = UDim2.new(1,-72,0,16); lbl.Position = UDim2.new(0,12,0,8)
    lbl.BackgroundTransparency = 1; lbl.TextXAlignment = Enum.TextXAlignment.Left

    local vBox = Instance.new("Frame", row)
    vBox.Size = UDim2.new(0,44,0,18); vBox.Position = UDim2.new(1,-56,0,7)
    vBox.BackgroundColor3 = P.Bg; vBox.BorderSizePixel = 0; corner(vBox, 4)
    mkStroke(vBox, P.Accent, 1, 0.5)
    local vLbl = Instance.new("TextBox", vBox)
    vLbl.Text = tostring(sDefault)
    vLbl.Font = Enum.Font.GothamBold; vLbl.TextSize = 11
    vLbl.TextColor3 = P.AccentHi; vLbl.Size = UDim2.new(1,0,1,0)
    vLbl.BackgroundTransparency = 1; vLbl.ClearTextOnFocus = false
    vLbl.PlaceholderColor3 = P.TextMuted

    local trackF = Instance.new("Frame", row)
    trackF.Size = UDim2.new(1,-24,0,4); trackF.Position = UDim2.new(0,12,0,35)
    trackF.BackgroundColor3 = P.Border; trackF.BorderSizePixel = 0; corner(trackF, 2)

    local fill = Instance.new("Frame", trackF)
    local initP = (sDefault-sMin)/(sMax-sMin)
    fill.Size = UDim2.new(initP,0,1,0)
    fill.BackgroundColor3 = P.Accent; fill.BorderSizePixel = 0; corner(fill, 2)
    local fGrad = Instance.new("UIGradient", fill)
    fGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, P.AccentDim),
        ColorSequenceKeypoint.new(1, P.AccentGlow),
    })

    local knob = Instance.new("Frame", trackF)
    knob.Size = UDim2.new(0,12,0,12); knob.Position = UDim2.new(initP,-6,0.5,-6)
    knob.BackgroundColor3 = P.White; knob.BorderSizePixel = 0; knob.ZIndex = 3; corner(knob, 6)
    mkStroke(knob, P.AccentHi, 2)

    stateTable[key] = stateTable[key] or sDefault

    local function commit(val)
        local p = math.clamp((val-sMin)/(sMax-sMin), 0, 1)
        fill.Size = UDim2.new(p,0,1,0); knob.Position = UDim2.new(p,-6,0.5,-6)
        vLbl.Text = tostring(val); stateTable[key] = val
        if callback then callback(val) end
    end

    local function applyInput(inp)
        local p   = math.clamp((inp.Position.X-trackF.AbsolutePosition.X)/trackF.AbsoluteSize.X, 0, 1)
        local val = sMin + p*(sMax-sMin)
        val = (sMax-sMin)>1 and math.floor(val+0.5) or math.floor(val*100+0.5)/100
        commit(val)
    end

    vLbl.FocusLost:Connect(function()
        local num = tonumber(vLbl.Text)
        if num then
            commit(math.clamp((sMax-sMin)>1 and math.floor(num+0.5) or math.floor(num*100+0.5)/100, sMin, sMax))
        else
            vLbl.Text = tostring(stateTable[key] or sDefault)
        end
    end)

    local dragging, moveConn, endConn = false, nil, nil
    local function stopDrag()
        dragging = false; tw(knob, {Size=UDim2.new(0,12,0,12)}, 0.12)
        if moveConn then moveConn:Disconnect(); moveConn = nil end
        if endConn  then endConn:Disconnect();  endConn  = nil end
    end
    local function startDrag()
        if dragging then return end; dragging = true
        tw(knob, {Size=UDim2.new(0,15,0,15)}, 0.12)
        moveConn = UserInputService.InputChanged:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseMovement
            or i.UserInputType == Enum.UserInputType.Touch then applyInput(i) end
        end)
        endConn = UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1
            or i.UserInputType == Enum.UserInputType.Touch then stopDrag() end
        end)
    end
    knob.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then startDrag() end
    end)
    trackF.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then applyInput(i); startDrag() end
    end)
    row.MouseEnter:Connect(function() sfx("hover"); tw(row,{BackgroundTransparency=0.15},0.1) end)
    row.MouseLeave:Connect(function() tw(row,{BackgroundTransparency=0.35},0.1) end)
    return row
end

-- ─── Button ───────────────────────────────────────────────────────
--  Styled clickable button with optional left icon.
--  col defaults to P.AccentDim if nil.
--  Returns: TextButton
function Component.Button(parent, text, icon, col, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1,0,0,34); btn.LayoutOrder = nextOrder(parent)
    btn.BackgroundColor3 = col or P.AccentDim
    btn.BackgroundTransparency = 0.3; btn.Text = ""; btn.AutoButtonColor = false
    corner(btn)
    local bst = mkStroke(btn, col or P.AccentHi, 1, 0.55)

    if icon then
        local im = Instance.new("ImageLabel", btn)
        im.Size = UDim2.new(0,14,0,14); im.Position = UDim2.new(0,10,0.5,-7)
        im.BackgroundTransparency = 1; im.Image = icon; im.ImageColor3 = P.TextPri
    end
    local lbl = Instance.new("TextLabel", btn)
    lbl.Text = text; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 12
    lbl.TextColor3 = P.TextPri
    lbl.Size = UDim2.new(1, icon and -30 or -14, 1, 0)
    lbl.Position = UDim2.new(0, icon and 28 or 10, 0, 0)
    lbl.BackgroundTransparency = 1; lbl.TextXAlignment = Enum.TextXAlignment.Left

    btn.MouseButton1Click:Connect(function()
        sfx("ok")
        tw(btn, {Size=UDim2.new(0.97,0,0,32)}, 0.07)
        task.delay(0.07, function() tw(btn,{Size=UDim2.new(1,0,0,34)},0.12,Enum.EasingStyle.Back) end)
        callback()
    end)
    btn.MouseEnter:Connect(function()
        sfx("hover"); tw(btn,{BackgroundTransparency=0},0.1); tw(bst,{Transparency=0.2},0.1)
    end)
    btn.MouseLeave:Connect(function()
        tw(btn,{BackgroundTransparency=0.3},0.1); tw(bst,{Transparency=0.55},0.1)
    end)
    return btn
end

-- ─── Dropdown ─────────────────────────────────────────────────────
--  Single-select animated dropdown.
--  callback(selectedIndex: number, selectedOption: string)
--  Returns: wrapper Frame
function Component.Dropdown(parent, label, options, defaultIdx, callback)
    local cur      = defaultIdx or 1
    local open     = false
    local TARGET_H = #options * 30 + 8

    local wrap = Instance.new("Frame", parent)
    wrap.Size = UDim2.new(1,0,0,34); wrap.LayoutOrder = nextOrder(parent)
    wrap.BackgroundTransparency = 1; wrap.BorderSizePixel = 0
    wrap.ClipsDescendants = false; wrap.ZIndex = 50

    local header = Instance.new("TextButton", wrap)
    header.Size = UDim2.new(1,0,0,34); header.BackgroundColor3 = P.BgItem
    header.BackgroundTransparency = 0.2; header.Text = ""; header.AutoButtonColor = false
    header.ZIndex = 51; corner(header)
    local hst = mkStroke(header, P.Border, 1, 0.5)

    local lLbl = Instance.new("TextLabel", header)
    lLbl.Text = label; lLbl.Font = Enum.Font.GothamSemibold; lLbl.TextSize = 10
    lLbl.TextColor3 = P.TextMuted
    lLbl.Size = UDim2.new(0.44,0,1,0); lLbl.Position = UDim2.new(0,12,0,0)
    lLbl.BackgroundTransparency = 1; lLbl.TextXAlignment = Enum.TextXAlignment.Left; lLbl.ZIndex = 52

    local vLbl = Instance.new("TextLabel", header)
    vLbl.Text = options[cur]; vLbl.Font = Enum.Font.GothamBlack; vLbl.TextSize = 12
    vLbl.TextColor3 = P.AccentHi
    vLbl.Size = UDim2.new(0.4,0,1,0); vLbl.Position = UDim2.new(0.44,0,0,0)
    vLbl.BackgroundTransparency = 1; vLbl.TextXAlignment = Enum.TextXAlignment.Left; vLbl.ZIndex = 52

    local arrow = Instance.new("ImageLabel", header)
    arrow.Size = UDim2.new(0,12,0,12); arrow.Position = UDim2.new(1,-22,0.5,-6)
    arrow.BackgroundTransparency = 1; arrow.Image = Icons.chevD
    arrow.ImageColor3 = P.TextMuted; arrow.ZIndex = 52

    local list = Instance.new("Frame", wrap)
    list.Size = UDim2.new(1,0,0,0); list.Position = UDim2.new(0,0,0,36)
    list.BackgroundColor3 = P.BgCard; list.BackgroundTransparency = 0.04
    list.BorderSizePixel = 0; list.ClipsDescendants = true
    list.Visible = false; list.ZIndex = 60
    corner(list); mkStroke(list, P.AccentHi, 1, 0.3)

    local lLayout = Instance.new("UIListLayout", list)
    lLayout.SortOrder = Enum.SortOrder.LayoutOrder; lLayout.Padding = UDim.new(0,3)
    local lPad = Instance.new("UIPadding", list)
    lPad.PaddingTop=UDim.new(0,4); lPad.PaddingBottom=UDim.new(0,4)
    lPad.PaddingLeft=UDim.new(0,4); lPad.PaddingRight=UDim.new(0,4)

    for i, opt in ipairs(options) do
        local row = Instance.new("TextButton", list)
        row.Size = UDim2.new(1,0,0,28); row.LayoutOrder = i
        row.BackgroundColor3 = i==cur and P.AccentDim or P.BgHover
        row.BackgroundTransparency = i==cur and 0.2 or 0.5
        row.Text = opt; row.Font = Enum.Font.GothamBold; row.TextSize = 11
        row.TextColor3 = i==cur and P.AccentHi or P.TextSec
        row.AutoButtonColor = false; row.ZIndex = 61; corner(row, 6)

        row.MouseButton1Click:Connect(function()
            sfx("click"); cur = i; vLbl.Text = opt
            for _, r in ipairs(list:GetChildren()) do
                if r:IsA("TextButton") then
                    tw(r, {BackgroundTransparency=0.5, TextColor3=P.TextSec, BackgroundColor3=P.BgHover}, 0.12)
                end
            end
            tw(row, {BackgroundTransparency=0.2, TextColor3=P.AccentHi, BackgroundColor3=P.AccentDim}, 0.12)
            open = false
            tw(list,  {Size=UDim2.new(1,0,0,0)}, 0.18)
            tw(arrow, {Rotation=0},               0.18)
            tw(hst,   {Color=P.Border, Transparency=0.5}, 0.18)
            task.delay(0.18, function() list.Visible = false end)
            wrap.Size = UDim2.new(1,0,0,34)
            if callback then callback(i, opt) end
        end)
        row.MouseEnter:Connect(function() if i~=cur then tw(row,{BackgroundTransparency=0.3},0.1) end end)
        row.MouseLeave:Connect(function() if i~=cur then tw(row,{BackgroundTransparency=0.5},0.1) end end)
    end

    header.MouseButton1Click:Connect(function()
        sfx("click"); open = not open
        if open then
            list.Visible = true; list.Size = UDim2.new(1,0,0,0)
            tw(list,  {Size=UDim2.new(1,0,0,TARGET_H)}, 0.22, Enum.EasingStyle.Back)
            tw(arrow, {Rotation=180},                   0.18)
            tw(hst,   {Color=P.AccentHi, Transparency=0.2}, 0.18)
            wrap.Size = UDim2.new(1,0,0,34+TARGET_H+4)
        else
            tw(list,  {Size=UDim2.new(1,0,0,0)}, 0.15)
            tw(arrow, {Rotation=0},               0.15)
            tw(hst,   {Color=P.Border, Transparency=0.5}, 0.15)
            task.delay(0.15, function() list.Visible = false end)
            wrap.Size = UDim2.new(1,0,0,34)
        end
    end)
    header.MouseEnter:Connect(function() sfx("hover"); tw(header,{BackgroundTransparency=0},0.1) end)
    header.MouseLeave:Connect(function() tw(header,{BackgroundTransparency=0.2},0.1) end)

    if callback then callback(cur, options[cur]) end
    return wrap
end

-- ─── RarityDropdown ───────────────────────────────────────────────
--  Multi-toggle rarity selector.  Each entry has a coloured dot and
--  an individual mini-toggle.  stateTable[rarity] (bool) is toggled.
--
--  rarColors is a { [rarityName] = Color3 } map.
--  Returns: wrapper Frame
function Component.RarityDropdown(parent, rarities, rarColors, stateTable)
    local ITEM_H   = 30
    local TARGET_H = #rarities * ITEM_H + 8

    local function enabledCount()
        local n = 0
        for _, r in ipairs(rarities) do if stateTable[r] then n += 1 end end
        return n
    end

    local wrap = Instance.new("Frame", parent)
    wrap.Size = UDim2.new(1,0,0,34); wrap.LayoutOrder = nextOrder(parent)
    wrap.BackgroundTransparency = 1; wrap.BorderSizePixel = 0
    wrap.ClipsDescendants = false; wrap.ZIndex = 50

    local header = Instance.new("TextButton", wrap)
    header.Size = UDim2.new(1,0,0,34); header.BackgroundColor3 = P.BgItem
    header.BackgroundTransparency = 0.2; header.Text = ""; header.AutoButtonColor = false
    header.ZIndex = 51; corner(header)
    local hst = mkStroke(header, P.Border, 1, 0.5)

    local lLbl = Instance.new("TextLabel", header)
    lLbl.Text = "Rarities"; lLbl.Font = Enum.Font.GothamSemibold; lLbl.TextSize = 10
    lLbl.TextColor3 = P.TextMuted
    lLbl.Size = UDim2.new(0.44,0,1,0); lLbl.Position = UDim2.new(0,12,0,0)
    lLbl.BackgroundTransparency = 1; lLbl.TextXAlignment = Enum.TextXAlignment.Left; lLbl.ZIndex = 52

    local vLbl = Instance.new("TextLabel", header)
    vLbl.Font = Enum.Font.GothamBlack; vLbl.TextSize = 11; vLbl.TextColor3 = P.AccentHi
    vLbl.Size = UDim2.new(0.42,0,1,0); vLbl.Position = UDim2.new(0.44,0,0,0)
    vLbl.BackgroundTransparency = 1; vLbl.TextXAlignment = Enum.TextXAlignment.Left; vLbl.ZIndex = 52

    local arrow = Instance.new("ImageLabel", header)
    arrow.Size = UDim2.new(0,12,0,12); arrow.Position = UDim2.new(1,-22,0.5,-6)
    arrow.BackgroundTransparency = 1; arrow.Image = Icons.chevD
    arrow.ImageColor3 = P.TextMuted; arrow.ZIndex = 52

    local function refreshSummary()
        local n = enabledCount()
        vLbl.Text = n.." / "..#rarities.." ON"
        vLbl.TextColor3 = n==#rarities and P.Green or (n==0 and P.Red or P.AccentHi)
    end
    refreshSummary()

    local list = Instance.new("Frame", wrap)
    list.Size = UDim2.new(1,0,0,0); list.Position = UDim2.new(0,0,0,36)
    list.BackgroundColor3 = P.BgCard; list.BackgroundTransparency = 0.04
    list.BorderSizePixel = 0; list.ClipsDescendants = true
    list.Visible = false; list.ZIndex = 60
    corner(list); mkStroke(list, P.AccentHi, 1, 0.3)

    local lLayout = Instance.new("UIListLayout", list)
    lLayout.SortOrder = Enum.SortOrder.LayoutOrder; lLayout.Padding = UDim.new(0,2)
    local lPad = Instance.new("UIPadding", list)
    lPad.PaddingTop=UDim.new(0,4); lPad.PaddingBottom=UDim.new(0,4)
    lPad.PaddingLeft=UDim.new(0,4); lPad.PaddingRight=UDim.new(0,4)

    for idx, rarity in ipairs(rarities) do
        local col = rarColors[rarity] or P.TextMuted
        local row = Instance.new("Frame", list)
        row.Size = UDim2.new(1,0,0,ITEM_H); row.LayoutOrder = idx
        row.BackgroundColor3 = P.BgHover; row.BackgroundTransparency = 0.5
        row.BorderSizePixel = 0; row.ZIndex = 61; corner(row, 6)
        local rst = mkStroke(row, P.Border, 1, 0.7)

        local dot = Instance.new("Frame", row)
        dot.Size = UDim2.new(0,7,0,7); dot.Position = UDim2.new(0,9,0.5,-3.5)
        dot.BackgroundColor3 = col; dot.BorderSizePixel = 0; dot.ZIndex = 62; corner(dot, 4)

        local nameLbl = Instance.new("TextLabel", row)
        nameLbl.Text = rarity; nameLbl.Font = Enum.Font.GothamBold; nameLbl.TextSize = 11
        nameLbl.TextColor3 = P.TextPri
        nameLbl.Size = UDim2.new(1,-74,1,0); nameLbl.Position = UDim2.new(0,22,0,0)
        nameLbl.BackgroundTransparency = 1; nameLbl.TextXAlignment = Enum.TextXAlignment.Left; nameLbl.ZIndex = 62

        local track = Instance.new("Frame", row)
        track.Size = UDim2.new(0,32,0,16); track.Position = UDim2.new(1,-40,0.5,-8)
        track.BackgroundColor3 = stateTable[rarity] and col or P.Border
        track.BorderSizePixel = 0; track.ZIndex = 62; corner(track, 8)
        local knob = Instance.new("Frame", track)
        knob.Size = UDim2.new(0,12,0,12)
        knob.Position = stateTable[rarity] and UDim2.new(0,18,0.5,-6) or UDim2.new(0,2,0.5,-6)
        knob.BackgroundColor3 = P.White; knob.BorderSizePixel = 0; knob.ZIndex = 63; corner(knob, 6)

        local function applyRowVisual(en)
            tw(track, {BackgroundColor3 = en and col or P.Border}, 0.15)
            tw(knob,  {Position = en and UDim2.new(0,18,0.5,-6) or UDim2.new(0,2,0.5,-6)}, 0.15)
            tw(rst,   {Color = en and col or P.Border, Transparency = en and 0.4 or 0.7}, 0.15)
        end

        local hit = Instance.new("TextButton", row)
        hit.Size = UDim2.new(1,0,1,0); hit.BackgroundTransparency = 1; hit.Text = ""; hit.ZIndex = 64
        hit.MouseButton1Click:Connect(function()
            stateTable[rarity] = not stateTable[rarity]
            sfx(stateTable[rarity] and "on" or "off")
            applyRowVisual(stateTable[rarity])
            refreshSummary()
        end)
        row.MouseEnter:Connect(function() tw(row,{BackgroundTransparency=0.25},0.1) end)
        row.MouseLeave:Connect(function() tw(row,{BackgroundTransparency=0.5},0.1) end)
    end

    local open = false
    header.MouseButton1Click:Connect(function()
        sfx("click"); open = not open
        if open then
            list.Visible = true; list.Size = UDim2.new(1,0,0,0)
            tw(list,  {Size=UDim2.new(1,0,0,TARGET_H)}, 0.22, Enum.EasingStyle.Back)
            tw(arrow, {Rotation=180},                   0.18)
            tw(hst,   {Color=P.AccentHi, Transparency=0.2}, 0.18)
            wrap.Size = UDim2.new(1,0,0,34+TARGET_H+4)
        else
            tw(list,  {Size=UDim2.new(1,0,0,0)}, 0.15)
            tw(arrow, {Rotation=0},               0.15)
            tw(hst,   {Color=P.Border, Transparency=0.5}, 0.15)
            task.delay(0.15, function() list.Visible = false end)
            wrap.Size = UDim2.new(1,0,0,34)
        end
    end)
    header.MouseEnter:Connect(function() sfx("hover"); tw(header,{BackgroundTransparency=0},0.1) end)
    header.MouseLeave:Connect(function() tw(header,{BackgroundTransparency=0.2},0.1) end)
    return wrap
end

-- ─── InfoStrip ────────────────────────────────────────────────────
--  Small tinted hint/info bar.
--  Returns: frame (Frame), label (TextLabel)
--  Mutate label.Text at runtime to update the message.
function Component.InfoStrip(parent, text, col)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1,0,0,28); f.LayoutOrder = nextOrder(parent)
    f.BackgroundColor3 = col or P.GreenDim
    f.BackgroundTransparency = 0.78; f.BorderSizePixel = 0; corner(f, 7)
    local l = Instance.new("TextLabel", f)
    l.Text = text; l.Font = Enum.Font.GothamSemibold; l.TextSize = 10
    l.TextColor3 = P.TextSec
    l.Size = UDim2.new(1,-14,1,0); l.Position = UDim2.new(0,7,0,0)
    l.BackgroundTransparency = 1; l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextWrapped = true
    return f, l
end

-- ═══════════════════════════════════════════════════════════════════
--  TAB METATABLE  (proxy all Component calls onto the page)
-- ═══════════════════════════════════════════════════════════════════

local Tab = {}
Tab.__index = Tab

function Tab:Section(title)
    return Component.Section(self._page, title)
end
function Tab:StatusCard(title, default, col)
    return Component.StatusCard(self._page, title, default, col)
end
function Tab:StartPulse(pulse, cond)
    return Component.StartPulse(pulse, cond)
end
function Tab:Toggle(text, stateTable, key, callback)
    return Component.Toggle(self._page, text, stateTable, key, callback)
end
function Tab:Slider(text, mn, mx, def, stateTable, key, callback)
    return Component.Slider(self._page, text, mn, mx, def, stateTable, key, callback)
end
function Tab:Button(text, icon, col, callback)
    return Component.Button(self._page, text, icon, col, callback)
end
function Tab:Dropdown(label, options, default, callback)
    return Component.Dropdown(self._page, label, options, default, callback)
end
function Tab:RarityDropdown(rarities, rarColors, stateTable)
    return Component.RarityDropdown(self._page, rarities, rarColors, stateTable)
end
function Tab:InfoStrip(text, col)
    return Component.InfoStrip(self._page, text, col)
end
function Tab:GetPage()
    return self._page
end

-- ═══════════════════════════════════════════════════════════════════
--  WINDOW CONSTRUCTOR
-- ═══════════════════════════════════════════════════════════════════

--[[
  Window(cfg) -> win

  cfg fields (all optional):
    title    string   Window title (first word coloured accent, rest white)
    badge    string   Small badge text, e.g. "v1"          default "v2"
    logo     string   Asset ID for logo image              default Icons.logo
    theme    string   Theme name (see top of file)         default "Void"
    width    number   Initial window width in px           default 480
    height   number   Initial window height in px          default 360
    guiName  string   ScreenGui instance name              default "VoidHubLib"

  win methods:
    win:Tab(name, icon)   -> Tab
    win:SetTheme(name)    — swap colour theme at runtime
    win:Open()            — show window
    win:Close()           — minimise window
    win:Destroy()         — remove ScreenGui entirely
    win:GetGui()          -> ScreenGui
]]

local function Window(cfg)
    cfg = cfg or {}
    local TITLE = cfg.title   or "Void Hub"
    local BADGE = cfg.badge   or "v2"
    local LOGO  = cfg.logo    or Icons.logo
    local W     = cfg.width   or 480
    local H     = cfg.height  or 360
    local GNAME = cfg.guiName or "VoidHubLib"

    -- Apply theme
    if cfg.theme then applyTheme(cfg.theme) end

    -- Remove previous instance
    local prev = CoreGui:FindFirstChild(GNAME)
    if prev then prev:Destroy() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name            = GNAME
    ScreenGui.ResetOnSpawn    = false
    ScreenGui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder    = 10
    ScreenGui.Parent          = CoreGui

    -- ── Main frame ────────────────────────────────────────────────
    local MainFrame = Instance.new("Frame")
    MainFrame.Name                   = "Main"
    MainFrame.Size                   = UDim2.new(0,0,0,0)
    MainFrame.Position               = UDim2.new(0.5,0,0.5,0)
    MainFrame.BackgroundColor3       = P.Bg
    MainFrame.BackgroundTransparency = 0
    MainFrame.BorderSizePixel        = 0
    MainFrame.ClipsDescendants       = true
    MainFrame.Active                 = true
    MainFrame.Parent                 = ScreenGui
    corner(MainFrame, 14)
    local mainStroke = mkStroke(MainFrame, P.Accent, 1.5, 0.5)

    task.spawn(function()
        MainFrame:TweenSizeAndPosition(
            UDim2.new(0,W,0,H),
            UDim2.new(0.5,-W/2,0.5,-H/2),
            "Out","Back",0.5,true)
    end)

    -- ── Top bar ───────────────────────────────────────────────────
    local TopBar = Instance.new("Frame", MainFrame)
    TopBar.Size                   = UDim2.new(1,0,0,46)
    TopBar.BackgroundColor3       = P.BgCard
    TopBar.BackgroundTransparency = 0
    TopBar.BorderSizePixel        = 0

    local tbLine = Instance.new("Frame", TopBar)
    tbLine.Size = UDim2.new(1,0,0,1); tbLine.Position = UDim2.new(0,0,1,-1)
    tbLine.BackgroundColor3 = P.Accent; tbLine.BackgroundTransparency = 0.55; tbLine.BorderSizePixel = 0

    local LogoImg = Instance.new("ImageLabel", TopBar)
    LogoImg.Size = UDim2.new(0,28,0,28); LogoImg.Position = UDim2.new(0,14,0.5,-14)
    LogoImg.BackgroundTransparency = 1; LogoImg.Image = LOGO

    -- Title: first word accent, second word white + animated gradient
    local words = {}
    for w in (TITLE.." "):gmatch("(%S+)%s") do table.insert(words,w) end
    local word1 = words[1] or TITLE
    local word2 = (#words > 1) and table.concat(words," ",2) or nil

    local lv = Instance.new("TextLabel", TopBar)
    lv.Text = word1; lv.Font = Enum.Font.GothamBlack; lv.TextSize = 18
    lv.TextColor3 = P.AccentHi; lv.Size = UDim2.new(0,#word1*11,1,0)
    lv.Position = UDim2.new(0,48,0,0); lv.BackgroundTransparency = 1
    lv.TextXAlignment = Enum.TextXAlignment.Left

    local badgeOffsetX = 48 + #word1*11 + 4

    if word2 then
        local lh = Instance.new("TextLabel", TopBar)
        lh.Text = word2; lh.Font = Enum.Font.GothamBlack; lh.TextSize = 18
        lh.TextColor3 = P.TextPri; lh.Size = UDim2.new(0,#word2*11,1,0)
        lh.Position = UDim2.new(0, 48+#word1*11+4, 0, 0)
        lh.BackgroundTransparency = 1; lh.TextXAlignment = Enum.TextXAlignment.Left
        local grad = Instance.new("UIGradient", lh)
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   P.TextPri),
            ColorSequenceKeypoint.new(0.5, P.AccentGlow),
            ColorSequenceKeypoint.new(1,   P.TextPri),
        })
        task.spawn(function()
            local r = 0
            while MainFrame and MainFrame.Parent do
                r = (r+6)%360; grad.Rotation = r; task.wait(0.05)
            end
        end)
        badgeOffsetX = badgeOffsetX + #word2*11 + 6
    end

    -- Version badge
    local VBadge = Instance.new("Frame", TopBar)
    VBadge.Size = UDim2.new(0,48,0,18); VBadge.Position = UDim2.new(0,badgeOffsetX,0.5,-9)
    VBadge.BackgroundColor3 = P.AccentDim; VBadge.BackgroundTransparency = 0.2; VBadge.BorderSizePixel = 0
    corner(VBadge, 9)
    local vLbl2 = Instance.new("TextLabel", VBadge)
    vLbl2.Text = BADGE; vLbl2.Font = Enum.Font.GothamBold; vLbl2.TextSize = 10
    vLbl2.TextColor3 = P.AccentGlow; vLbl2.Size = UDim2.new(1,0,1,0); vLbl2.BackgroundTransparency = 1

    -- Minimize / Close buttons
    local function ctrlBtn(icon, col, offX)
        local b = Instance.new("TextButton", TopBar)
        b.Size = UDim2.new(0,30,0,30); b.Position = UDim2.new(1,offX,0.5,-15)
        b.BackgroundColor3 = P.BgCard; b.BackgroundTransparency = 0.4
        b.Text = ""; b.AutoButtonColor = false; corner(b, 7)
        local st = mkStroke(b, P.Border, 1)
        local img = Instance.new("ImageLabel", b)
        img.Size = UDim2.new(0,14,0,14); img.Position = UDim2.new(0.5,-7,0.5,-7)
        img.BackgroundTransparency = 1; img.Image = icon; img.ImageColor3 = col
        b.MouseEnter:Connect(function()
            sfx("hover"); tw(b,{BackgroundTransparency=0},0.12); tw(st,{Color=col},0.12)
        end)
        b.MouseLeave:Connect(function()
            tw(b,{BackgroundTransparency=0.4},0.12); tw(st,{Color=P.Border},0.12)
        end)
        return b
    end
    local MinBtn   = ctrlBtn(Icons.minimize, P.Yellow, -74)
    local CloseBtn = ctrlBtn(Icons.close,    P.Red,    -38)

    -- ── Sidebar ───────────────────────────────────────────────────
    local SIDEBAR_W = 120

    local Sidebar = Instance.new("ScrollingFrame", MainFrame)
    Sidebar.Size                 = UDim2.new(0,SIDEBAR_W,1,-46)
    Sidebar.Position             = UDim2.new(0,0,0,46)
    Sidebar.BackgroundColor3     = P.BgCard; Sidebar.BackgroundTransparency = 0.05
    Sidebar.BorderSizePixel      = 0; Sidebar.ScrollBarThickness = 0
    Sidebar.ScrollingDirection   = Enum.ScrollingDirection.Y
    Sidebar.AutomaticCanvasSize  = Enum.AutomaticSize.Y
    Sidebar.CanvasSize           = UDim2.new(0,0,0,0); Sidebar.ClipsDescendants = true
    local sbL = Instance.new("UIListLayout", Sidebar)
    sbL.SortOrder = Enum.SortOrder.LayoutOrder; sbL.Padding = UDim.new(0,3)
    local sbP = Instance.new("UIPadding", Sidebar)
    sbP.PaddingTop=UDim.new(0,8); sbP.PaddingBottom=UDim.new(0,8)
    sbP.PaddingLeft=UDim.new(0,6); sbP.PaddingRight=UDim.new(0,6)

    local sbDiv = Instance.new("Frame", MainFrame)
    sbDiv.Size = UDim2.new(0,1,1,-46); sbDiv.Position = UDim2.new(0,SIDEBAR_W,0,46)
    sbDiv.BackgroundColor3 = P.Accent; sbDiv.BackgroundTransparency = 0.72; sbDiv.BorderSizePixel = 0

    local ContentArea = Instance.new("Frame", MainFrame)
    ContentArea.Size = UDim2.new(1,-SIDEBAR_W-1,1,-46)
    ContentArea.Position = UDim2.new(0,SIDEBAR_W+1,0,46)
    ContentArea.BackgroundTransparency = 1; ContentArea.ClipsDescendants = true

    -- ── Tab management ────────────────────────────────────────────
    local tabs      = {}
    local activeTab = nil
    local tabOrder  = 0

    local function activateTab(td)
        sfx("click")
        for _, t in ipairs(tabs) do
            t._page.Visible = false
            tw(t._btn,    {BackgroundTransparency=0.8, BackgroundColor3=P.BgHover},  0.15)
            tw(t._bar,    {Size=UDim2.new(0,3,0,0), Position=UDim2.new(0,0,0.5,0)}, 0.15)
            tw(t._ico,    {ImageColor3=P.TextMuted},                                  0.15)
            tw(t._lbl,    {TextColor3=P.TextMuted},                                   0.15)
            tw(t._stroke, {Color=P.Border, Transparency=0.8},                         0.15)
        end
        td._page.Visible = true
        tw(td._btn,    {BackgroundTransparency=0.25, BackgroundColor3=P.AccentDim},        0.18, Enum.EasingStyle.Back)
        tw(td._bar,    {Size=UDim2.new(0,3,0,22), Position=UDim2.new(0,0,0.5,-11)},       0.18, Enum.EasingStyle.Back)
        tw(td._ico,    {ImageColor3=P.AccentHi},  0.15)
        tw(td._lbl,    {TextColor3=P.TextPri},    0.15)
        tw(td._stroke, {Color=P.AccentHi, Transparency=0.3}, 0.15)
        activeTab = td._name
    end

    -- ── Dragging ──────────────────────────────────────────────────
    local isDragging, dragInput, dragStart, dragOrigin = false, nil, nil, nil
    TopBar.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            isDragging=true; dragStart=inp.Position; dragOrigin=MainFrame.Position
            inp.Changed:Connect(function()
                if inp.UserInputState==Enum.UserInputState.End then isDragging=false end
            end)
        end
    end)
    TopBar.InputChanged:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch then
            dragInput=inp
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if inp==dragInput and isDragging then
            local d=inp.Position-dragStart
            MainFrame.Position=UDim2.new(dragOrigin.X.Scale, dragOrigin.X.Offset+d.X,
                                         dragOrigin.Y.Scale, dragOrigin.Y.Offset+d.Y)
        end
    end)

    -- ── Open / Close ──────────────────────────────────────────────
    local menuOpen = true

    local function closeMenu()
        menuOpen = false
        MainFrame:TweenSizeAndPosition(UDim2.new(0,0,0,0),UDim2.new(0.5,0,0.5,0),"In","Back",0.28,true)
        tw(MainFrame, {BackgroundTransparency=1}, 0.28)
        task.delay(0.28, function() MainFrame.Visible = false end)
    end
    local function openMenu()
        menuOpen = true; MainFrame.Visible = true
        MainFrame:TweenSizeAndPosition(UDim2.new(0,W,0,H),UDim2.new(0.5,-W/2,0.5,-H/2),"Out","Back",0.38,true)
        tw(MainFrame, {BackgroundTransparency=0}, 0.3)
    end

    MinBtn.MouseButton1Click:Connect(function()   sfx("close"); closeMenu()     end)
    CloseBtn.MouseButton1Click:Connect(function() sfx("close"); ScreenGui:Destroy() end)

    -- ── Floating toggle button ────────────────────────────────────
    local ToggleBtn = Instance.new("ImageButton", ScreenGui)
    ToggleBtn.Name             = "VHToggle"
    ToggleBtn.Size             = UDim2.new(0,46,0,46)
    ToggleBtn.Position         = UDim2.new(0,14,0.5,-23)
    ToggleBtn.BackgroundColor3 = P.Bg
    ToggleBtn.Image            = LOGO
    ToggleBtn.ScaleType        = Enum.ScaleType.Fit
    ToggleBtn.ZIndex           = 20
    corner(ToggleBtn, 23)
    local tbSt = mkStroke(ToggleBtn, P.AccentHi, 2)

    local glowRing = Instance.new("Frame", ToggleBtn)
    glowRing.Size = UDim2.new(1,10,1,10); glowRing.Position = UDim2.new(0,-5,0,-5)
    glowRing.BackgroundTransparency = 1; glowRing.BorderSizePixel = 0; glowRing.ZIndex = 19
    corner(glowRing, 28)
    local gRingSt = mkStroke(glowRing, P.AccentHi, 2, 0.1)
    task.spawn(function()
        while ToggleBtn and ToggleBtn.Parent do
            tw(gRingSt, {Transparency=0.85}, 1.3, Enum.EasingStyle.Sine)
            task.wait(1.3)
            tw(gRingSt, {Transparency=0.1},  1.3, Enum.EasingStyle.Sine)
            task.wait(1.3)
        end
    end)

    local function startWobble()
        if not (ToggleBtn and ToggleBtn.Parent) then return end
        TweenService:Create(ToggleBtn,TweenInfo.new(0.55,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Rotation=6}):Play()
        task.delay(0.55, function()
            if not (ToggleBtn and ToggleBtn.Parent) then return end
            TweenService:Create(ToggleBtn,TweenInfo.new(0.55,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Rotation=-6}):Play()
            task.delay(0.55, startWobble)
        end)
    end
    startWobble()

    local tbDrag,tbDragStart,tbDragOrigin,tbDragDist = false,nil,nil,0
    ToggleBtn.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            tbDrag=true; tbDragDist=0; tbDragStart=inp.Position; tbDragOrigin=ToggleBtn.Position
            local c; c=inp.Changed:Connect(function()
                if inp.UserInputState==Enum.UserInputState.End then tbDrag=false; c:Disconnect() end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if tbDrag and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then
            local d=inp.Position-tbDragStart; tbDragDist=math.abs(d.X)+math.abs(d.Y)
            if tbDragDist>4 then
                ToggleBtn.Position=UDim2.new(tbDragOrigin.X.Scale,tbDragOrigin.X.Offset+d.X,
                                             tbDragOrigin.Y.Scale,tbDragOrigin.Y.Offset+d.Y)
            end
        end
    end)
    ToggleBtn.MouseButton1Click:Connect(function()
        if tbDragDist>7 then return end
        local tp=ToggleBtn.AbsolutePosition
        spawnConfetti(ScreenGui, UDim2.new(0,tp.X+23,0,tp.Y+23))
        if menuOpen then sfx("close"); closeMenu() else sfx("open"); openMenu() end
    end)
    ToggleBtn.MouseEnter:Connect(function() tw(tbSt,{Transparency=0.4},0.15) end)
    ToggleBtn.MouseLeave:Connect(function() tw(tbSt,{Transparency=0},  0.15) end)

    -- ── Window API ────────────────────────────────────────────────

    local win = {}

    --- Adds a sidebar tab entry.  Returns a Tab object.
    --- @param name string
    --- @param icon string   asset ID
    function win:Tab(name, icon)
        tabOrder += 1

        local btn = Instance.new("TextButton", Sidebar)
        btn.Name = name.."Btn"; btn.Size = UDim2.new(1,0,0,34)
        btn.BackgroundColor3 = P.BgHover; btn.BackgroundTransparency = 0.8
        btn.Text = ""; btn.AutoButtonColor = false; btn.LayoutOrder = tabOrder
        corner(btn)
        local btnSt = mkStroke(btn, P.Border, 1, 0.8)

        local bIco = Instance.new("ImageLabel", btn)
        bIco.Size = UDim2.new(0,14,0,14); bIco.Position = UDim2.new(0,9,0.5,-7)
        bIco.BackgroundTransparency = 1; bIco.Image = icon or ""; bIco.ImageColor3 = P.TextMuted

        local bTxt = Instance.new("TextLabel", btn)
        bTxt.Text = name; bTxt.Font = Enum.Font.GothamBold; bTxt.TextSize = 11
        bTxt.TextColor3 = P.TextMuted
        bTxt.Size = UDim2.new(1,-30,1,0); bTxt.Position = UDim2.new(0,27,0,0)
        bTxt.BackgroundTransparency = 1; bTxt.TextXAlignment = Enum.TextXAlignment.Left

        local bar = Instance.new("Frame", btn)
        bar.Size = UDim2.new(0,3,0,0); bar.Position = UDim2.new(0,0,0.5,0)
        bar.BackgroundColor3 = P.AccentHi; bar.BorderSizePixel = 0; corner(bar, 2)

        local page = Instance.new("ScrollingFrame", ContentArea)
        page.Name = name.."Page"
        page.Size = UDim2.new(1,-6,1,-6); page.Position = UDim2.new(0,3,0,3)
        page.BackgroundTransparency = 1; page.BorderSizePixel = 0
        page.ScrollBarThickness = 3; page.ScrollBarImageColor3 = P.Accent
        page.ScrollingDirection = Enum.ScrollingDirection.Y
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.Visible = false
        local pL = Instance.new("UIListLayout", page)
        pL.SortOrder = Enum.SortOrder.LayoutOrder; pL.Padding = UDim.new(0,4)
        local pP = Instance.new("UIPadding", page)
        pP.PaddingTop=UDim.new(0,5); pP.PaddingBottom=UDim.new(0,10)
        pP.PaddingLeft=UDim.new(0,3); pP.PaddingRight=UDim.new(0,3)

        local td = {
            _name   = name,
            _btn    = btn,
            _page   = page,
            _bar    = bar,
            _ico    = bIco,
            _lbl    = bTxt,
            _stroke = btnSt,
        }
        table.insert(tabs, td)
        setmetatable(td, Tab)

        if #tabs == 1 then activateTab(td) end

        btn.MouseButton1Click:Connect(function() activateTab(td) end)
        btn.MouseEnter:Connect(function()
            if activeTab~=name then sfx("hover"); tw(btn,{BackgroundTransparency=0.6},0.1) end
        end)
        btn.MouseLeave:Connect(function()
            if activeTab~=name then tw(btn,{BackgroundTransparency=0.8},0.1) end
        end)

        return td
    end

    --- Swap the colour theme at runtime.  Rebuilding the UI is NOT
    --- required — existing elements will keep their baked colours, but
    --- all newly-created components (new tabs, new widgets) will use
    --- the new theme.  For a full theme swap, destroy and recreate
    --- the window.
    --- @param name string
    function win:SetTheme(name)
        applyTheme(name)
        -- Update the chrome pieces we still have references to
        MainFrame.BackgroundColor3  = P.Bg
        mainStroke.Color            = P.Accent
        TopBar.BackgroundColor3     = P.BgCard
        tbLine.BackgroundColor3     = P.Accent
        Sidebar.BackgroundColor3    = P.BgCard
        sbDiv.BackgroundColor3      = P.Accent
        ToggleBtn.BackgroundColor3  = P.Bg
        tbSt.Color                  = P.AccentHi
        gRingSt.Color               = P.AccentHi
        vLbl2.TextColor3            = P.AccentGlow
        VBadge.BackgroundColor3     = P.AccentDim
    end

    function win:Open()    openMenu()         end
    function win:Close()   closeMenu()        end
    function win:Destroy() ScreenGui:Destroy() end
    function win:GetGui()  return ScreenGui   end

    return win
end

-- ═══════════════════════════════════════════════════════════════════
--  PUBLIC API
-- ═══════════════════════════════════════════════════════════════════

return {
    -- Main entry point
    Window    = Window,

    -- Direct component access (when building custom layouts)
    Component = Component,

    -- Colour palette in use (reflects current theme)
    Colors    = P,

    -- All built-in themes (read-only reference)
    Themes    = THEMES,

    -- Icon asset IDs
    Icons     = Icons,

    -- Play a UI sound directly
    Sfx       = sfx,
}
