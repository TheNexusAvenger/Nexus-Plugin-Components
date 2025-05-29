--Tests CreateCheckbox.
--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CreateCheckbox = require(ReplicatedStorage.Packages.NexusPluginComponents.Input.CreateCheckbox)
local CreateFusionScope = require(ReplicatedStorage.Packages.NexusPluginComponents.CreateFusionScope)

return function()
    describe("A checkbox", function()
        local TestScope, TestValue, TestCheckbox = nil, nil, nil
        beforeEach(function()
            TestScope = CreateFusionScope()
            TestValue = TestScope:Value("Checked" :: CreateCheckbox.CheckboxState)
            TestCheckbox = CreateCheckbox(TestScope, TestValue :: any)
        end)

        afterEach(function()
            TestScope:doCleanup()
        end)
        
        it("should show correct values.", function()
            expect(TestCheckbox.Text).to.equal("✓")
            TestValue:set("Mixed")
            expect(TestCheckbox.Text).to.equal("◼")
            TestValue:set("Unchecked")
            expect(TestCheckbox.Text).to.equal("")
        end)
    end)
end