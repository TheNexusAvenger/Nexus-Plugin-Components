--[[
TheNexusAvenger

TextBox class that can be disabled.
--]]

local NexusPluginComponents = require(script.Parent.Parent.Parent)

local PluginInstance = NexusPluginComponents:GetResource("Base.PluginInstance")

local TextBox = PluginInstance:Extend()
TextBox:SetClassName("TextBox")



--[[
Creates the TextBox.
--]]
function TextBox:__new()
    self:InitializeSuper("TextBox")

    --Add the Disabled property.
    self:DisableChangeReplication("Disabled")
    self:GetPropertyChangedSignal("Disabled"):Connect(function()
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



return TextBox