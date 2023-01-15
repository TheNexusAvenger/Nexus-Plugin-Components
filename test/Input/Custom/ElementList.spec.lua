--[[
TheNexusAvenger

Tests the ElementList class.
--]]
--!strict

local NexusPluginComponentsModule = game.ReplicatedStorage:WaitForChild("NexusPluginComponents")
local NexusPluginComponents = require(NexusPluginComponentsModule)

return function()
    local TestElementList = nil
    beforeEach(function()
        --Create the entry class.
        local PluginInstance = NexusPluginComponents:GetResource("Base.PluginInstance")
        local TestClass = PluginInstance:Extend()
        function TestClass:__new()
            PluginInstance.__new(self, "TextButton")
        end
        function TestClass:Update(Data)
            self.Text = tostring(Data)
        end

        --Create the test list.
        TestElementList = NexusPluginComponents.new("ElementList", TestClass)
        TestElementList.Size = UDim2.new(0, 100, 0, 30)
        TestElementList:SetEntries({
            "Test 1",
            "Test 2",
            "Test 3",
            "Test 4",
            "Test 5",
        })
        task.wait()
    end)

    describe("An element list", function()
        it("should update the offset.", function()
            --Check the adorn.
            expect(TestElementList.AdornFrame.Position).to.equal(UDim2.new(0, 0, 0, 0))
            expect(TestElementList.AdornFrame:GetChildren()[1].Text).to.equal("Test 1")
            expect(TestElementList.AdornFrame:GetChildren()[2].Text).to.equal("Test 2")

            --Move the offset and check that it updated.
            TestElementList.CurrentOffset = Vector2.new(0, 30)
            task.wait()
            expect(TestElementList.AdornFrame.Position).to.equal(UDim2.new(0, 0, 0, -14))
            expect(TestElementList.AdornFrame:GetChildren()[1].Text).to.equal("Test 2")
            expect(TestElementList.AdornFrame:GetChildren()[2].Text).to.equal("Test 3")
        end)

        it("should set new entries.", function()
            TestElementList:SetEntries({
                "Test 7",
                "Test 8",
                "Test 9",
            })
            expect(TestElementList.AdornFrame:GetChildren()[1].Text).to.equal("Test 7")
            expect(TestElementList.AdornFrame:GetChildren()[2].Text).to.equal("Test 8")
        end)
    end)
end