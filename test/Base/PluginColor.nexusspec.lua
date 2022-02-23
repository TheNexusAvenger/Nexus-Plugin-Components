--[[
TheNexusAvenger

Tests the PluginColor class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusPluginComponents = require(game.ReplicatedStorage:WaitForChild("NexusPluginComponents"))
local PluginColorTest = NexusUnitTesting.UnitTest:Extend()



--[[
Tests the constructors with GetColor.
--]]
NexusUnitTesting:RegisterUnitTest(PluginColorTest.new("GetColor"):SetRun(function(self)
    --Set the mock settings.
    NexusPluginComponents:GetResource("Base.PluginColor").Settings = {
        Studio = {
            Theme = {
                GetColor = function(_, Color, Modifier)
                    if Color == Enum.StudioStyleGuideColor.Button then
                        if Modifier == Enum.StudioStyleGuideModifier.Default then
                            return Color3.new(1, 0, 0)
                        elseif Modifier == Enum.StudioStyleGuideModifier.Disabled then
                            return Color3.new(0, 1, 0)
                        end
                    end
                end
            }
        }
    }

    --Test the colors.
    self:AssertEquals(NexusPluginComponents.new("PluginColor", "Button"):GetColor(), Color3.new(1, 0, 0))
    self:AssertEquals(NexusPluginComponents.new("PluginColor", Enum.StudioStyleGuideColor.Button):GetColor(), Color3.new(1, 0, 0))
    self:AssertEquals(NexusPluginComponents.new("PluginColor", Enum.StudioStyleGuideColor.Button, "Disabled"):GetColor(), Color3.new(0, 1, 0))
    self:AssertEquals(NexusPluginComponents.new("PluginColor", Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Disabled):GetColor(), Color3.new(0, 1, 0))
end))



return true