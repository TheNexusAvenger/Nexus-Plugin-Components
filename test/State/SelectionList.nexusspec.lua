--[[
TheNexusAvenger

Tests the SelectionList class.
--]]

local NexusUnitTesting = require("NexusUnitTesting")

local NexusPluginComponents = require(game.ReplicatedStorage:WaitForChild("NexusPluginComponents"))
local SelectionListTest = NexusUnitTesting.UnitTest:Extend()



--[[
Sets up the test.
--]]
function SelectionListTest:Setup()
    self.CuT = NexusPluginComponents.new("SelectionList")

    --Create the child selection entries.
    self.ChildEntries = {}
    self.ChildEntries[1] = self.CuT:CreateChild()
    self.ChildEntries[2] = self.ChildEntries[1]:CreateChild()
    self.ChildEntries[3] = self.ChildEntries[1]:CreateChild()
    self.ChildEntries[4] = self.CuT:CreateChild()
    self.ChildEntries[5] = self.ChildEntries[4]:CreateChild()
    self.ChildEntries[6] = self.ChildEntries[5]:CreateChild()
end

--[[
Tests the Find method.
--]]
NexusUnitTesting:RegisterUnitTest(SelectionListTest.new("Find"):SetRun(function(self)
    --Test on the created instance.
    self:AssertEquals(self.CuT:Find(self.ChildEntries[1]), 1)
    self:AssertEquals(self.CuT:Find(self.ChildEntries[2]), nil)
    self:AssertEquals(self.CuT:Find(self.ChildEntries[3]), nil)
    self:AssertEquals(self.CuT:Find(self.ChildEntries[4]), 2)
    self:AssertEquals(self.CuT:Find(self.ChildEntries[5]), nil)
    self:AssertEquals(self.CuT:Find(self.ChildEntries[6]), nil)

    --Test on a child.
    self:AssertEquals(self.ChildEntries[1]:Find(self.ChildEntries[1]), nil)
    self:AssertEquals(self.ChildEntries[1]:Find(self.ChildEntries[2]), 1)
    self:AssertEquals(self.ChildEntries[1]:Find(self.ChildEntries[3]), 2)
    self:AssertEquals(self.ChildEntries[1]:Find(self.ChildEntries[4]), nil)
    self:AssertEquals(self.ChildEntries[1]:Find(self.ChildEntries[5]), nil)
    self:AssertEquals(self.ChildEntries[1]:Find(self.ChildEntries[6]), nil)
end))

--[[
Tests the GetDescendants method.
--]]
NexusUnitTesting:RegisterUnitTest(SelectionListTest.new("GetDescendants"):SetRun(function(self)
    --Test with everything expanded.
    self:AssertEquals(self.CuT:GetDescendants(), {
        self.ChildEntries[1],
        self.ChildEntries[2],
        self.ChildEntries[3],
        self.ChildEntries[4],
        self.ChildEntries[5],
        self.ChildEntries[6],
    })

    --Test with the root not expanded.
    self.CuT.Expanded = false
    self:AssertEquals(self.CuT:GetDescendants(), {})

    --Test with a child not expanded.
    self.CuT.Expanded = true
    self.ChildEntries[1].Expanded = false
    self:AssertEquals(self.CuT:GetDescendants(), {
        self.ChildEntries[1],
        self.ChildEntries[4],
        self.ChildEntries[5],
        self.ChildEntries[6],
    })
end))

--[[
Tests the AddChild method.
--]]
NexusUnitTesting:RegisterUnitTest(SelectionListTest.new("AddChild"):SetRun(function(self)
    --Test a new child being added.
    local NewChild = NexusPluginComponents.new("SelectionList")
    self.ChildEntries[1]:AddChild(NewChild)
    self:AssertEquals(self.CuT:GetDescendants(), {
        self.ChildEntries[1],
        self.ChildEntries[2],
        self.ChildEntries[3],
        NewChild,
        self.ChildEntries[4],
        self.ChildEntries[5],
        self.ChildEntries[6],
    })

    --Test adding a duplicate child.
    self.ChildEntries[1]:AddChild(NewChild)
    self:AssertEquals(self.CuT:GetDescendants(), {
        self.ChildEntries[1],
        self.ChildEntries[2],
        self.ChildEntries[3],
        NewChild,
        self.ChildEntries[4],
        self.ChildEntries[5],
        self.ChildEntries[6],
    })
end))

--[[
Tests the AddChild method.
--]]
NexusUnitTesting:RegisterUnitTest(SelectionListTest.new("RemoveChild"):SetRun(function(self)
    --Test adding and removing a child.
    local NewChild = NexusPluginComponents.new("SelectionList")
    self.ChildEntries[1]:AddChild(NewChild)
    self.ChildEntries[1]:RemoveChild(NewChild)
    self:AssertEquals(self.CuT:GetDescendants(), {
        self.ChildEntries[1],
        self.ChildEntries[2],
        self.ChildEntries[3],
        self.ChildEntries[4],
        self.ChildEntries[5],
        self.ChildEntries[6],
    })

    --Test removing a removed child.
    self.ChildEntries[1]:RemoveChild(NewChild)
    self:AssertEquals(self.CuT:GetDescendants(), {
        self.ChildEntries[1],
        self.ChildEntries[2],
        self.ChildEntries[3],
        self.ChildEntries[4],
        self.ChildEntries[5],
        self.ChildEntries[6],
    })
end))

--[[
Tests the SetSelection method.
--]]
NexusUnitTesting:RegisterUnitTest(SelectionListTest.new("SetSelection"):SetRun(function(self)
    --Test setting a new selection.
    self.CuT:SetSelection({self.ChildEntries[1], self.ChildEntries[3]})
    self:AssertEquals(self.CuT:GetSelection(), {self.ChildEntries[1], self.ChildEntries[3]})

    --Test overriding the selection.
    self.CuT:SetSelection({self.ChildEntries[2], self.ChildEntries[3]})
    self:AssertEquals(self.CuT:GetSelection(), {self.ChildEntries[2], self.ChildEntries[3]})

    --Test clearing the selection.
    self.CuT:SetSelection()
    self:AssertEquals(self.CuT:GetSelection(), {})
end))

--[[
Tests the ToggleSelection method.
--]]
NexusUnitTesting:RegisterUnitTest(SelectionListTest.new("ToggleSelection"):SetRun(function(self)
    --Toggle the selection for of entries.
    self.CuT:ToggleSelection(self.ChildEntries[1])
    self:AssertEquals(self.CuT:GetSelection(), {self.ChildEntries[1]})
    self.CuT:ToggleSelection(self.ChildEntries[3])
    self:AssertEquals(self.CuT:GetSelection(), {self.ChildEntries[3]})
    self.CuT:ToggleSelection(self.ChildEntries[3])
    self:AssertEquals(self.CuT:GetSelection(), {})

    --Toggle the selection with control.
    self.CuT.OverrideControlDown = true
    self.CuT:ToggleSelection(self.ChildEntries[1])
    self:AssertEquals(self.CuT:GetSelection(), {self.ChildEntries[1]})
    self.CuT:ToggleSelection(self.ChildEntries[3])
    self:AssertEquals(self.CuT:GetSelection(), {self.ChildEntries[1], self.ChildEntries[3]})
    self.CuT.OverrideControlDown = false

    --Toggle the selection with shift.
    self.CuT.OverrideShiftDown = true
    self.CuT:ToggleSelection(self.ChildEntries[6])
    self:AssertEquals(self.CuT:GetSelection(), {self.ChildEntries[1], self.ChildEntries[3], self.ChildEntries[4], self.ChildEntries[5], self.ChildEntries[6]})
end))



return true