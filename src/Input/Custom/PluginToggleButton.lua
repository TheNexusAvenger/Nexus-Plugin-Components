--[[
TheNexusAvenger

Toggle button for a PluginGui.
--]]

local NexusPluginComponents = require(script.Parent.Parent.Parent)

local PluginInstance = NexusPluginComponents:GetResource("Base.PluginInstance")

local PluginToggleButton = PluginInstance:Extend()
PluginToggleButton:SetClassName("PluginToggleButton")



--[[
Creates the Plugin Toggle Button.
--]]
function PluginToggleButton:__new(Button, PluginGui)
    PluginInstance.__new(self, Button)

    --Set up the changed event.
    PluginGui:GetPropertyChangedSignal("Enabled"):Connect(function()
        self:SetActive(PluginGui.Enabled)
    end)

    --Set up toggling the PluginGui.
    local DB = true
    self.Click:Connect(function()
        if DB then
            DB = false
            PluginGui.Enabled = not PluginGui.Enabled
            self:SetActive(PluginGui.Enabled)
            wait()
            DB = true
        end
    end)

    --Set the default.
    self:SetActive(PluginGui.Enabled)
end



return PluginToggleButton