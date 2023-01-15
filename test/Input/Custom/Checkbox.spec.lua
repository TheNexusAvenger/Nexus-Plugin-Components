--[[
TheNexusAvenger

Tests the Checkbox class.
--]]
--!strict

local NexusPluginComponentsModule = game.ReplicatedStorage:WaitForChild("NexusPluginComponents")
local NexusPluginComponents = require(NexusPluginComponentsModule)

return function()
    local TestCheckBox = nil
    beforeEach(function()
        TestCheckBox = NexusPluginComponents.new("Checkbox")
    end)

    describe("An text button", function()
        it("should change the text based on the value.", function()
            --Assert that the checked text is valid.
            TestCheckBox.Value = "Checked"
            expect(TestCheckBox.Text).to.equal("✓")

            --Assert that the unchecked text is valid.
            TestCheckBox.Value = "Unchecked"
            expect(TestCheckBox.Text).to.equal("")

            --Assert that the mixed text is valid.
            TestCheckBox.Value = "Mixed"
            expect(TestCheckBox.Text).to.equal("◼")
        end)

        it("should toggle values.", function()
            --Assert toggling from the Checked stated leads to the Unchecked state.
            TestCheckBox.Value = "Checked"
            TestCheckBox:Toggle()
            expect(TestCheckBox.Value).to.equal("Unchecked")
            expect(TestCheckBox.Text).to.equal("")

            --Assert toggling from the Unchecked stated leads to the Checked state.
            TestCheckBox.Value = "Unchecked"
            TestCheckBox:Toggle()
            expect(TestCheckBox.Value).to.equal("Checked")
            expect(TestCheckBox.Text).to.equal("✓")

            --Assert toggling from the Mixed stated leads to the Unchecked state.
            TestCheckBox.Value = "Mixed"
            TestCheckBox:Toggle()
            expect(TestCheckBox.Value).to.equal("Unchecked")
            expect(TestCheckBox.Text).to.equal("")
        end)
    end)
end