--Tests CreatePluginToggleButton.
--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CreatePluginToggleButton = require(ReplicatedStorage.Packages.NexusPluginComponents.Input.Plugin.CreatePluginToggleButton)

return function()
    describe("A PluginToggleButton", function()
        local MockSetActive, MockButton = nil, nil
        local TestGui = nil
        beforeEach(function()
            MockSetActive = Instance.new("BindableEvent")
            MockButton = {
                Active = false,
                Click = MockSetActive.Event,
                SetActive = function(self, Active)
                    self.Active = Active
                end,
            } :: any
            TestGui = Instance.new("ScreenGui")
        end)

        afterEach(function()
            MockSetActive:Destroy()
            TestGui:Destroy()
        end)

        it("should set the button as active by default.", function()
            TestGui.Enabled = true
            expect(CreatePluginToggleButton(MockButton, TestGui)).to.equal(MockButton)
            expect(MockButton.Active).to.equal(true)
        end)

        it("should set the button as active when the button is toggled.", function()
            TestGui.Enabled = false
            expect(CreatePluginToggleButton(MockButton, TestGui)).to.equal(MockButton)
            expect(MockButton.Active).to.equal(false)
        
            TestGui.Enabled = true
            task.wait()
            expect(MockButton.Active).to.equal(true)
        end)
    end)
end