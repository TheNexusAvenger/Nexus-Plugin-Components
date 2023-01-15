--[[
TheNexusAvenger

Tests the SelectionList class.
--]]
--!strict
--$NexusUnitTestExtensions

local NexusPluginComponentsModule = game.ReplicatedStorage:WaitForChild("NexusPluginComponents")
local NexusPluginComponents = require(NexusPluginComponentsModule)

return function()
    local TestChildEntries, TestSelectionList = nil, nil
    beforeEach(function()
        TestSelectionList = NexusPluginComponents.new("SelectionList")

        --Create the child selection entries.
        TestChildEntries = {}
        TestChildEntries[1] = TestSelectionList:CreateChild()
        TestChildEntries[2] = TestChildEntries[1]:CreateChild()
        TestChildEntries[3] = TestChildEntries[1]:CreateChild()
        TestChildEntries[4] = TestSelectionList:CreateChild()
        TestChildEntries[5] = TestChildEntries[4]:CreateChild()
        TestChildEntries[6] = TestChildEntries[5]:CreateChild()
    end)

    describe("A selection list.", function()
        it("should find child entries.", function()
            --Test on the created instance.
            expect(TestSelectionList:Find(TestChildEntries[1])).to.equal(1)
            expect(TestSelectionList:Find(TestChildEntries[2])).to.equal(nil)
            expect(TestSelectionList:Find(TestChildEntries[3])).to.equal(nil)
            expect(TestSelectionList:Find(TestChildEntries[4])).to.equal(2)
            expect(TestSelectionList:Find(TestChildEntries[5])).to.equal(nil)
            expect(TestSelectionList:Find(TestChildEntries[6])).to.equal(nil)

            --Test on a child.
            expect(TestChildEntries[1]:Find(TestChildEntries[1])).to.equal(nil)
            expect(TestChildEntries[1]:Find(TestChildEntries[2])).to.equal(1)
            expect(TestChildEntries[1]:Find(TestChildEntries[3])).to.equal(2)
            expect(TestChildEntries[1]:Find(TestChildEntries[4])).to.equal(nil)
            expect(TestChildEntries[1]:Find(TestChildEntries[5])).to.equal(nil)
            expect(TestChildEntries[1]:Find(TestChildEntries[6])).to.equal(nil)
        end)

        it("should get descendants.", function()
            --Test with everything expanded.
            expect(TestSelectionList:GetDescendants()).to.deepEqual({
                TestChildEntries[1],
                TestChildEntries[2],
                TestChildEntries[3],
                TestChildEntries[4],
                TestChildEntries[5],
                TestChildEntries[6],
            })

            --Test with the root not expanded.
            TestSelectionList.Expanded = false
            expect(TestSelectionList:GetDescendants()).to.deepEqual({})

            --Test with a child not expanded.
            TestSelectionList.Expanded = true
            TestChildEntries[1].Expanded = false
            expect(TestSelectionList:GetDescendants()).to.deepEqual({
                TestChildEntries[1],
                TestChildEntries[4],
                TestChildEntries[5],
                TestChildEntries[6],
            })
        end)

        it("should add child entries.", function()
            --Test a new child being added.
            local NewChild = NexusPluginComponents.new("SelectionList")
            TestChildEntries[1]:AddChild(NewChild)
            expect(TestSelectionList:GetDescendants()).to.deepEqual({
                TestChildEntries[1],
                TestChildEntries[2],
                TestChildEntries[3],
                NewChild,
                TestChildEntries[4],
                TestChildEntries[5],
                TestChildEntries[6],
            })

            --Test adding a duplicate child.
            TestChildEntries[1]:AddChild(NewChild)
            expect(TestSelectionList:GetDescendants()).to.deepEqual({
                TestChildEntries[1],
                TestChildEntries[2],
                TestChildEntries[3],
                NewChild,
                TestChildEntries[4],
                TestChildEntries[5],
                TestChildEntries[6],
            })
        end)

        it("should remove child entries.", function()
            --Test adding and removing a child.
            local NewChild = NexusPluginComponents.new("SelectionList")
            TestChildEntries[1]:AddChild(NewChild)
            TestChildEntries[1]:RemoveChild(NewChild)
            expect(TestSelectionList:GetDescendants()).to.deepEqual({
                TestChildEntries[1],
                TestChildEntries[2],
                TestChildEntries[3],
                TestChildEntries[4],
                TestChildEntries[5],
                TestChildEntries[6],
            })

            --Test removing a removed child.
            TestChildEntries[1]:RemoveChild(NewChild)
            expect(TestSelectionList:GetDescendants()).to.deepEqual({
                TestChildEntries[1],
                TestChildEntries[2],
                TestChildEntries[3],
                TestChildEntries[4],
                TestChildEntries[5],
                TestChildEntries[6],
            })
        end)

        it("should set the selection.", function()
            --Test setting a new selection.
            TestSelectionList:SetSelection({TestChildEntries[1], TestChildEntries[3]})
            expect(TestSelectionList:GetSelection()).to.deepEqual({TestChildEntries[1], TestChildEntries[3]})

            --Test overriding the selection.
            TestSelectionList:SetSelection({TestChildEntries[2], TestChildEntries[3]})
            expect(TestSelectionList:GetSelection()).to.deepEqual({TestChildEntries[2], TestChildEntries[3]})

            --Test clearing the selection.
            TestSelectionList:SetSelection()
            expect(TestSelectionList:GetSelection()).to.deepEqual({})
        end)

        it("should toggle the selection.", function()
            --Toggle the selection for of entries.
            TestSelectionList:ToggleSelection(TestChildEntries[1])
            expect(TestSelectionList:GetSelection()).to.deepEqual({TestChildEntries[1]})
            TestSelectionList:ToggleSelection(TestChildEntries[3])
            expect(TestSelectionList:GetSelection()).to.deepEqual({TestChildEntries[3]})
            TestSelectionList:ToggleSelection(TestChildEntries[3])
            expect(TestSelectionList:GetSelection()).to.deepEqual({})

            --Toggle the selection with control.
            TestSelectionList.OverrideControlDown = true
            TestSelectionList:ToggleSelection(TestChildEntries[1])
            expect(TestSelectionList:GetSelection()).to.deepEqual({TestChildEntries[1]})
            TestSelectionList:ToggleSelection(TestChildEntries[3])
            expect(TestSelectionList:GetSelection()).to.deepEqual({TestChildEntries[1], TestChildEntries[3]})
            TestSelectionList.OverrideControlDown = false

            --Toggle the selection with shift.
            TestSelectionList.OverrideShiftDown = true
            TestSelectionList:ToggleSelection(TestChildEntries[6])
            expect(TestSelectionList:GetSelection()).to.deepEqual({TestChildEntries[1], TestChildEntries[3], TestChildEntries[4], TestChildEntries[5], TestChildEntries[6]})
        end)
    end)
end