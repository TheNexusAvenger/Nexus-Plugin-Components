--Tests CreateSlider.
--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CreateSlider = require(ReplicatedStorage.NexusPluginComponents.Input.CreateSlider)
local CreateFusionScope = require(ReplicatedStorage.NexusPluginComponents.CreateFusionScope)
local Fusion = require(ReplicatedStorage.NexusPluginComponents.Fusion)

local Children = Fusion.Children

return function()
    describe("A slider", function()
        local TestScope, TestParent = nil, nil
        beforeEach(function()
            TestScope = CreateFusionScope()

            TestParent = TestScope:New("ScreenGui")({
                Parent = ReplicatedStorage,
                [Children] = {
                    TestScope:New("Frame")({
                        Size = UDim2.new(0, 200, 0, 50),
                    })
                },
            }):FindFirstChildOfClass("Frame")
        end)

        afterEach(function()
            TestScope:doCleanup()
        end)

        it("should create the initial slider.", function()
            local SliderValue = TestScope:Value(0)
            local Slider = TestScope:Hydrate(CreateSlider(TestScope, SliderValue))({
                Size = UDim2.new(1, 0, 1, 0),
                Parent = TestParent,
            })
            local SliderButton = Slider:FindFirstChildOfClass("TextButton")
            local _ = Slider.AbsoluteSize
            task.wait()

            expect(SliderButton.AbsolutePosition).to.equal(Vector2.new(0, 0))
            SliderValue:set(0.4)
            expect(SliderButton.AbsolutePosition).to.equal(Vector2.new(math.floor(0.4 * (200 - 8)), 0))
        end)

        it("should use custom ranges.", function()
            local SliderValue = TestScope:Value(40)
            local SliderRange = TestScope:Value(NumberRange.new(0, 100))
            local Slider = TestScope:Hydrate(CreateSlider(TestScope, SliderValue, {
                ValueRange = SliderRange,
            }))({
                Size = UDim2.new(1, 0, 1, 0),
                Parent = TestParent,
            })
            local SliderButton = Slider:FindFirstChildOfClass("TextButton")
            local _ = Slider.AbsoluteSize
            task.wait()

            expect(SliderButton.AbsolutePosition).to.equal(Vector2.new(math.floor((40 / 100) * (200 - 8)), 0))
            SliderRange:set(NumberRange.new(-100, 100))
            expect(SliderButton.AbsolutePosition).to.equal(Vector2.new(math.floor((140 / 200) * (200 - 8)), 0))
        end)

        it("should clamp sliders.", function()
            local SliderValue = TestScope:Value(0)
            local Slider = TestScope:Hydrate(CreateSlider(TestScope, SliderValue))({
                Size = UDim2.new(1, 0, 1, 0),
                Parent = TestParent,
            })
            local SliderButton = Slider:FindFirstChildOfClass("TextButton")
            local _ = Slider.AbsoluteSize
            task.wait()

            expect(SliderButton.AbsolutePosition).to.equal(Vector2.new(0, 0))
            SliderValue:set(2)
            expect(SliderButton.AbsolutePosition).to.equal(Vector2.new(200 - 8, 0))
            SliderValue:set(-1)
            expect(SliderButton.AbsolutePosition).to.equal(Vector2.new(0, 0))
        end)
    end)
end