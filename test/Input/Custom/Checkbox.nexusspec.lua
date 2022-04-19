--[[
TheNexusAvenger

Tests the Checkbox class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusPluginComponents = require(game.ReplicatedStorage:WaitForChild("NexusPluginComponents"))
local CheckboxTest = NexusUnitTesting.UnitTest:Extend()



--[[
Sets up the test.
--]]
function CheckboxTest:Setup()
    self.CuT = NexusPluginComponents.new("Checkbox")
end

--[[
Tests setting the Value property.
--]]
NexusUnitTesting:RegisterUnitTest(CheckboxTest.new("Value"):SetRun(function(self)
    --Assert that the checked text is valid.
    self.CuT.Value = "Checked"
    wait()
    self:AssertEquals(self.CuT.Text, "✓")

    --Assert that the unchecked text is valid.
    self.CuT.Value = "Unchecked"
    wait()
    self:AssertEquals(self.CuT.Text, "")

    --Assert that the mixed text is valid.
    self.CuT.Value = "Mixed"
    wait()
    self:AssertEquals(self.CuT.Text, "◼")
end))

--[[
Tests setting the Toggle method.
--]]
NexusUnitTesting:RegisterUnitTest(CheckboxTest.new("Toggle"):SetRun(function(self)
    --Assert toggling from the Checked stated leads to the Unchecked state.
    self.CuT.Value = "Checked"
    self.CuT:Toggle()
    wait()
    self:AssertEquals(self.CuT.Value, "Unchecked")
    self:AssertEquals(self.CuT.Text, "")

    --Assert toggling from the Unchecked stated leads to the Checked state.
    self.CuT.Value = "Unchecked"
    self.CuT:Toggle()
    wait()
    self:AssertEquals(self.CuT.Value, "Checked")
    self:AssertEquals(self.CuT.Text, "✓")

    --Assert toggling from the Mixed stated leads to the Unchecked state.
    self.CuT.Value = "Mixed"
    self.CuT:Toggle()
    wait()
    self:AssertEquals(self.CuT.Value, "Unchecked")
    self:AssertEquals(self.CuT.Text, "")
end))



return true