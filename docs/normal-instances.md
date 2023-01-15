# Normal Instances
With Nexus Plugin Components, the primary change is to use
`NexusPluginComponents.new(...)` instead of `Instance.new(...)`.
Example:
```lua
local NexusPluginComponents = require(game.ReplicatedStorage:WaitForChild("NexusPluginComponents"))

local ScreenGui = NexusPluginComponents.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer and game.Players.LocalPlayer:FindFirstChild("PlayerGui") or game.StarterGui

local Frame = NexusPluginComponents.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 200)
Frame.Parent = ScreenGui

local TextBox = NexusPluginComponents.new("TextButton")
TextBox.Size = UDim2.new(0, 160, 0, 30)
TextBox.Text = "Button"
TextBox.Position = UDim2.new(0, 20, 0, 60)
TextBox.Parent = Frame
```

One limitation of this is that `NexusPluginComponents` instance can
be parented to normal instances, but not the other way around.
If the base instance is needed, use `:GetWrappedInstance()`.

## Colors
One of the primary features offered by Nexus Plugin Components
is theme support. Rather than providing `Color3`s and managing
them, a theme color can be specified instead. The following
all function the same:
```lua
--Enum-based.
Frame.BackgroundColor3 = Enum.StudioStyleGuideColor.Tab
Frame:SetColorModifier("BackgroundColor3", Enum.StudioStyleGuideModifier.Selected) --Only neded if not using Enum.StudioStyleGuideModifier.Default

--String-based.
Frame.BackgroundColor3 = "Tab"
Frame:SetColorModifier("BackgroundColor3", Enum.StudioStyleGuideModifier.Selected) --Only neded if not using Enum.StudioStyleGuideModifier.Default

--PluginColor based (option 1)
Frame.BackgroundColor3 = NexusPluginComponents.new("PluginColor", Enum.StudioStyleGuideColor.Tab) --Can use Enums or Strings.
Frame:SetColorModifier("BackgroundColor3", Enum.StudioStyleGuideModifier.Selected) --Only neded if not using Enum.StudioStyleGuideModifier.Default

--PluginColor based (option 2)
Frame.BackgroundColor3 = NexusPluginComponents.new("PluginColor", Enum.StudioStyleGuideColor.Tab, Enum.StudioStyleGuideModifier.Selected) --Can use Enums or Strings.
```

Be aware of comparisons since the underlying type will be
stored as a `PluginColor`.
```lua
Frame.BackgroundColor3 = Enum.StudioStyleGuideColor.Tab
print(Frame.BackgroundColor3 == "Tab") --false
print(Frame.BackgroundColor3 == Enum.StudioStyleGuideColor.Tab) --false
print(Frame.BackgroundColor3) --PluginColor: 0x(memory address)
```

## Other Properties
Some other instance types include additional properties that can
be used, including:
- `ImageButton` - `ImageButton.Disabled`
- `TextButton` - `TextButton.Disabled`
- `TextBox` - `TextBox.Disabled`