--[[
TheNexusAvenger

Toggle button for a PluginGui.
--]]
--!strict

local NexusPluginComponents = script.Parent.Parent.Parent
local PluginInstance = require(NexusPluginComponents:WaitForChild("Base"):WaitForChild("PluginInstance"))

local PluginToggleButton = PluginInstance:Extend()
PluginToggleButton:SetClassName("PluginToggleButton")

export type PluginToggleButton = {
    new: (Button: PluginToolbarButton, PluginGui: PluginGui) -> (PluginToggleButton),
    Extend: (self: PluginToggleButton) -> (PluginToggleButton),
} & PluginInstance.PluginInstance & TextBox



--[[
Creates the Plugin Toggle Button.
--]]
function PluginToggleButton:__new(Button: PluginToolbarButton, PluginGui: PluginGui): ()
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
            task.wait()
            DB = true
        end
    end)

    --Set the default.
    self:SetActive(PluginGui.Enabled)
end



return (PluginToggleButton :: any) :: PluginToggleButton