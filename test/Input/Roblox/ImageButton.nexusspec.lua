--[[
TheNexusAvenger

Tests the ImageButton class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusPluginComponents = require(game.ReplicatedStorage:WaitForChild("NexusPluginComponents"))
local ImageButtonTest = NexusUnitTesting.UnitTest:Extend()



--[[
Sets up the test.
--]]
function ImageButtonTest:Setup()
    self.CuT = NexusPluginComponents.new("ImageButton")
end

--[[
Tests the Disabled property.
--]]
NexusUnitTesting:RegisterUnitTest(ImageButtonTest.new("Disabled"):SetRun(function(self)
    self:AssertTrue(self.CuT.AutoButtonColor)
    self.CuT.Disabled = true
    self:AssertFalse(self.CuT.AutoButtonColor)
    self.CuT.Disabled = false
    self:AssertTrue(self.CuT.AutoButtonColor)
end))



return true