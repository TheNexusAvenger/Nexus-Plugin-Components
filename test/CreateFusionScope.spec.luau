--Tests CreateFusionScope.
--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.NexusPluginComponents.Fusion)
local CreateFusionScope = require(ReplicatedStorage.NexusPluginComponents.CreateFusionScope)

return function()
    describe("A FusionScope", function()
        local MockOtherColor, MockThemeChanged = nil, nil
        local TestScope = nil
        beforeEach(function()
            MockOtherColor = 0
            MockThemeChanged = Instance.new("BindableEvent")
            TestScope = CreateFusionScope({
                ThemeChanged = MockThemeChanged.Event,
                Theme = {
                    GetColor = function(_, Color: Enum.StudioStyleGuideColor, Modifier: Enum.StudioStyleGuideModifier?): Color3
                        if Color == Enum.StudioStyleGuideColor.MainText then
                            if not Modifier or Modifier == Enum.StudioStyleGuideModifier.Default then
                                return Color3.fromRGB(255, MockOtherColor, MockOtherColor)
                            elseif Modifier == Enum.StudioStyleGuideModifier.Disabled then
                                return Color3.fromRGB(MockOtherColor, 255, MockOtherColor)
                            end
                        elseif Color == Enum.StudioStyleGuideColor.SubText then
                            return Color3.fromRGB(MockOtherColor, MockOtherColor, 255)
                        end
                        return Color3.fromRGB(0, 0, 0)
                    end,
                },
            } :: any)
        end)

        afterEach(function()
            MockThemeChanged:Destroy()
            TestScope:doCleanup()
        end)

        it("should return plugin colors with no modifiers.", function()
            expect(Fusion.peek(TestScope:PluginColor(Enum.StudioStyleGuideColor.MainText))).to.equal(Color3.fromRGB(255, 0, 0))
            expect(Fusion.peek(TestScope:PluginColor(Enum.StudioStyleGuideColor.SubText))).to.equal(Color3.fromRGB(0, 0, 255))
        end)

        it("should return plugin colors with modifiers.", function()
            expect(Fusion.peek(TestScope:PluginColor(Enum.StudioStyleGuideColor.MainText, Enum.StudioStyleGuideModifier.Default))).to.equal(Color3.fromRGB(255, 0, 0))
            expect(Fusion.peek(TestScope:PluginColor(Enum.StudioStyleGuideColor.MainText, Enum.StudioStyleGuideModifier.Disabled))).to.equal(Color3.fromRGB(0, 255, 0))
        end)

        it("should return plugin colors with values for colors.", function()
            local StudioStyleGuideColor = TestScope:Value(Enum.StudioStyleGuideColor.MainText)
            local PluginColor = TestScope:PluginColor(StudioStyleGuideColor)
            expect(Fusion.peek(PluginColor)).to.equal(Color3.fromRGB(255, 0, 0))
            StudioStyleGuideColor:set(Enum.StudioStyleGuideColor.SubText)
            expect(Fusion.peek(PluginColor)).to.equal(Color3.fromRGB(0, 0, 255))
        end)

        it("should return plugin colors with values for modifiers.", function()
            local StudioStyleGuideModifier = TestScope:Value(Enum.StudioStyleGuideModifier.Default)
            local PluginColor = TestScope:PluginColor(Enum.StudioStyleGuideColor.MainText, StudioStyleGuideModifier)
            expect(Fusion.peek(PluginColor)).to.equal(Color3.fromRGB(255, 0, 0))
            StudioStyleGuideModifier:set(Enum.StudioStyleGuideModifier.Disabled)
            expect(Fusion.peek(PluginColor)).to.equal(Color3.fromRGB(0, 255, 0))
        end)

        it("should update plugin colors with themes.", function()
            local PluginColor = TestScope:PluginColor(Enum.StudioStyleGuideColor.MainText)
            expect(Fusion.peek(PluginColor)).to.equal(Color3.fromRGB(255, 0, 0))
            MockOtherColor = 128
            MockThemeChanged:Fire()
            task.wait()
            expect(Fusion.peek(PluginColor)).to.equal(Color3.fromRGB(255, 128, 128))
        end)

        it("should create instances with default values and colors.", function()
            local TestInstance = TestScope:Create("TextLabel")({
                Text = "Test",
            }) :: TextLabel
            expect(TestInstance.BackgroundTransparency).to.equal(1)
            expect(TestInstance.TextColor3).to.equal(Color3.fromRGB(255, 0, 0))
            expect(TestInstance.Text).to.equal("Test")
        end)

        it("should create instances with override values and colors.", function()
            local TestInstance = TestScope:Create("TextLabel")({
                BackgroundTransparency = 0.5,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Text = "Test",
            }) :: TextLabel
            expect(TestInstance.BackgroundTransparency).to.equal(0.5)
            expect(TestInstance.TextColor3).to.equal(Color3.fromRGB(255, 255, 255))
            expect(TestInstance.Text).to.equal("Test")
        end)
    end)
end