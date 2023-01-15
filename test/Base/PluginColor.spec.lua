--[[
TheNexusAvenger

Tests the PluginColor class.
--]]
--!strict

local NexusPluginComponentsModule = game.ReplicatedStorage:WaitForChild("NexusPluginComponents")
local NexusPluginComponents = require(NexusPluginComponentsModule)
local PluginColor = require(NexusPluginComponentsModule:WaitForChild("Base"):WaitForChild("PluginColor"))

return function()
    describe("Plugin colors", function()
        it("should return the correct colors.", function()
            --Set the mock settings.
            PluginColor.Settings = {
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
                            return Color3.new()
                        end
                    }
                }
            }

            --Test the colors.
            expect(NexusPluginComponents.new("PluginColor", "Button"):GetColor()).to.equal(Color3.new(1, 0, 0))
            expect(NexusPluginComponents.new("PluginColor", Enum.StudioStyleGuideColor.Button):GetColor()).to.equal(Color3.new(1, 0, 0))
            expect(NexusPluginComponents.new("PluginColor", Enum.StudioStyleGuideColor.Button, "Disabled"):GetColor()).to.equal(Color3.new(0, 1, 0))
            expect(NexusPluginComponents.new("PluginColor", Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Disabled):GetColor()).to.equal(Color3.new(0, 1, 0))
        end)
    end)
end