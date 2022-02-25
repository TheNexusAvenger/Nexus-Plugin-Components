--[[
TheNexusAvenger

Manages the state of a collapsable list.
--]]

local NexusPluginComponents = require(script.Parent.Parent)

local NexusInstance = NexusPluginComponents:GetResource("NexusInstance.NexusInstance")
local UserInputService = NexusPluginComponents:GetResource("Input.Service.UserInputService")

local SelectionList = NexusInstance:Extend()
SelectionList:SetClassName("SelectionList")



--[[
Creates the Selection List.
--]]
function SelectionList:__new()
    self:InitializeSuper()

    self.Selected = false
    self.Expanded = true
    self.Children = {}
end

--[[
Returns the index of a child.
--]]
function SelectionList:Find(Child)
    for i, OtherChild in pairs(self.Children) do
        if Child == OtherChild then
            return i
        end
    end
end

--[[
Creates a child entry.
--]]
function SelectionList:CreateChild()
    local Child = SelectionList.new()
    Child.Indent = (self.Indent or 0) + 1
    table.insert(self.Children, Child)
    return Child
end

--[[
Adds an existing child entry.
--]]
function SelectionList:AddChild(Child)
    --Return if the child exists.
    if self:Find(Child) then
        return
    end

    --Add the child.
    table.insert(self.Children, Child)
end

--[[
Removes a child entry.
--]]
function SelectionList:RemoveChild(Child)
    --Get the index of the child and return if the child does not exist.
    local Index = self:Find(Child)
    if not Index then
        return
    end

    --Remove the child.
    table.remove(self.Children, Index)
end

--[[
Returns the descendants of the selection list.
--]]
function SelectionList:GetDescendants(IncludeNotExpanded)
    --Return an empty list is it isn't expanded.
    if self.Expanded == false and IncludeNotExpanded ~= true then
        return {}
    end

    --Get and return the descendants.
    local Descendants = {}
    for _, Child in pairs(self.Children) do
        table.insert(Descendants, Child)
        for _, SubChild in pairs(Child:GetDescendants()) do
            table.insert(Descendants, SubChild)
        end
    end
    return Descendants
end

--[[
Gets the selected entries.
--]]
function SelectionList:GetSelection()
    local SelectedEntries = {}
    for _, Entry in pairs(self:GetDescendants(true)) do
        if Entry.Selected then
            table.insert(SelectedEntries, Entry)
        end
    end
    return SelectedEntries
end

--[[
Sets the selected entries.
--]]
function SelectionList:SetSelection(Selection)
    --Create a lookup for the selection.
    Selection = Selection or {}
    local SelectionLookup = {}
    for _, Entry in pairs(Selection) do
        SelectionLookup[Entry] = true
    end

    --Unselect the selected frames.
    for _, Entry in pairs(self:GetSelection()) do
        if not SelectionLookup[Entry] then
            Entry.Selected = false
        end
    end

    --Select the new entries.
    for _, Entry in pairs(Selection) do
        Entry.Selected = true
    end
end

--[[
Toggles an entry being selected.
--]]
function SelectionList:ToggleSelection(Entry)
    --Determine the inputs.
    local ControlDown = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
    local ShiftDown = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
    if self.OverrideControlDown ~= nil then ControlDown = self.OverrideControlDown end
    if self.OverrideShiftDown ~= nil then ShiftDown = self.OverrideShiftDown end

    --Update the selection.
    if ShiftDown and self.LastToggledSelection then
        --Determine the indexes.
        local Entries = self:GetDescendants()
        local StartIndex, EndIndex = nil, nil
        for i, OtherEntry in pairs(Entries) do
            if Entry == OtherEntry then
                StartIndex = i
            end
            if self.LastToggledSelection == OtherEntry then
                EndIndex = i
            end
        end

        --Toggle the entry if a range can't be determined.
        if not StartIndex or not EndIndex or StartIndex == EndIndex then
            Entry.Selected = not Entry.Selected
            return
        end

        --Flip the indexes if needed.
        if StartIndex > EndIndex then
            StartIndex, EndIndex = EndIndex, StartIndex
        end

        --Set the selections
        for i = StartIndex, EndIndex do
            Entries[i].Selected = true
        end
    else
        --Set the selection.
        self.LastToggledSelection = Entry
        if ControlDown then
            Entry.Selected = not Entry.Selected
        else
            self:SetSelection(Entry.Selected and {} or {Entry})
        end
    end
end



return SelectionList