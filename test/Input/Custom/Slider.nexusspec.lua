--[[
TheNexusAvenger

Tests the Slider class.
--]]
--!strict

local NexusPluginComponentsModule = game.ReplicatedStorage:WaitForChild("NexusPluginComponents")
local NexusPluginComponents = require(NexusPluginComponentsModule)

return function()
    local TestSlider = nil
    beforeEach(function()
        TestSlider = NexusPluginComponents.new("Slider")
        TestSlider:DisableChangeReplication("AbsoluteSize")
        TestSlider.AbsoluteSize = Vector2.new(200, 50)
    end)

    describe("An slider", function()
        it("should update the position from the value.", function()
            --Set the value and assert the slider position changed.
            TestSlider.Value = 0.5
            task.wait()
            expect(TestSlider.SliderButton.Position).to.equal(UDim2.new(0, 96, 0, 0))

            --Change the minimum value and assert the slider changes.
            TestSlider.MinimumValue = -1
            task.wait()
            expect(TestSlider.SliderButton.Position).to.equal(UDim2.new(0, 144, 0, 0))

            --Change the maximum value and assert the slider changes.
            TestSlider.MaximumValue = 2
            task.wait()
            expect(TestSlider.SliderButton.Position).to.equal(UDim2.new(0, 96, 0, 0))

            --Assert that the slider is clamped.
            TestSlider.Value = -2
            task.wait()
            expect(TestSlider.SliderButton.Position).to.equal(UDim2.new(0, 0, 0, 0))
            TestSlider.Value = 3
            task.wait()
            expect(TestSlider.SliderButton.Position).to.equal(UDim2.new(0, 192, 0, 0))
        end)

        it("should connect TextBoxes.", function()
            --Connect the text box.
            local TextBox = NexusPluginComponents.new("TextBox")
            TestSlider:ConnectTextBox(TextBox)
            expect(TextBox.Text).to.equal("0")

            --Test changing the value with formatting.
            TestSlider.Value = 0.5
            task.wait()
            expect(TextBox.Text).to.equal("0.5")
            TestSlider.Value = 0.567
            task.wait()
            expect(TextBox.Text).to.equal("0.567")
            TestSlider.Value = 0.56712
            task.wait()
            expect(TextBox.Text).to.equal("0.567")
            TestSlider.Value = -2
            task.wait()
            expect(TextBox.Text).to.equal("-2")
            TestSlider.Value = 2
            task.wait()
            expect(TextBox.Text).to.equal("2")

            --Test the text changing.
            TextBox.Text = "0.6"
            task.wait()
            expect(TestSlider.Value).to.equal(0.6)
            TextBox.Text = "1.25"
            task.wait()
            expect(TestSlider.Value).to.equal(1.25)
            TextBox.Text = "-1.25"
            task.wait()
            expect(TestSlider.Value).to.equal(-1.25)

            --Test reverting text.
            TextBox.Text = "NotANumber"
            task.wait()
            expect(TestSlider.Value).to.equal(-1.25)
            expect(TextBox.Text).to.equal("-1.25")
        end)
    end)
end