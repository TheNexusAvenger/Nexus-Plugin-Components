--[[
TheNexusAvenger

Tests the PluginInstance class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusPluginComponents = require(game.ReplicatedStorage:WaitForChild("NexusPluginComponents"))
local PluginInstanceTest = NexusUnitTesting.UnitTest:Extend()



--[[
Sets up the test.
--]]
function PluginInstanceTest:Setup()
    --Create the mock settings.
    self.ThemeChangedEvent = Instance.new("BindableEvent")
    self.ThemeColor = Color3.new(1, 0, 0)
    self.ThemeColorDisabled = Color3.new(1, 1, 0)
    local MockSettings = {
        Studio = {
            ThemeChanged = self.ThemeChangedEvent.Event,
            Theme = {
                GetColor = function(_, _, Modifier)
                    if Modifier == Enum.StudioStyleGuideModifier.Disabled then
                        return self.ThemeColorDisabled
                    end
                    return self.ThemeColor
                end
            }
        }
    }
    NexusPluginComponents:GetResource("Base.PluginColor").Settings = MockSettings
    NexusPluginComponents:GetResource("Base.PluginInstance").Settings = MockSettings

    --Create the component under test.
    self.CuT = NexusPluginComponents.new("Frame")
end

--[[
Tests setting the background color with a normal Color3.
--]]
NexusUnitTesting:RegisterUnitTest(PluginInstanceTest.new("BackgroundColor3"):SetRun(function(self)
    self.CuT.BackgroundColor3 = Color3.new(0, 0, 1)
    self:AssertEquals(self.CuT:GetWrappedInstance().BackgroundColor3, Color3.new(0, 0, 1))
end))

--[[
Tests setting the background color with a string name.
--]]
NexusUnitTesting:RegisterUnitTest(PluginInstanceTest.new("BackgroundString"):SetRun(function(self)
    self.CuT.BackgroundColor3 = "Button"
    self:AssertEquals(self.CuT:GetWrappedInstance().BackgroundColor3, Color3.new(1, 0, 0))
end))

--[[
Tests setting the background color with an enum.
--]]
NexusUnitTesting:RegisterUnitTest(PluginInstanceTest.new("BackgroundEnum"):SetRun(function(self)
    self.CuT.BackgroundColor3 = Enum.StudioStyleGuideColor.Button
    self:AssertEquals(self.CuT:GetWrappedInstance().BackgroundColor3, Color3.new(1, 0, 0))
end))

--[[
Tests setting the background color with a PluginColor.
--]]
NexusUnitTesting:RegisterUnitTest(PluginInstanceTest.new("BackgroundPluginColor"):SetRun(function(self)
    self.CuT.BackgroundColor3 = NexusPluginComponents.new("PluginColor", Enum.StudioStyleGuideColor.Button)
    self:AssertEquals(self.CuT:GetWrappedInstance().BackgroundColor3, Color3.new(1, 0, 0))
    self.CuT.BackgroundColor3 = NexusPluginComponents.new("PluginColor", Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Disabled)
    self:AssertEquals(self.CuT:GetWrappedInstance().BackgroundColor3, Color3.new(1, 1, 0))
end))

--[[
Tests setting the background color and changing the theme.
--]]
NexusUnitTesting:RegisterUnitTest(PluginInstanceTest.new("BackgroundThemeChanged"):SetRun(function(self)
    self.CuT.BackgroundColor3 = NexusPluginComponents.new("PluginColor", Enum.StudioStyleGuideColor.Button)
    self:AssertEquals(self.CuT:GetWrappedInstance().BackgroundColor3, Color3.new(1, 0, 0))
    self.ThemeColor = Color3.new(0, 1, 0)
    self.ThemeChangedEvent:Fire()
    self:AssertEquals(self.CuT:GetWrappedInstance().BackgroundColor3, Color3.new(0, 1, 0))
end))

--[[
Tests SetColorModifier with a Color3 background.
--]]
NexusUnitTesting:RegisterUnitTest(PluginInstanceTest.new("SetColorModifierColor3"):SetRun(function(self)
    self.CuT.BackgroundColor3 = Color3.new(0, 0, 1)
    self.CuT:SetColorModifier("BackgroundColor3", Enum.StudioStyleGuideModifier.Disabled)
    self:AssertEquals(self.CuT:GetWrappedInstance().BackgroundColor3, Color3.new(0, 0, 1))
end))

--[[
Tests SetColorModifier with a PluginColor background.
--]]
NexusUnitTesting:RegisterUnitTest(PluginInstanceTest.new("SetColorModifierPluginColor"):SetRun(function(self)
    self.CuT.BackgroundColor3 = Enum.StudioStyleGuideColor.Button
    self.CuT:SetColorModifier("BackgroundColor3", Enum.StudioStyleGuideModifier.Disabled)
    self:AssertEquals(self.CuT:GetWrappedInstance().BackgroundColor3, Color3.new(1, 1, 0))
end))

--[[
Tests SetAllColorModifiers.
--]]
NexusUnitTesting:RegisterUnitTest(PluginInstanceTest.new("SetAllColorModifiers"):SetRun(function(self)
    self.CuT.BackgroundColor3 = Enum.StudioStyleGuideColor.Button
    self.CuT:SetAllColorModifiers(Enum.StudioStyleGuideModifier.Disabled)
    self:AssertEquals(self.CuT:GetWrappedInstance().BackgroundColor3, Color3.new(1, 1, 0))
end))



return true