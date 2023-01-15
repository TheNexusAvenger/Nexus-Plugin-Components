--[[
TheNexusAvenger

ImageButton class that can be disabled.
--]]
--!strict

local NexusPluginComponents = script.Parent.Parent.Parent
local PluginInstance = require(NexusPluginComponents:WaitForChild("Base"):WaitForChild("PluginInstance"))

local ImageButton = PluginInstance:Extend()
ImageButton:SetClassName("ImageButton")

export type PluginImageButton = {
    new: () -> (PluginImageButton),
    Extend: (self: PluginImageButton) -> (PluginImageButton),

    Disabled: boolean,
} & PluginInstance.PluginInstance & ImageButton



--[[
Creates the ImageButton.
--]]
function ImageButton:__new(): ()
    PluginInstance.__new(self, "ImageButton")

    --Add the Disabled property.
    self:DisableChangeReplication("Disabled")
    self:GetPropertyChangedSignal("Disabled"):Connect(function()
        self.AutoButtonColor = not self.Disabled
        self:SetAllColorModifiers(self.Disabled and Enum.StudioStyleGuideModifier.Disabled or Enum.StudioStyleGuideModifier.Default)
    end)
    self.Disabled = false
end



return (ImageButton :: any) :: PluginImageButton