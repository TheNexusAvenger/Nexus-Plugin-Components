# Normal Instances
Nexus Plugin Components uses [Fusion](https://elttob.uk/Fusion/) for creating
instances. Fusion's docs will provide the basics while below covers specifics.

## Fusion Scopes
All functions within Nexus Plugin Components assume using the provided scope
implementation.

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CreateFusionScope = require(ReplicatedStorage:WaitForChild("NexusPluginComponents"):WaitForChild("CreateFusionScope"))
```

The scope provides the following additions to the default scope:
- `PluginColor: (Scope: FusionScope, Color: Fusion.UsedAs<Enum.StudioStyleGuideColor>, Modifier: Fusion.UsedAs<Enum.StudioStyleGuideModifier>?) -> (Fusion.UsedAs<Color3>)`:
  Creates a `Color3` value based on the given Studio style guide
  color and optional modifier.
- `Create: (Scope: FusionScope, ClassName: string, Enabled: Fusion.UsedAs<boolean>?) -> (FusionTypes.PropertyTable) -> (Instance)`:
  Creates instances with additional default behavior over `New`.
- `ValueFromProperty: <T>(Scope: FusionScope, Ins: Fusion.UsedAs<any?>, PropertyName: string) -> (Fusion.Value<T?>)`:
  Creates a Fusion value for a property of an instance.

## Creating Instances
While Fusion uses `New` to create instances, an alternative `Create`
is provided that adds some additional default behavior. It can be
used as normal.

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CreateFusionScope = require(ReplicatedStorage:WaitForChild("NexusPluginComponents"):WaitForChild("CreateFusionScope"))

local Scope = CreateFusionScope()
local TestTextLabel = Scope:Create("TextLabel")({
    Visible = Scope:Computed(...), --Values work as normal.
    Text = "My text", --Hard-coded values work as normal.
})
```

`Create` will change some defaults and provide default colors that
will use Studio's theme colors. These colors automatically change with
the theme changing.

## Studio Theme Colors
`PluginColor` can be used to customize colors.

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CreateFusionScope = require(ReplicatedStorage:WaitForChild("NexusPluginComponents"):WaitForChild("CreateFusionScope"))

local Scope = CreateFusionScope()
local Color = Scope:Value(Enum.StudioStyleGuideColor.MainText)
local Modifier = Scope:Value(Enum.StudioStyleGuideModifier.Hover)
local TestTextLabel = Scope:Create("TextLabel")({
    TextColor3 = Scope:PluginColor(Enum.StudioStyleGuideColor.MainText), --Hard-coded color, default modifier.
    TextColor3 = Scope:PluginColor(Enum.StudioStyleGuideColor.MainText, Enum.StudioStyleGuideModifier.Hover), --Hard-coded color, hard-coded modifier.
    TextColor3 = Scope:PluginColor(Enum.StudioStyleGuideColor.MainText, Modifier), --hard-coded color, value modifier.
    TextColor3 = Scope:PluginColor(Color, Enum.StudioStyleGuideModifier.Hover), --Value color, hard-coded modifier.
    TextColor3 = Scope:PluginColor(Color, Modifier), --Value color, value modifier.
})
```

For hard-coded colors, the call to `Scope::PluginColor` can be
removed in favor of just the enum. **Values are not supported
for this use case.**

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CreateFusionScope = require(ReplicatedStorage:WaitForChild("NexusPluginComponents"):WaitForChild("CreateFusionScope"))

local Scope = CreateFusionScope()
local TestTextLabel = Scope:Create("TextLabel")({
    TextColor3 = Enum.StudioStyleGuideColor.MainText,
    --This is NOT supported: TextColor3 = Scope:Value(Enum.StudioStyleGuideColor.MainText),
})
```

## Enabled/Disable Effects
An optional `Fusion.Value<boolean>` can be passed into `Create`
to toggle the instance being enabled or disabled. It will not
stop inputs, but it will modify colors and change `AutoButtonColor`
(buttons only) if no override behavior is given.


```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CreateFusionScope = require(ReplicatedStorage:WaitForChild("NexusPluginComponents"):WaitForChild("CreateFusionScope"))

local Scope = CreateFusionScope()
local Enabled = Scope:Value(true) --Can also use Scope:Computed(...)
local TestTextButton = Scope:Create("TestTextButton", Enabled)({
    --No color/AutoButtonColor will be affected by Enabled.
    TextColor3 = Enum.StudioStyleGuideColor.MainText, --This will be affected by Enabled.
    TextColor3 = Color3.fromRGB(255, 0, 0), --This will NOT be affected by Enbaled.
    TextColor3 = Scope:PluginColor(Enum.StudioStyleGuideColor.MainText), --This will NOT be affected by Enbaled.
    TextColor3 = Scope:Computed(...), --This will NOT be affected by Enbaled.
    --This is NOT supported: TextColor3 = Scope:Value(Enum.StudioStyleGuideColor.MainText),
})

Enabled:set(false) --Disables the instance.
```