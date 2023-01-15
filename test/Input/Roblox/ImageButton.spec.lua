--[[
TheNexusAvenger

Tests the ImageButton class.
--]]
--!strict

local NexusPluginComponentsModule = game.ReplicatedStorage:WaitForChild("NexusPluginComponents")
local NexusPluginComponents = require(NexusPluginComponentsModule)

return function()
    describe("An image button", function()
        it("should become disabled.", function()
            local TestButton = NexusPluginComponents.new("ImageButton")
            expect(TestButton.AutoButtonColor).to.equal(true)
            TestButton.Disabled = true
            expect(TestButton.AutoButtonColor).to.equal(false)
            TestButton.Disabled = false
            expect(TestButton.AutoButtonColor).to.equal(true)
        end)
    end)
end