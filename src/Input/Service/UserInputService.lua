--[[
TheNexusAvenger

Service for managing user input. The UserInputService directly does
not work with key inputs in plugin windows.
--]]
--!strict

local INPUT_DELAY_TIME = 0.05


local NexusPluginComponents = script.Parent.Parent.Parent
local NexusObject = require(NexusPluginComponents:WaitForChild("NexusInstance"):WaitForChild("NexusObject"))
local NexusEvent = require(NexusPluginComponents:WaitForChild("NexusInstance"):WaitForChild("Event"):WaitForChild("NexusEvent"))

local WrappedUserInputService = NexusObject:Extend()
WrappedUserInputService:SetClassName("WrappedUserInputService")

export type PluginUserInputService = {
    new: () -> (PluginUserInputService),
    Extend: (self: PluginUserInputService) -> (PluginUserInputService),

    InputBegan: NexusEvent.NexusEvent<InputObject, boolean>,
    InputChanged: NexusEvent.NexusEvent<InputObject, boolean>,
    InputEnded: NexusEvent.NexusEvent<InputObject, boolean>,
    IsKeyDown: (self: PluginUserInputService, KeyCode: Enum.KeyCode) -> (boolean)
} & NexusObject.NexusObject



--[[
Creates the User Input Service wrapper.
--]]
function WrappedUserInputService:__new()
    NexusObject.__new(self)

    --Set up the context events.
    self.ContextEvents = {}

    --Create the time checkers.
    self.LastInputBeganTimes = {}
    self.LastInputChangedTimes = {}
    self.LastInputEndedTimes = {}

    --Create the events.
    self.InputBegan = NexusEvent.new()
    self.InputChanged = NexusEvent.new()
    self.InputEnded = NexusEvent.new()

    --Connect the events.
    self:AddContext(game:GetService("UserInputService"))
    pcall(function()
        local PluginGuiService = game:GetService("PluginGuiService")
        PluginGuiService.DescendantAdded:Connect(function(Frame)
            if Frame:IsA("GuiObject") then
                self:AddContext(Frame)
            end
        end)
        PluginGuiService.DescendantRemoving:Connect(function(Frame)
            if Frame:IsA("GuiObject") then
                self:AddContext(Frame)
            end
        end)
    end)
end

--[[
Invoked when an input is began.
--]]
function WrappedUserInputService:OnInputBegan(InputObject: InputObject, Processed: boolean): ()
    --Fire the event if it new.
    local LastTime = self.LastInputBeganTimes[InputObject.KeyCode] or 0
    local CurrentTime = tick()
    if CurrentTime - LastTime >= INPUT_DELAY_TIME then
        self.InputBegan:Fire(InputObject, Processed)
    end

    --Store the last time.
    self.LastInputBeganTimes[InputObject.KeyCode] = CurrentTime
end

--[[
Invoked when an input is changed.
--]]
function WrappedUserInputService:OnInputChanged(InputObject: InputObject, Processed: boolean): ()
    --Fire the event if it new.
    local LastTime = self.LastInputChangedTimes[InputObject.KeyCode] or 0
    local CurrentTime = tick()
    if CurrentTime - LastTime >= INPUT_DELAY_TIME then
        self.InputChanged:Fire(InputObject, Processed)
    end

    --Store the last time.
    self.LastInputChangedTimes[InputObject.KeyCode] = CurrentTime
end

--[[
Invoked when an input is ended.
--]]
function WrappedUserInputService:OnInputEnded(InputObject: InputObject, Processed: boolean): ()
    --Fire the event if it new.
    local LastTime = self.LastInputEndedTimes[InputObject.KeyCode] or 0
    local CurrentTime = tick()
    if CurrentTime - LastTime >= INPUT_DELAY_TIME then
        self.InputEnded:Fire(InputObject, Processed)
    end

    --Store the last time.
    self.LastInputEndedTimes[InputObject.KeyCode] = CurrentTime
end

--[[
Returns if a key is down.
--]]
function WrappedUserInputService:IsKeyDown(KeyCode: Enum.KeyCode): boolean
    --Return false if the key was not pressed.
    local LastTimeDown = self.LastInputBeganTimes[KeyCode]
    if not LastTimeDown then return false end

    --Return if the ended time is more recent.
    local LastTimeUp = self.LastInputEndedTimes[KeyCode] or 0
    return LastTimeUp < LastTimeDown
end

--[[
Adds a context for getting inputs.
--]]
function WrappedUserInputService:AddContext(Frame: Frame): ()
    --Return if the events already exist.
    if self.ContextEvents[Frame] then return end

    --Connect the events.
    local Events = {}
    table.insert(Events, Frame.InputBegan:Connect(function(InputObject, Processed)
        self:OnInputBegan(InputObject,Processed)
    end))
    table.insert(Events, Frame.InputChanged:Connect(function(InputObject, Processed)
        self:OnInputChanged(InputObject,Processed)
    end))
    table.insert(Events, Frame.InputEnded:Connect(function(InputObject, Processed)
        self:OnInputEnded(InputObject,Processed)
    end))

    --Store the events.
    self.ContextEvents[Frame] = Events
end

--[[
Removes a context for getting inputs.
--]]
function WrappedUserInputService:RemoveContext(Frame: Frame): ()
    --Disconnect the events.
    local Events = self.ContextEvents[Frame]
    if not Events then return end
    self.ContextEvents[Frame] = nil
    for _, Event in Events do
        Event:Disconnect()
    end
    self.ContextEvents[Frame] = nil
end



return WrappedUserInputService.new() :: PluginUserInputService