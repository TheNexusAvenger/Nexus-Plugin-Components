--[[
TheNexusAvenger

Tests the ElementList class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusPluginComponents = require(game.ReplicatedStorage:WaitForChild("NexusPluginComponents"))
local ElementListTest = NexusUnitTesting.UnitTest:Extend()



--[[
Sets up the test.
--]]
function ElementListTest:Setup()
    --Create the entry class.
    local TestClass = NexusPluginComponents:GetResource("Base.PluginInstance"):Extend()
    function TestClass:__new()
        self:InitializeSuper("TextLabel")
    end
    function TestClass:Update(Data)
        self.Text = tostring(Data)
    end

    --Create the component under test.
    self.CuT = NexusPluginComponents.new("ElementList", TestClass)
    self.CuT.Size = UDim2.new(0, 100, 0, 30)
    self.CuT:SetEntries({
        "Test 1",
        "Test 2",
        "Test 3",
        "Test 4",
        "Test 5",
    })
    wait()
end

--[[
Tests the CurrentOffset property.
--]]
NexusUnitTesting:RegisterUnitTest(ElementListTest.new("CurrentOffset"):SetRun(function(self)
    --Check the adorn.
    self:AssertEquals(self.CuT.AdornFrame.Position, UDim2.new(0, 0, 0, 0))
    self:AssertEquals(self.CuT.AdornFrame:GetChildren()[1].Text, "Test 1")
    self:AssertEquals(self.CuT.AdornFrame:GetChildren()[2].Text, "Test 2")

    --Move the offset and check that it updated.
    self.CuT.CurrentOffset = Vector2.new(0, 30)
    wait()
    self:AssertEquals(self.CuT.AdornFrame.Position, UDim2.new(0, 0, 0, -14))
    self:AssertEquals(self.CuT.AdornFrame:GetChildren()[1].Text, "Test 2")
    self:AssertEquals(self.CuT.AdornFrame:GetChildren()[2].Text, "Test 3")
end))

--[[
Tests updating the entries.
--]]
NexusUnitTesting:RegisterUnitTest(ElementListTest.new("SetEntries"):SetRun(function(self)
    self.CuT:SetEntries({
        "Test 7",
        "Test 8",
        "Test 9",
    })
    self:AssertEquals(self.CuT.AdornFrame:GetChildren()[1].Text, "Test 7")
    self:AssertEquals(self.CuT.AdornFrame:GetChildren()[2].Text, "Test 8")
end))



return true