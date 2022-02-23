--[[
TheNexusAvenger

Tests the TextButton class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusPluginComponents = require(game.ReplicatedStorage:WaitForChild("NexusPluginComponents"))
local TextButtonTest = NexusUnitTesting.UnitTest:Extend()



--[[
Sets up the test.
--]]
function TextButtonTest:Setup()
    self.CuT = NexusPluginComponents.new("TextButton")
end

--[[
Tests the Disabled property.
--]]
NexusUnitTesting:RegisterUnitTest(TextButtonTest.new("Disabled"):SetRun(function(self)
    self:AssertTrue(self.CuT.AutoButtonColor)
    self.CuT.Disabled = true
    self:AssertFalse(self.CuT.AutoButtonColor)
    self.CuT.Disabled = false
    self:AssertTrue(self.CuT.AutoButtonColor)
end))



return true