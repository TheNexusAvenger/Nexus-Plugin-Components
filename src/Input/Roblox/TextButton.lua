--[[
TheNexusAvenger

TextButton class that can be disabled.
--]]
--!strict

local NexusPluginComponents = script.Parent.Parent.Parent
local PluginInstance = require(NexusPluginComponents:WaitForChild("Base"):WaitForChild("PluginInstance"))

local TextButton = PluginInstance:Extend()
TextButton:SetClassName("TextButton")

export type PluginTextButton = {
    new: () -> (PluginTextButton),
    Extend: (self: PluginTextButton) -> (PluginTextButton),

    Disabled: boolean,
} & PluginInstance.PluginInstance & TextButton



--[[
Creates the TextButton.
--]]
function TextButton:__new(): ()
    PluginInstance.__new(self, "TextButton")

    --Add the Disabled property.
    self:DisableChangeReplication("Disabled")
    self:GetPropertyChangedSignal("Disabled"):Connect(function()
        self.AutoButtonColor = not self.Disabled
        self.Active = not self.Disabled
        self:SetAllColorModifiers(self.Disabled and Enum.StudioStyleGuideModifier.Disabled or Enum.StudioStyleGuideModifier.Default)
    end)
    self.Disabled = false
end



return (TextButton :: any) :: PluginTextButton