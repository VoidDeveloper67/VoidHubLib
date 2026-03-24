# VoidHub UI Library

**Version:** 2.2  
**Authors:** vonplayz_real & DarealBloxfruiter  
**Discord:** discord.gg/C5gUXQ5qYN

---

## Overview

VoidHub UI Library (`main.lua`) is a self-contained Roblox Lua UI toolkit extracted and refactored from VoidHub v2. It provides a modern animated window system with a sidebar layout, reusable widgets, runtime theme switching, and a simple state-driven API.

The library has no external dependencies. Everything — chrome, animations, sounds, and UI behavior — is contained in the single `main.lua` file.

---

## Quick Start

```lua
local VHL = loadstring(game:HttpGet("https://raw.githubusercontent.com/VoidDeveloper67/VoidHubLib/refs/heads/main/main.lua"))()

local win = VHL.Window({
    title  = "My Hub",
    badge  = "v1",
    theme  = "Emerald",
    width  = 480,
    height = 360,
})

local farmTab = win:Tab("Farm", VHL.Icons.farm)

local state = { FarmEnabled = false, FarmSpeed = 0.15 }

farmTab:Section("Settings")
farmTab:Toggle("Enable Farm", state, "FarmEnabled", function(enabled)
    print("Farm is now:", enabled)
end)
farmTab:Slider("Farm Speed", 0.05, 1, 0.15, state, "FarmSpeed")
farmTab:Button("Sell All", VHL.Icons.sell, nil, function()
    print("Selling!")
end)
```

---

## Window

### `VHL.Window(cfg)` → `win`

Creates and displays a new hub window. If a window with the same `guiName` already exists in `CoreGui`, it is destroyed first.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `title` | string | `"Void Hub"` | Window title. The first word uses the accent colour; remaining words use the animated highlight treatment. |
| `badge` | string | `"v2"` | Small pill badge displayed next to the title. |
| `logo` | string | `VHL.Icons.logo` | Rbx asset ID for the logo image shown in the top bar and on the floating toggle button. |
| `theme` | string | `"Void"` | Colour theme to apply. See the **Themes** section for all options. |
| `width` | number | `480` | Initial window width in pixels. |
| `height` | number | `360` | Initial window height in pixels. |
| `guiName` | string | `"VoidHubLib"` | The `Name` property set on the `ScreenGui`. Useful if you run multiple windows simultaneously. |

### Window Methods

```lua
win:Tab(name, icon)       -- Add a sidebar tab; returns a Tab object
win:SetTheme(name)        -- Swap the colour theme at runtime
win:GetTheme()            -- Return the current theme name
win:GetThemes()           -- Return the registered theme table/list
win:RefreshTheme()        -- Reapply the active theme to the window
win:Open()                -- Show the window (reverse of Close)
win:Close()               -- Minimise/hide the window
win:Destroy()             -- Remove the ScreenGui entirely
win:GetGui()              -- Return the raw ScreenGui instance
```

**Floating toggle button.** A draggable icon button stays visible on screen. Clicking it toggles the window open/closed and plays the UI effects. It can be moved independently of the main window.

---

## Tabs

### `win:Tab(name, icon)` → `Tab`

Appends an entry to the sidebar and creates a scrollable content page for it. The first tab created is activated automatically.

```lua
local farmTab    = win:Tab("Farm",    VHL.Icons.farm)
local settingTab = win:Tab("Config",  VHL.Icons.config)
local rebirthTab = win:Tab("Rebirth", VHL.Icons.rebirth)
```

`icon` should be an rbx asset ID string. The `VHL.Icons` table (see below) provides IDs for all built-in icons.

### `Tab:Clear()`

Removes all widgets from the tab page while keeping the tab itself intact.

```lua
farmTab:Clear()
```

---

## Components

All components are available as methods on a `Tab` object, or directly via `VHL.Component.*` when you need to place them on an arbitrary `Frame` or `ScrollingFrame`.

### Section

```lua
tab:Section("SETTINGS")
```

Renders a labelled divider with a thin accent underline. The title is uppercased automatically.

---

### Toggle

```lua
local row, refresh = tab:Toggle(text, stateTable, key, callback)
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `text` | string | Label shown on the row. |
| `stateTable` | table | Any table — the library reads and writes `stateTable[key]` directly. |
| `key` | string | Key in `stateTable` to control. |
| `callback` | function? | `function(newState: bool)` — called whenever the toggle changes. |

Returns the row `Frame` and a `refresh()` function. Call `refresh()` if you change `stateTable[key]` externally and need the visual to sync.

```lua
local state = { AutoFarm = false }

tab:Toggle("Auto Farm", state, "AutoFarm", function(on)
    if on then startFarm() else stopFarm() end
end)
```

---

### Slider

```lua
tab:Slider(text, min, max, default, stateTable, key, callback)
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `text` | string | Label shown above the slider track. |
| `min` | number | Minimum value. |
| `max` | number | Maximum value. |
| `default` | number | Starting value (also used if `stateTable[key]` is nil). |
| `stateTable` | table | Written directly as `stateTable[key] = value`. |
| `key` | string | Key in `stateTable`. |
| `callback` | function? | `function(value: number)` — fires on every change. |

The slider snaps to whole numbers when `(max - min) > 1`, and to two decimal places otherwise. The value can also be typed directly into the text box on the right.

```lua
local state = {}
tab:Slider("Walk Speed", 16, 200, 16, state, "WalkSpeed", function(val)
    LocalPlayer.Character.Humanoid.WalkSpeed = val
end)
```

---

### Button

```lua
tab:Button(text, icon, color, callback)
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `text` | string | Button label. |
| `icon` | string? | Optional rbx asset ID for a small left-side icon. Pass `nil` to omit. |
| `color` | Color3? | Background and stroke tint. Defaults to the active accent variant. |
| `callback` | function? | Called on click. |

```lua
tab:Button("Sell All", VHL.Icons.sell, VHL.Colors.Green, function()
    -- sell logic
end)

tab:Button("Reset Position", nil, nil, function()
    -- no icon, default accent colour
end)
```

---

### Dropdown

```lua
tab:Dropdown(label, options, defaultIndex, callback)
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `label` | string | Small muted label on the left of the header. |
| `options` | `{string}` | List of option strings. |
| `defaultIndex` | number | 1-based index of the initially selected option. |
| `callback` | function? | `function(index: number, option: string)` — fires immediately with the default, then on every change. |

```lua
local upgradeAmount = 1
tab:Dropdown("Amount", {"1","5","10","Max"}, 1, function(idx, opt)
    upgradeAmount = tonumber(opt) or math.huge
end)
```

---

### RarityDropdown

```lua
tab:RarityDropdown(rarities, rarityColors, stateTable)
```

A specialised multi-toggle dropdown where each rarity has a coloured dot and an individual on/off switch. The header summarises how many are enabled (for example, `7 / 10 ON`).

| Parameter | Type | Description |
|-----------|------|-------------|
| `rarities` | `{string}` | Ordered list of rarity name strings. |
| `rarityColors` | `{[string]: Color3}` | Map of rarity name → display colour. |
| `stateTable` | table | `stateTable[rarity]` (bool) is toggled for each entry. |

```lua
local RARITY_COLORS = {
    Godly     = Color3.fromRGB(255,215,0),
    Legendary = Color3.fromRGB(255,140,0),
    Epic      = Color3.fromRGB(160,60,220),
    Rare      = Color3.fromRGB(60,120,255),
    Common    = Color3.fromRGB(160,160,160),
}
local rarityToggles = { Godly=true, Legendary=true, Epic=false, Rare=false, Common=false }

tab:RarityDropdown(
    {"Godly","Legendary","Epic","Rare","Common"},
    RARITY_COLORS,
    rarityToggles
)
```

---

### StatusCard

```lua
local valueLbl, pulseFrame, setActive = tab:StatusCard(title, defaultText, accentColor)
```

A compact card that shows a title label and a large, bold value string. Three handles are returned for runtime control.

| Return | Type | Description |
|--------|------|-------------|
| `valueLbl` | TextLabel | Mutate `.Text` and `.TextColor3` to update the displayed value. |
| `pulseFrame` | Frame | Pass to `StartPulse` to animate the background glow. |
| `setActive` | `func(bool)` | Lights up or dims the left accent bar and status dot. |

```lua
local statusLbl, statusPulse, setActive = tab:StatusCard("Farm Status", "IDLE", VHL.Colors.Green)

statusLbl.Text = "FARMING…"
statusLbl.TextColor3 = VHL.Colors.Green
setActive(true)
tab:StartPulse(statusPulse, function() return myState.FarmEnabled end)
```

---

### StartPulse

```lua
tab:StartPulse(pulseFrame, conditionFunc)
-- or directly:
VHL.Component.StartPulse(pulseFrame, conditionFunc)
```

Drives the background glow animation on a `pulseFrame` returned by `StatusCard`. The animation loops automatically until `conditionFunc()` returns `false`.

---

### InfoStrip

```lua
local frame, label = tab:InfoStrip(text, color)
```

A small tinted hint bar. `label.Text` can be mutated at runtime to update the message.

```lua
local _, strip = tab:InfoStrip("⚡  Lava removed every 8 s", Color3.fromRGB(160,60,0))
strip.Text = "⚡  Lava removal paused"
```

---

## Using Components Outside a Tab

Every component is also accessible via `VHL.Component.*` and accepts a `parent` Frame as its first argument. This is useful when you need to place widgets into custom layouts.

```lua
local myFrame = Instance.new("Frame", someParent)

VHL.Component.Section(myFrame, "Custom Section")
VHL.Component.Button(myFrame, "Click Me", nil, nil, function() end)
```

---

## Themes

Pass `theme = "Name"` to `VHL.Window()`, or call `win:SetTheme("Name")` at any time.

| Name | Description |
|------|-------------|
| `"Void"` | Deep purple/violet — the original VoidHub look. |
| `"Midnight"` | Cool navy blue on near-black. |
| `"Crimson"` | Vivid red on dark steel. |
| `"Emerald"` | Forest green on near-black. |
| `"Gold"` | Warm amber/yellow on dark charcoal. |
| `"Arctic"` | Icy whites and pale blues — a light theme. |
| `"Neon"` | High-contrast purple with vivid glow. |
| `"Sapphire"` | Clean blue with bright chrome accents. |
| `"Rose"` | Deep pink/magenta on dark charcoal. |
| `"Sunset"` | Orange-pink warm gradient styling. |
| `"Mint"` | Soft green-cyan modern palette. |
| `"Orchid"` | Purple floral accent styling. |
| `"Obsidian"` | Minimal black-and-grey monochrome. |
| `"Slate"` | Neutral grey UI with subtle accenting. |

### Switching Themes at Runtime

`win:SetTheme(name)` repaints the window chrome and updates the active palette immediately. `win:RefreshTheme()` can be used to force a reapply of the current theme. New widgets created after the call use the updated palette.

```lua
task.delay(5, function()
    win:SetTheme("Crimson")
end)
```

### Custom Themes

Add your own theme to `VHL.Themes` before creating a window:

```lua
VHL.Themes["Ocean"] = {
    Bg         = Color3.fromRGB(5, 15, 30),
    BgCard     = Color3.fromRGB(8, 22, 44),
    BgItem     = Color3.fromRGB(10, 30, 56),
    BgHover    = Color3.fromRGB(14, 38, 68),
    Border     = Color3.fromRGB(20, 60, 100),
    BorderHi   = Color3.fromRGB(40, 110, 180),
    Accent     = Color3.fromRGB(0, 160, 220),
    AccentHi   = Color3.fromRGB(30, 195, 255),
    AccentDim  = Color3.fromRGB(0, 80, 120),
    AccentGlow = Color3.fromRGB(100, 220, 255),
    Green      = Color3.fromRGB(40, 200, 120),
    GreenDim   = Color3.fromRGB(15, 100, 55),
    Red        = Color3.fromRGB(220, 60, 60),
    Yellow     = Color3.fromRGB(210, 185, 20),
    Blue       = Color3.fromRGB(50, 130, 240),
    White      = Color3.new(1,1,1),
    TextPri    = Color3.new(1,1,1),
    TextSec    = Color3.fromRGB(160, 200, 230),
    TextMuted  = Color3.fromRGB(70, 120, 160),
    Discord    = Color3.fromRGB(88, 101, 242),
    DisGreen   = Color3.fromRGB(59, 165, 93),
}

local win = VHL.Window({ theme = "Ocean" })
```

---

## Reference: Icons

`VHL.Icons` is a flat table of rbx asset ID strings. Pass any value as the `icon` argument to `win:Tab()` or `tab:Button()`.

| Key | Description |
|-----|-------------|
| `logo` | VoidHub logo |
| `close` | × close symbol |
| `minimize` | — minimise symbol |
| `farm` | shovel / farm |
| `lucky` | lucky block star |
| `auto` | lightning / auto |
| `player` | person silhouette |
| `world` | globe |
| `tp` | teleport arrow |
| `rebirth` | rebirth spiral |
| `shop` | shopping bag |
| `config` | gear / settings |
| `trash` | trash bin |
| `save` | floppy disk |
| `load` | download arrow |
| `reset` | reset arrows |
| `sell` | coin / sell |
| `chevD` | chevron down (used internally by dropdowns) |
| `discord` | Discord logo |

---

## Reference: Colors

`VHL.Colors` is the live palette table. It always reflects the currently active theme. You can reference these anywhere in your scripts.

```lua
local c = VHL.Colors
-- c.Accent, c.AccentHi, c.AccentDim, c.AccentGlow
-- c.Bg, c.BgCard, c.BgItem, c.BgHover
-- c.Border, c.BorderHi
-- c.Green, c.GreenDim, c.Red, c.Yellow, c.Blue
-- c.White
-- c.TextPri, c.TextSec, c.TextMuted
-- c.Discord, c.DisGreen
```

---

## Reference: Sfx

Play a UI sound directly:

```lua
VHL.Sfx("ok")     -- confirmation chime
VHL.Sfx("click")  -- button click
VHL.Sfx("hover")  -- hover swoosh
VHL.Sfx("on")     -- toggle on
VHL.Sfx("off")    -- toggle off
VHL.Sfx("open")   -- window open
VHL.Sfx("close")  -- window close / minimise
```

---

## Full Example

```lua
local VHL = loadstring(game:HttpGet("https://raw.githubusercontent.com/VoidDeveloper67/VoidHubLib/refs/heads/main/main.lua"))()

local State = {
    FarmEnabled   = false,
    FarmSpeed     = 0.15,
    AutoEquip     = false,
    UpgradeAmount = 1,
    Rarities = {
        Godly = true, Legendary = true,
        Epic  = false, Rare = false, Common = false,
    },
}

local RARITY_COLORS = {
    Godly     = Color3.fromRGB(255,215,0),
    Legendary = Color3.fromRGB(255,140,0),
    Epic      = Color3.fromRGB(160,60,220),
    Rare      = Color3.fromRGB(60,120,255),
    Common    = Color3.fromRGB(160,160,160),
}

local win = VHL.Window({
    title  = "Void Hub",
    badge  = "v2",
    theme  = "Emerald",
    width  = 480,
    height = 360,
})

local farmTab = win:Tab("Farm", VHL.Icons.farm)

farmTab:Section("Status")
local statusLbl, statusPulse, setActive = farmTab:StatusCard("Farm", "IDLE", VHL.Colors.Green)

farmTab:Section("Controls")
farmTab:Toggle("Enable Farm", State, "FarmEnabled", function(on)
    statusLbl.Text       = on and "FARMING…" or "IDLE"
    statusLbl.TextColor3 = on and VHL.Colors.Green or VHL.Colors.TextPri
    setActive(on)
    if on then
        farmTab:StartPulse(statusPulse, function() return State.FarmEnabled end)
    end
end)

farmTab:Section("Tuning")
farmTab:Slider("Farm Speed", 0.05, 1, 0.15, State, "FarmSpeed")

farmTab:Section("Rarity Filter")
farmTab:RarityDropdown(
    {"Godly","Legendary","Epic","Rare","Common"},
    RARITY_COLORS,
    State.Rarities
)

farmTab:InfoStrip("ℹ  Only selected rarities will be collected.")
```

---

## Changelog

### v2.2
- Added more built-in themes: Neon, Sapphire, Rose, Sunset, Mint, Orchid, Obsidian, Slate.
- Improved runtime theme switching with stronger live repaint support.
- Added `win:GetTheme()`, `win:GetThemes()`, and `win:RefreshTheme()`.
- Added `Tab:Clear()`.
- Strengthened button and slider behavior for safer callbacks and input handling.
- Updated the UI styling toward a more modern transparent look.

### v2.1
- Added six built-in colour themes: Void, Midnight, Crimson, Emerald, Gold, Arctic.
- Added `win:SetTheme(name)` for runtime theme switching.
- Added `VHL.Themes` table for custom theme registration.
- `Toggle` and `Slider` accept a `stateTable + key` pair instead of a global.
- Refactored internal helpers (`tw`, `corner`, `mkStroke`) to reduce duplication.
- `Component.*` functions are fully independent of any global state.

### v2.0
- Initial library extraction from VoidHub v2 script.
- Window, Tab, Section, StatusCard, Toggle, Slider, Button, Dropdown, RarityDropdown, InfoStrip.
