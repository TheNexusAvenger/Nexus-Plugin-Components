--[[
TheNexusAvenger

Custom checkbox button input.
--]]

local STATE_TEXT = {
    Checked = "✔",
    Mixed = "◼",
    Unchecked = "",
}



local NexusPluginComponents = require(script.Parent.Parent.Parent)

local PluginInstance = NexusPluginComponents:GetResource("Base.PluginInstance")

local Checkbox = PluginInstance:Extend()
Checkbox:SetClassName("Checkbox")



--[[
Creates the Checkbox.
--]]
function Checkbox:__new()
    self:InitializeSuper("TextButton")

    --Set the defaults.
    self.BackgroundColor3 = Enum.StudioStyleGuideColor.CheckedFieldBackground
    self.BorderColor3 = Enum.StudioStyleGuideColor.CheckedFieldBorder
    self.TextColor3 = Enum.StudioStyleGuideColor.CheckedFieldIndicator

    --Add the value property.
    self:GetPropertyChangedSignal("Value"):Connect(function()
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
            wait()
            DB = true
        end
    end)
end

--[[
Toggles the checkbox.
--]]
function Checkbox:Toggle()
    if self.Value == "Unchecked" then
        self.Value = "Checked"
    else
        self.Value = "Unchecked"
    end
end



return Checkbox