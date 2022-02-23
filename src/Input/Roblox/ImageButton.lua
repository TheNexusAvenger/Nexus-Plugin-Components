--[[
TheNexusAvenger

ImageButton class that can be disabled.
--]]

local NexusPluginComponents = require(script.Parent.Parent.Parent)

local PluginInstance = NexusPluginComponents:GetResource("Base.PluginInstance")

local ImageButton = PluginInstance:Extend()
ImageButton:SetClassName("ImageButton")



--[[
Creates the ImageButton.
--]]
function ImageButton:__new()
    self:InitializeSuper("ImageButton")

    --Add the Disabled property.
    self:DisableChangeReplication("Disabled")
    self:GetPropertyChangedSignal("Disabled"):Connect(function()
        self.AutoButtonColor = not self.Disabled
        self:SetAllColorModifiers(self.Disabled and Enum.StudioStyleGuideModifier.Disabled or Enum.StudioStyleGuideModifier.Default)
    end)
    self.Disabled = false
end



return ImageButton