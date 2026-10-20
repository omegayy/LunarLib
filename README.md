# LunarLib

A standalone, self-contained Roblox UI library — the Lunar-style custom menu, rebuilt as a proper library with **config saving**, **accent theming** and a built-in **element search**. Nothing else included: no game features, just the UI.

## Loading

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/omegayy/LunarLib/main/Libraries/Library.lua"))()

-- // optionally also grab the managers if you keep references
local SaveManager = SaveManager   -- // exposed via getgenv() at load
local ThemeManager = ThemeManager
```

A full runnable demo is in [`Example.lua`](Example.lua):

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/omegayy/LunarLib/main/Example.lua"))()
```

## Features

- Dark themed window with draggable bar, tab bar and a **search box** (top-right) with a scored results dropdown — click a result to jump straight to its page and get the element highlighted with an accent flash
- Pages (`Window:Page`) / sections with left & right columns
- Elements: Toggle (+ attached Keybind & Colorpicker), Risk toggle, Slider, Dropdown (single & multi select + dynamic refresh), Textbox, Button, Label, standalone Colorpicker
- Keybind list overlay (toggle in the Config page)
- Notifications
- **SaveManager** — Linoria-style config saving with create / overwrite / delete / refresh / autoload
- **ThemeManager** — accent colorpicker, 10 preset accents, savable themes, theme autoload

## UI API

```lua
local Window = Library:Window({Size = UDim2.new(0, 580, 0, 600)})
local Page = Window:Page({Name = "Main"})
local Section = Page:Section({Name = "Settings", Side = "Left"}) -- // "Right" also works

Section:Toggle({
    Name = "Toggle", Flag = "MyToggle", Default = false, Risk = false,
    Callback = function(Bool) end
})
Section:Slider({
    Name = "Slider", Flag = "MySlider", Min = 0, Max = 100,
    Default = 20, Decimals = 1, Suffix = " m",
    Callback = function(Number) end
})
Section:Dropdown({
    Name = "Dropdown", Flag = "MyDropdown",
    Options = {"A", "B", "C"}, Default = "A",
    Max = 9e9, -- // set to make it multi-select
    Callback = function(Option) end
})
Section:Textbox({
    Name = "Textbox", Flag = "MyTextbox", Placeholder = "...",
    Callback = function(Text) end
})
Section:Button({Name = "Button", Callback = function() end})
Section:Label({Name = "Some text", Centered = false})

local Toggle = Section:Toggle({Name = "Toggle", Flag = "MyToggle"})
Toggle:Keybind({Name = "Key", Flag = "MyKey", Default = Enum.KeyCode.LeftShift, Mode = "Toggle", Callback = function(State) end})
Toggle:Colorpicker({Name = "Color", Flag = "MyColor", Default = Color3.fromRGB(255, 0, 0), Callback = function(Color3, Alpha) end})
Section:Colorpicker({Name = "Color", Flag = "MyColor2", Default = Color3.fromRGB(255, 0, 0), Callback = function(Color3, Alpha) end})
```

### Programmatic value setting

```lua
Toggle.Set(true)             -- // plain function on the toggle object
MySlider:Set(42)             -- // sliders / dropdowns / colorpickers use :Set
MySlider:SetVisible(false)
MyDropdown:Refresh({"New A", "New B"})  -- // rebuild the option list
MyDropdown:Set("New B")
```

## SaveManager

```lua
SaveManager:SetLibrary(Library)
SaveManager:SetFolder("LunarSettings")               -- // root folder for files
SaveManager:SetIgnoreSaving({ "Flag1", "Flag2" })    -- // flags excluded from saved configs
SaveManager:BuildConfigSection(AnySection)           -- // builds the full config UI
SaveManager:LoadAutoloadConfig()                     -- // applies autoload (do this after building UI)
SaveManager:Save("name") / :Load("name") / :Delete("name") / :GetConfigList()
```

Files live in `<Folder>/Configs/*.cfg`, autoload pointer in `<Folder>/autoload.txt`.

## ThemeManager

```lua
ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder("LunarSettings")
ThemeManager:BuildThemeSection(AnySection)           -- // builds the theme UI
ThemeManager:LoadAutoloadTheme()                     -- // apply saved accent on boot

Library:ChangeAccent(Color3)                         -- // recolor the whole menu manually
```

Themes are stored in `<Folder>/Themes.json`. Menu color is driven by `Library.Accent` + `ChangeAccent`.

## Notes

- Config format is the Lunar key/value format (`rgb(...)`, `bool(...)`, `string(...)`, `key(...)`, ...), readable as plain text
- The library prints & exposes `Library.Version` (`LunarLib-YYYY-MM-DD`)
- Tested syntax-wise with Luau compile; for executor quirks, open an issue
