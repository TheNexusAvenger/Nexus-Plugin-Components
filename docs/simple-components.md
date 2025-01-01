# Simple Components
## `CreateCheckbox`
Checkboxes are simple buttons that control a Fusion value that are
`"Unchecked"`, `"Checked"`, and `"Mixed"`.

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CreateFusionScope = require(ReplicatedStorage:WaitForChild("NexusPluginComponents"):WaitForChild("CreateFusionScope"))
local CreateCheckbox = require(ReplicatedStorage:WaitForChild("NexusPluginComponents"):WaitForChild("Input"):WaitForChild("CreateCheckbox"))

local Scope = CreateFusionScope()
local Value = Scope:Value("Checked")
Scope:Hydrate(CreateCheckbox(Scope, Value))({
    Size = ...,
    Parent = ...,
})
```

## `CreatePluginToggleButton`
Plugin toggle buttons automatically set the active state of plugin
buttons based on the linked window being enabled or not. Clicking
the button will also toggle the visibility of the window.

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CreatePluginToggleButton.spec = require(ReplicatedStorage:WaitForChild("NexusPluginComponents"):WaitForChild("Input"):WaitForChild("Plugin"):WaitForChild("CreatePluginToggleButton"))

--No scope required!
local TestToolbar = plugin:CreateToolbar("Test Toolbar")
local TestButton = TestToolbar:CreateButton("Test Button")
local Window = Plugin:CreateDockWidgetPluginGui("Test Window", DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float))
CreatePluginToggleButton(TestButton, Window)
```

## `CreateSlider`
Sliders allow for selecting number values. When no range is provided,
the operate between the number 0 and 1, and the slider UI is
clamped in case the value goes above or below.

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CreateFusionScope = require(ReplicatedStorage:WaitForChild("NexusPluginComponents"):WaitForChild("CreateFusionScope"))
local CreateSlider = require(ReplicatedStorage:WaitForChild("NexusPluginComponents"):WaitForChild("Input"):WaitForChild("CreateSlider"))

local Scope = CreateFusionScope()
local Value = Scope:Value(0.5)
Scope:Hydrate(CreateSlider(Scope, Value))({
    Size = ...,
    Parent = ...,
})
```

Two options can be passed in:
- `ValueRange`: A `NumberRange` for the minimum and maximum values
  to allow selecting. Defaults to `NumberRange.new(0, 1)`.
  *Can be a Fusion Value*.
- `ValueIncrement`: A `number` for the multiplier the number can
  be. Defaults to `0.001`. *Can be a Fusion Value*.

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CreateFusionScope = require(ReplicatedStorage:WaitForChild("NexusPluginComponents"):WaitForChild("CreateFusionScope"))
local CreateSlider = require(ReplicatedStorage:WaitForChild("NexusPluginComponents"):WaitForChild("Input"):WaitForChild("CreateSlider"))

local Scope = CreateFusionScope()
local Value = Scope:Value(5)
local Options = {
    ValueRange = NumberRange.new(1, 10), --Or: Scope:Value(NumberRange.new(1, 10))
    ValueIncrement = 1, --Or: Scope:Value(1)
}
Scope:Hydrate(CreateSlider(Scope, Value, Options))({
    Size = ...,
    Parent = ...,
})
```