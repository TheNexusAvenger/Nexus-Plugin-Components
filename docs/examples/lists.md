# Lists
Lists are more complicated to handle compared to Nexus Plugin Framework
in order to mitigate [performance issues with bigger inputs](https://twitter.com/TheNexusAvenger/status/1497663514906869772).
Compared to Nexus Plugin Framework, there are 4 components to consider:
- `ScrollingFrame` - Existing Roblox instance type for scrolling through lists.
- `ElementList` - Renders the visible elements of the list.
- List Element - Class that displays an entry of the list. Should extend `PluginInstance` or `CollapsableListFrame`.
- (Optional) `SelectionList` - Manages the state of expanded/collapsed lists with selections. The list element class should extend `CollapsableListFrame`, but is not required.

## Simple Lists
```lua
local NexusPluginComponents = require(game.ReplicatedStorage:WaitForChild("NexusPluginComponents"))

--Create the entry class.
--It doesn't have to extend PluginInstance, but it is simpler to use it.
local EntryClass = NexusPluginComponents:GetResource("Base.PluginInstance"):Extend()

function EntryClass:__new()
    self:InitializeSuper("TextLabel") --Sets up the PluginInstance to create a TextLabel. Any contents can be used.
end

function EntryClass:Update(Data)
    --Data will be nil if there is nothing to show or the entry to show.
    --For this example, strings are used, but they can be anything desired.
    self.Text = Data or ""
end

--Create the scrolling frame.
local ScreenGui = NexusPluginComponents.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer and game.Players.LocalPlayer:FindFirstChild("PlayerGui") or game.StarterGui

local ScrollingFrame = NexusPluginComponents.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(0, 200, 0, 200)
ScrollingFrame.Parent = ScreenGui

--Create the element list.
local ElementList = NexusPluginComponents.new("ElementList", EntryClass) --The second parameter must be the class to use, or a function that creates the class.
ElementList.EntryHeight = 17 --Makes each row 17 pixels tall.
ElementList:ConnectScrollingFrame(ScrollingFrame) --Binds the ElementList to the ScrollingFrame.

--Show the demo entries.
local Entries = {}
for i = 1, 100 do
    table.insert(Entries, "Test "..tostring(i))
end
ElementList:SetEntries(Entries)
```

## Nested Lists
For nested lists, it is recommended to use `SelectionList` and `CollapsableListFrame`
as helpers.
```lua
local NexusPluginComponents = require(game.ReplicatedStorage:WaitForChild("NexusPluginComponents"))

--Create the entry class. CollapsableListFrame is recommended.
local EntryClass = NexusPluginComponents:GetResource("Input.Custom.CollapsableListFrame"):Extend()

function EntryClass:__new()
    self:InitializeSuper()

    self:DisableChangeReplication("TextLabel") --Required so the added TextLabel property is not set in the wrapped instance of CollapsableListFrame.
    self.TextLabel = NexusPluginComponents.new("TextLabel")
    self.TextLabel.Size = UDim2.new(1, 0, 1, 0)
    self.TextLabel.Parent = self.AdornFrame
end

function EntryClass:Update(Data)
    self.super:Update(Data) --Required for CollapsableListFrame to update the arrow and selection color.
    self.TextLabel.Text = Data and Data.Text or ""
end

--Create the scrolling frame.
local ScreenGui = NexusPluginComponents.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer and game.Players.LocalPlayer:FindFirstChild("PlayerGui") or game.StarterGui

local ScrollingFrame = NexusPluginComponents.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(0, 200, 0, 200)
ScrollingFrame.Parent = ScreenGui

--Create the element list.
local SelectionList = NexusPluginComponents.new("SelectionList")
local ElementList = NexusPluginComponents.new("ElementList", function()
    local Entry = EntryClass.new()
    Entry.SelectionList = SelectionList --Setting this helps set up automatic handling of expanding/collapsing entries and selections.
    return Entry
end)
ElementList.EntryHeight = 17 --Makes each row 17 pixels tall.
ElementList:ConnectScrollingFrame(ScrollingFrame) --Binds the ElementList to the ScrollingFrame.

--Show the demo entries.
for i = 1, 100 do
    local Child = SelectionList:CreateChild()
    Child.Text = "Test "..tostring(i)
    for j = 1, 10 do
        local SubChild = Child:CreateChild()
        SubChild.Text = "Sub Test "..tostring(j)
    end
end
ElementList:SetEntries(SelectionList:GetDescendants()) --When changing an entry (such as running CreateChild or editting a property), this must be re-ran to apply the changes. It will not automatically listen for changes.
```