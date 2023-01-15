--[[
TheNexusAvenger

Helper class for managing plugin colors.
--]]
--!strict

local NexusPluginComponents = script.Parent.Parent
local NexusObject = require(NexusPluginComponents:WaitForChild("NexusInstance"):WaitForChild("NexusObject"))

local PluginColor = NexusObject:Extend()
PluginColor:SetClassName("PluginColor")
pcall(function()
    PluginColor.Settings = settings()
end)

export type PluginColor = {
    new: (ColorEnum: string | Enum.StudioStyleGuideColor, ModiferEnum: string? | Enum.StudioStyleGuideModifier?) -> (PluginColor),
    Extend: (self: PluginColor) -> (PluginColor),

    GetColor: (self: PluginColor) -> (Color3),
} & NexusObject.NexusObject



--[[
Creates the plugin color.
--]]
function PluginColor:__new(ColorEnum: string | Enum.StudioStyleGuideColor, ModiferEnum: string? | Enum.StudioStyleGuideModifier?): ()
    NexusObject.__new(self)

    --Convert the enums.
    if typeof(ColorEnum) == "string" then
        ColorEnum = (Enum.StudioStyleGuideColor :: any)[ColorEnum]
    end
    if typeof(ModiferEnum) == "string" then
        ModiferEnum = (Enum.StudioStyleGuideModifier :: any)[ModiferEnum]
    end

    --Store the color.
    self.ColorEnum = ColorEnum
    self.ModiferEnum = ModiferEnum or Enum.StudioStyleGuideModifier.Default
    if self.Settings then
        self.Color3 = self.Settings.Studio.Theme:GetColor(self.ColorEnum, self.ModiferEnum)
    else
        self.Color3 = Color3.new(0, 0, 0)
    end
end

--[[
Returns the Color3 to use.
--]]
function PluginColor:GetColor(): Color3
    return self.Color3
end



return (PluginColor :: any) :: PluginColor