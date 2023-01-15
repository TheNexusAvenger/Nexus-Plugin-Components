--[[
TheNexusAvenger

Custom checkbox button input.
--]]
--!strict

local STATE_TEXT = {
    Checked = "✓",
    Mixed = "◼",
    Unchecked = "",
}



local NexusPluginComponents = script.Parent.Parent.Parent
local PluginInstance = require(NexusPluginComponents:WaitForChild("Base"):WaitForChild("PluginInstance"))

local Checkbox = PluginInstance:Extend()
Checkbox:SetClassName("Checkbox")

export type Checkbox = {
    new: () -> (Checkbox),
    Extend: (self: Checkbox) -> (Checkbox),

    Value: "Unchecked" | "Checked" | "Mixed" | string,
    Toggle: (self: Checkbox) -> (),
} & PluginInstance.PluginInstance & TextButton



--[[
Creates the Checkbox.
--]]
function Checkbox:__new(): ()
    PluginInstance.__new(self, "TextButton")

    --Set the defaults.
    self.BackgroundColor3 = Enum.StudioStyleGuideColor.CheckedFieldBackground
    self.BorderColor3 = Enum.StudioStyleGuideColor.CheckedFieldBorder
    self.TextColor3 = Enum.StudioStyleGuideColor.CheckedFieldIndicator
    self.Font = Enum.Font.Legacy

    --Add the value property.
    self:AddPropertyFinalizer("Value", function(Value: string): ()
        self.Text = STATE_TEXT[self.Value] or "?"
    end)
    self:DisableChangeReplication("Value")
    self.Value = "Unchecked"

    --Connect toggling the value.
    local DB = true
    self.MouseButton1Down:Connect(function()
        if DB then
            DB = false
            self:Toggle()
            task.wait()
            DB = true
        end
    end)
end

--[[
Toggles the checkbox.
--]]
function Checkbox:Toggle(): ()
    if self.Value == "Unchecked" then
        self.Value = "Checked"
    else
        self.Value = "Unchecked"
    end
end



return (Checkbox :: any) :: Checkbox