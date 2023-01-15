--[[
TheNexusAvenger

Tests the PluginColor class.
--]]
--!strict

local NexusPluginComponentsModule = game.ReplicatedStorage:WaitForChild("NexusPluginComponents")
local NexusPluginComponents = require(NexusPluginComponentsModule)
local PluginColor = require(NexusPluginComponentsModule:WaitForChild("Base"):WaitForChild("PluginColor"))
local PluginInstance = require(NexusPluginComponentsModule:WaitForChild("Base"):WaitForChild("PluginInstance"))

return function()
    local MockThemeChangedEvent, MockThemeColor, MockSettings, TestPluginInstance = nil, nil, nil, nil
    beforeEach(function()
        MockThemeChangedEvent = Instance.new("BindableEvent")
        MockThemeColor = Color3.new(1, 0, 0)
        MockSettings = {
            Studio = {
                ThemeChanged = MockThemeChangedEvent.Event,
                Theme = {
                    GetColor = function(_, _, Modifier)
                        if Modifier == Enum.StudioStyleGuideModifier.Disabled then
                            return Color3.new(1, 1, 0)
                        end
                        return MockThemeColor
                    end
                }
            }
        }
        PluginColor.Settings = MockSettings
        PluginInstance.Settings = MockSettings
        TestPluginInstance = NexusPluginComponents.new("Frame")
    end)

    describe("A plugin instance", function()
        it("should set the background color with a Color3.", function()
            TestPluginInstance.BackgroundColor3 = Color3.new(0, 0, 1)
            expect(TestPluginInstance:GetWrappedInstance().BackgroundColor3).to.equal(Color3.new(0, 0, 1))
        end)

        it("should set the background color with a string.", function()
            TestPluginInstance.BackgroundColor3 = "Button"
            expect(TestPluginInstance:GetWrappedInstance().BackgroundColor3).to.equal(Color3.new(1, 0, 0))
        end)

        it("should set the background color with an Enum.", function()
            TestPluginInstance.BackgroundColor3 = Enum.StudioStyleGuideColor.Button
            expect(TestPluginInstance:GetWrappedInstance().BackgroundColor3).to.equal(Color3.new(1, 0, 0))
        end)

        it("should set the background color with a PluginColor.", function()
            TestPluginInstance.BackgroundColor3 = NexusPluginComponents.new("PluginColor", Enum.StudioStyleGuideColor.Button)
            expect(TestPluginInstance:GetWrappedInstance().BackgroundColor3).to.equal(Color3.new(1, 0, 0))
            TestPluginInstance.BackgroundColor3 = NexusPluginComponents.new("PluginColor", Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Disabled)
            expect(TestPluginInstance:GetWrappedInstance().BackgroundColor3).to.equal(Color3.new(1, 1, 0))
        end)

        it("shoiuld change the color when the theme changes.", function()
            TestPluginInstance.BackgroundColor3 = NexusPluginComponents.new("PluginColor", Enum.StudioStyleGuideColor.Button)
            expect(TestPluginInstance:GetWrappedInstance().BackgroundColor3).to.equal(Color3.new(1, 0, 0))
            MockThemeColor = Color3.new(0, 1, 0)
            MockThemeChangedEvent:Fire()
            expect(TestPluginInstance:GetWrappedInstance().BackgroundColor3).to.equal(Color3.new(0, 1, 0))
        end)

        it("should set modifiers for a Color3.", function()
            TestPluginInstance.BackgroundColor3 = Color3.new(0, 0, 1)
            TestPluginInstance:SetColorModifier("BackgroundColor3", Enum.StudioStyleGuideModifier.Disabled)
            expect(TestPluginInstance:GetWrappedInstance().BackgroundColor3).to.equal(Color3.new(0, 0, 1))
        end)

        it("should set modifiers with a plugin color.", function()
            TestPluginInstance.BackgroundColor3 = Enum.StudioStyleGuideColor.Button
            TestPluginInstance:SetColorModifier("BackgroundColor3", Enum.StudioStyleGuideModifier.Disabled)
            expect(TestPluginInstance:GetWrappedInstance().BackgroundColor3).to.equal(Color3.new(1, 1, 0))
        end)

        it("should set all color modifiers.", function()
            TestPluginInstance.BackgroundColor3 = Enum.StudioStyleGuideColor.Button
            TestPluginInstance:SetAllColorModifiers(Enum.StudioStyleGuideModifier.Disabled)
            expect(TestPluginInstance:GetWrappedInstance().BackgroundColor3).to.equal(Color3.new(1, 1, 0))
        end)
    end)
end