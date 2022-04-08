--[[
TheNexusAvenger

Tests the Slider class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusPluginComponents = require(game.ReplicatedStorage:WaitForChild("NexusPluginComponents"))
local SliderTest = NexusUnitTesting.UnitTest:Extend()



--[[
Sets up the test.
--]]
function SliderTest:Setup()
    self.CuT = NexusPluginComponents.new("Slider")
    self.CuT:DisableChangeReplication("AbsoluteSize")
    self.CuT.AbsoluteSize = Vector2.new(200, 50)
end

--[[
Tests setting the value properties.
--]]
NexusUnitTesting:RegisterUnitTest(SliderTest.new("Value"):SetRun(function(self)
    --Set the value and assert the slider position changed.
    self.CuT.Value = 0.5
    wait()
    self:AssertEquals(self.CuT.SliderButton.Position, UDim2.new(0, 96, 0, 0))

    --Change the minimum value and assert the slider changes.
    self.CuT.MinimumValue = -1
    wait()
    self:AssertEquals(self.CuT.SliderButton.Position, UDim2.new(0, 144, 0, 0))

    --Change the maximum value and assert the slider changes.
    self.CuT.MaximumValue = 2
    wait()
    self:AssertEquals(self.CuT.SliderButton.Position, UDim2.new(0, 96, 0, 0))

    --Assert that the slider is clamped.
    self.CuT.Value = -2
    wait()
    self:AssertEquals(self.CuT.SliderButton.Position, UDim2.new(0, 0, 0, 0))
    self.CuT.Value = 3
    wait()
    self:AssertEquals(self.CuT.SliderButton.Position, UDim2.new(0, 192, 0, 0))
end))

--[[
Tests the ConnectTextBox method.
--]]
NexusUnitTesting:RegisterUnitTest(SliderTest.new("ConnectTextBox"):SetRun(function(self)
    --Connect the text box.
    local TextBox = NexusPluginComponents.new("TextBox")
    self.CuT:ConnectTextBox(TextBox)
    self:AssertEquals(TextBox.Text, "0")

    --Test changing the value with formatting.
    self.CuT.Value = 0.5
    wait()
    self:AssertEquals(TextBox.Text, "0.5")
    self.CuT.Value = 0.567
    wait()
    self:AssertEquals(TextBox.Text, "0.567")
    self.CuT.Value = 0.56712
    wait()
    self:AssertEquals(TextBox.Text, "0.567")
    self.CuT.Value = -2
    wait()
    self:AssertEquals(TextBox.Text, "-2")
    self.CuT.Value = 2
    wait()
    self:AssertEquals(TextBox.Text, "2")

    --Test the text changing.
    TextBox.Text = "0.6"
    wait()
    self:AssertEquals(self.CuT.Value, 0.6)
    TextBox.Text = "1.25"
    wait()
    self:AssertEquals(self.CuT.Value, 1.25)
    TextBox.Text = "-1.25"
    wait()
    self:AssertEquals(self.CuT.Value, -1.25)

    --Test reverting text.
    TextBox.Text = "NotANumber"
    wait()
    self:AssertEquals(self.CuT.Value, -1.25)
    self:AssertEquals(TextBox.Text, "-1.25")
end))



return true