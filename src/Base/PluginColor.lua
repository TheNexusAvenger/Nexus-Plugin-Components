--[[
TheNexusAvenger

Helper class for managing plugin colors.
--]]

local NexusPluginComponents = require(script.Parent.Parent)

local NexusObject = NexusPluginComponents:GetResource("NexusInstance.NexusObject")

local PluginColor = NexusObject:Extend()
PluginColor:SetClassName("PluginColor")
PluginColor.Settings = settings()



--[[
Creates the plugin color.
--]]
function PluginColor:__new(ColorEnum, ModiferEnum)
    self:InitializeSuper()

    --Convert the enums.
    if typeof(ColorEnum) == "string" then
        ColorEnum = Enum.StudioStyleGuideColor[ColorEnum]
    end
    if typeof(ModiferEnum) == "string" then
        ModiferEnum = Enum.StudioStyleGuideModifier[ModiferEnum]
    end

    --Store the color.
    self.ColorEnum = ColorEnum
    self.ModiferEnum = ModiferEnum or Enum.StudioStyleGuideModifier.Default
    self.Color3 = self.Settings.Studio.Theme:GetColor(self.ColorEnum, self.ModiferEnum)
end

--[[
Returns the Color3 to use.
--]]
function PluginColor:GetColor()
    return self.Color3
end



return PluginColor