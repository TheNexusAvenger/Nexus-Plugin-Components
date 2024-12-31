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
                        if Color == Enum.StudioStyleGuideColor.MainText or Color == Enum.StudioStyleGuideColor.ButtonText then
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

        it("should create instances with enum-only colors.", function()
            local TestInstance = TestScope:Create("TextLabel")({
                TextColor3 = Enum.StudioStyleGuideColor.SubText,
            }) :: TextLabel
            expect(TestInstance.TextColor3).to.equal(Color3.fromRGB(0, 0, 255))
        end)

        it("should create instances with disabled colors.", function()
            local Enabled = TestScope:Value(true)
            local TestInstance = TestScope:Create("TextButton", Enabled)({
                BackgroundColor3 = Enum.StudioStyleGuideColor.MainText,
            }) :: TextButton
            expect(TestInstance.BackgroundColor3).to.equal(Color3.fromRGB(255, 0, 0))
            expect(TestInstance.TextColor3).to.equal(Color3.fromRGB(255, 0, 0))
            expect(TestInstance.AutoButtonColor).to.equal(true)

            Enabled:set(false)
            expect(TestInstance.BackgroundColor3).to.equal(Color3.fromRGB(0, 255, 0))
            expect(TestInstance.TextColor3).to.equal(Color3.fromRGB(0, 255, 0))
            expect(TestInstance.AutoButtonColor).to.equal(false)
        end)

        it("should create property values.", function()
            local Part = Instance.new("Part")
            Part.Name = "TestName"

            local Value = TestScope:ValueFromProperty(Part, "Name")
            expect(Fusion.peek(Value)).to.equal("TestName")
        end)

        it("should change property values when the value changes.", function()
            local Part = Instance.new("Part")
            Part.Name = "TestName1"

            local Value = TestScope:ValueFromProperty(Part, "Name")
            expect(Fusion.peek(Value)).to.equal("TestName1")
            Part.Name = "TestName2"
            task.wait()
            expect(Fusion.peek(Value)).to.equal("TestName2")
        end)

        it("should change property values when the instance changes.", function()
            local Part1 = Instance.new("Part")
            Part1.Name = "TestName1"
            local Part2 = Instance.new("Part")
            Part2.Name = "TestName2"

            local InstanceValue = TestScope:Value(Part1)
            local Value = TestScope:ValueFromProperty(InstanceValue, "Name")
            expect(Fusion.peek(Value)).to.equal("TestName1")
            InstanceValue:set(Part2)
            expect(Fusion.peek(Value)).to.equal("TestName2")
            Part1.Name = "TestName0"
            task.wait()
            expect(Fusion.peek(Value)).to.equal("TestName2")
            Part2.Name = "TestName3"
            task.wait()
            expect(Fusion.peek(Value)).to.equal("TestName3")
        end)

        it("should create empty property values with nil instances.", function()
            local InstanceValue = TestScope:Value(nil)
            local Value = TestScope:ValueFromProperty(InstanceValue, "Name")
            expect(Fusion.peek(Value)).to.equal(nil)
        end)

        it("should set empty property values with removed instances.", function()
            local Part = Instance.new("Part")
            Part.Name = "TestName"

            local InstanceValue = TestScope:Value(Part)
            local Value = TestScope:ValueFromProperty(InstanceValue, "Name")
            expect(Fusion.peek(Value)).to.equal("TestName")
            InstanceValue:set(nil)
            expect(Fusion.peek(Value)).to.equal(nil)
        end)
    end)
end