--[[
TheNexusAvenger

TextBox class that can be disabled.
--]]
--!strict

local NexusPluginComponents = script.Parent.Parent.Parent
local PluginInstance = require(NexusPluginComponents:WaitForChild("Base"):WaitForChild("PluginInstance"))

local TextBox = PluginInstance:Extend()
TextBox:SetClassName("TextBox")

export type PluginTextBox = {
    new: () -> (PluginTextBox),
    Extend: (self: PluginTextBox) -> (PluginTextBox),

    Disabled: boolean,
} & PluginInstance.PluginInstance & TextBox



--[[
Creates the TextBox.
--]]
function TextBox:__new(): ()
    PluginInstance.__new(self, "TextBox")

    --Add the Disabled property.
    self:DisableChangeReplication("Disabled")
    self:GetPropertyChangedSignal("Disabled"):Connect(function()
        self.Active = not self.Disabled
        if self.Disabled then
            self:ReleaseFocus()
        end
        self:SetAllColorModifiers(self.Disabled and Enum.StudioStyleGuideModifier.Disabled or Enum.StudioStyleGuideModifier.Default)
    end)
    self.Focused:Connect(function()
        if not self.Disabled then return end
        self:ReleaseFocus()
    end)
    self.Disabled = false
end



return (TextBox :: any) :: PluginTextBox