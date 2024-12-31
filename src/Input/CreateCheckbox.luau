--Creates a checkbox frame.
--!strict

local STATE_TEXT = {
    Checked = "✓",
    Mixed = "◼",
    Unchecked = "",
}

local CreateFusionScope = require(script.Parent.Parent:WaitForChild("CreateFusionScope"))
local Fusion = require(script.Parent.Parent:WaitForChild("Fusion"))

local OnEvent = Fusion.OnEvent

export type CheckboxState = "Unchecked" | "Checked" | "Mixed"

return function(Scope: CreateFusionScope.FusionScope, Value: Fusion.Value<CheckboxState>): TextButton
    return Scope:Create("TextButton")({
        BackgroundColor3 = Scope:PluginColor(Enum.StudioStyleGuideColor.CheckedFieldBackground),
        BorderColor3 = Scope:PluginColor(Enum.StudioStyleGuideColor.CheckedFieldBorder),
        TextColor3 = Scope:PluginColor(Enum.StudioStyleGuideColor.CheckedFieldIndicator),
        Font = Enum.Font.Legacy,
        Text = Scope:Computed(function(use)
            return STATE_TEXT[use(Value)] or "?"
        end),
        [OnEvent("MouseButton1Down")] = function()
            if Fusion.peek(Value) == "Unchecked" then
                Value:set("Checked")
            else
                Value:set("Unchecked")
            end
        end,
    }) :: TextButton
end