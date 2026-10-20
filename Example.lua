--[[
	Lunar UI Library -- Example script

	Showcases:
	  - Window / Pages and the search box (top-right; results popup, click to jump to the element)
	  - Toggles (with keybind + colorpicker attached), risk toggle
	  - Sliders (suffixes, decimals, programmatic set, visibility control)
	  - Dropdowns (single + multi select + dynamic options refresh)
	  - Textboxes, buttons, labels
	  - Programmatic API demo (set values from buttons)
	  - SaveManager: create / overwrite / delete / autoload configs
	  - ThemeManager: presets, custom accent picker, savable themes, autoload

	Load it (or copy this file) and it just runs.
]]

-- // Load the library (raw from GitHub)
local Start = tick()
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/omegayy/LunarLib/main/Libraries/Library.lua"))()

-- // Window
local Window = Library:Window({Size = UDim2.new(0, 580, 0, 600)})

-- // Pages
local main = Window:Page({Name = "Main"})
local demo = Window:Page({Name = "Demos"})
local config = Window:Page({Name = "Config"})

-- // objects we want to poke from other pages
local DemoToggle, DemoSlider, DemoDropdown, DemoTextbox

------------------------------------------------------------------
-- // MAIN
------------------------------------------------------------------
do
	local toggles = main:Section({Name = "Toggles", Size = 260}) do
		DemoToggle = toggles:Toggle({
			Name = "Example toggle",
			Flag = "Example_Toggle",
			Default = false,
			Callback = function(Bool)
				print("[Example] toggle:", Bool)
			end
		})

		toggles:Toggle({
			Name = "Risk toggle (gold text)",
			Flag = "Example_Risk",
			Risk = true,
			Callback = function(Bool)
				print("[Example] risk toggle:", Bool)
			end
		})

		-- // a toggle that owns a keybind AND an attached colorpicker
		local Keyified = toggles:Toggle({
			Name = "With keybind + color",
			Flag = "Example_KeyToggle",
			Callback = function(Bool)
				print("[Example] keybind toggle:", Bool)
			end
		})

		Keyified:Keybind({
			Name = "Hold",
			Flag = "Example_Key",
			Default = Enum.KeyCode.LeftShift,
			Mode = "Toggle",
			Callback = function(State)
				print("[Example] keybind state:", State)
			end
		})

		Keyified:Colorpicker({
			Name = "Color",
			Flag = "Example_Color",
			Default = Color3.fromRGB(255, 0, 0),
			Callback = function(Color, Alpha)
				print("[Example] picker color:", Color, Alpha)
			end
		})
	end

	local sliders = main:Section({Name = "Sliders", Size = 240, Side = "Right"}) do
		DemoSlider = sliders:Slider({
			Name = "Speed",
			Flag = "Example_Speed",
			Min = 0,
			Max = 1000,
			Default = 100,
			Decimals = 1,
			Suffix = " m/s",
			Callback = function(Value)
				print("[Example] speed:", Value)
			end
		})

		-- // a slider that starts hidden and gets shown by the toggle below
		local HiddenSlider = sliders:Slider({
			Name = "Hidden slider",
			Flag = "Example_HiddenSlider",
			Min = 0,
			Max = 100,
			Default = 50,
			Decimals = 1
		})

		HiddenSlider:SetVisible(false)

		sliders:Toggle({
			Name = "Show hidden slider",
			Flag = "Example_ShowHidden",
			Callback = function(Bool)
				HiddenSlider:SetVisible(Bool)
			end
		})
	end
end

------------------------------------------------------------------
-- // DEMOS (programmatic API + inputs)
------------------------------------------------------------------
do
	local inputs = demo:Section({Name = "Inputs", Size = 200}) do
		DemoDropdown = inputs:Dropdown({
			Name = "Single dropdown",
			Flag = "Example_Dropdown",
			Options = {"Option A", "Option B", "Option C"},
			Default = "Option A",
			Callback = function(Option)
				print("[Example] dropdown:", Option)
			end
		})

		inputs:Dropdown({
			Name = "Multi dropdown",
			Flag = "Example_MultiDropdown",
			Options = {"Red", "Green", "Blue", "Yellow"},
			Default = {"Red", "Green"},
			Max = 9e9,
			Callback = function(Choices)
				print("[Example] multi:", table.concat(Choices, ", "))
			end
		})

		DemoTextbox = inputs:Textbox({
			Name = "Textbox",
			Flag = "Example_Textbox",
			Placeholder = "type something...",
			Callback = function(Text)
				print("[Example] textbox:", Text)
			end
		})

		inputs:Button({
			Name = "Say something",
			Callback = function()
				Library:Notification("Hello from the example!", 3, Library.Accent, Library.Flags["Notification Position"] or "Top Left")
			end
		})

		inputs:Label({Name = "Labels are just text - like this one."})
	end

	local api = demo:Section({Name = "Programmatic API", Size = 200, Side = "Right"}) do
		api:Button({
			Name = "Set toggle ON",
			Callback = function()
				DemoToggle.Set(true)
			end
		})

		api:Button({
			Name = "Set toggle OFF",
			Callback = function()
				DemoToggle.Set(false)
			end
		})

		api:Button({
			Name = "Slider to 42",
			Callback = function()
				DemoSlider:Set(42)
			end
		})

		api:Button({
			Name = "Dropdown -> Option B",
			Callback = function()
				DemoDropdown:Set("Option B")
			end
		})

		api:Button({
			Name = "Shuffle dropdown options",
			Callback = function()
				local Words = {"Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot"}
				--
				for Index = #Words, 2, -1 do
					local Swap = math.random(1, Index)
					Words[Index], Words[Swap] = Words[Swap], Words[Index]
				end
				--
				DemoDropdown:Refresh(Words)
			end
		})
	end
end

------------------------------------------------------------------
-- // CONFIG (SaveManager + ThemeManager)
------------------------------------------------------------------
do
	local configs = config:Section({Name = "Configs", Size = 260}) do
		SaveManager:BuildConfigSection(configs)
	end

	--
	local themes = config:Section({Name = "Theme", Size = 260, Side = "Right"}) do
		ThemeManager:BuildThemeSection(themes)
	end
end

------------------------------------------------------------------
-- // Boot the managers (folders + autoload)
------------------------------------------------------------------
SaveManager:SetLibrary(Library)
SaveManager:SetFolder("LunarExample")

ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder("LunarExample")

-- // apply the saved theme first (accent color), then the saved config
ThemeManager:LoadAutoloadTheme()
SaveManager:LoadAutoloadConfig()

print("[Example] loaded in " .. math.floor((tick() - Start) * 1000) .. "ms")
