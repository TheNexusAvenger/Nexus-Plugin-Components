--State for an entry in a selection list.
--!strict

local Fusion = require(script.Parent.Parent:WaitForChild("Packages"):WaitForChild("Fusion"))
local CreateFusionScope = require(script.Parent.Parent:WaitForChild("CreateFusionScope"))

local SelectionListEntry = {}
SelectionListEntry.__index = SelectionListEntry

export type SelectionListEntry<T> = {
    Destroyed: boolean,
    Scope: CreateFusionScope.FusionScope,
    Data: Fusion.Value<T>,
    Level: Fusion.Value<number>,
    Visible: Fusion.Value<boolean>,
    Expanded: Fusion.Value<boolean>,
    Expandable: Fusion.Value<boolean>,
    Selected: Fusion.Value<boolean>,
    Selectable: Fusion.Value<boolean>,
    Parent: Fusion.Value<SelectionListEntry<T>?>,
    Children: Fusion.Value<{SelectionListEntry<T>}>,
    VisibleEntries: Fusion.UsedAs<{SelectionListEntry<T>}>,
    Descendants: Fusion.UsedAs<{SelectionListEntry<T>}>,
    LastSelection: SelectionListEntry<T>?,
    SortChildrenFunction: ((SelectionListEntry<T>, SelectionListEntry<T>) -> (boolean))?,
} & typeof(setmetatable({}, SelectionListEntry))



--[[
Creates a selection list entry with initial data.
--]]
function SelectionListEntry.new<T>(ParentScope: CreateFusionScope.FusionScope, InitialData: T, SortChildrenFunction: ((SelectionListEntry<T>, SelectionListEntry<T>) -> (boolean))?): SelectionListEntry<T>
    --Create the values.
    local Scope = ParentScope:innerScope() :: CreateFusionScope.FusionScope
    local Data = ParentScope:Value(InitialData)
    local Level = ParentScope:Value(0)
    local Visible = ParentScope:Value(true)
    local Expanded = ParentScope:Value(true)
    local Expandable = ParentScope:Value(true)
    local Selected = ParentScope:Value(false)
    local Selectable = ParentScope:Value(true)
    local Parent = ParentScope:Value(nil :: SelectionListEntry<T>?)
    local Children = ParentScope:Value({})

    --Update the levels of children when the level changes.
    Scope:Observer(Level):onChange(function()
        local ChildLevel = Fusion.peek(Level) + 1
        for _, Child in Fusion.peek(Children) :: {SelectionListEntry<T>} do
            Child.Level:set(ChildLevel)
        end
    end)

    --Deselect the frame if it becomes unselectable.
    Scope:Observer(Selectable):onChange(function()
        if Fusion.peek(Selectable) then return end
        Selected:set(false)
    end)

    --Create the object.
    local self = setmetatable({
        Destroyed = false,
        Scope = Scope,
        Data = Data,
        Level = Level,
        Visible = Visible,
        Expanded = Expanded,
        Expandable = Expandable,
        Selected = Selected,
        Selectable = Selectable,
        Parent = Parent,
        Children = Children,
        SortChildrenFunction = SortChildrenFunction,
    }, SelectionListEntry) :: SelectionListEntry<T>
    self.VisibleEntries = Scope:Computed(function(use)
        if not use(Visible) then return {} end
        local Entries = {self}
        if use(Expanded) then
            for _, Child in use(Children) :: {SelectionListEntry<T>} do
                local ChildVisibleEntries = use(Child.VisibleEntries)
                for _, Entry in ChildVisibleEntries do
                    table.insert(Entries, Entry)
                end
            end
        end
        return Entries
    end)
    self.Descendants = Scope:Computed(function(use)
        local Entries = {self}
        for _, Child in use(Children) :: {SelectionListEntry<T>} do
            local ChildDescendants = use(Child.Descendants)
            for _, Entry in ChildDescendants do
                table.insert(Entries, Entry)
            end
        end
        return Entries
    end)

    --Create and return the object.
    return self
end

--[[
Sets the data stored in the entry.
--]]
function SelectionListEntry.SetData<T>(self: SelectionListEntry<T>, Data: T): ()
    self.Data:set(Data)
end

--[[
Adds a child list entry.
--]]
function SelectionListEntry.AddChild<T>(self: SelectionListEntry<T>, Child: SelectionListEntry<T>): ()
    --Return if the child already exists.
    local CurrentChildren = Fusion.peek(self.Children)
    if table.find(CurrentChildren, Child) then return end

    --Add the child.
    local ChildParent = Fusion.peek(Child.Parent)
    if ChildParent then
        ChildParent:RemoveChild(Child)
    end
    table.insert(CurrentChildren, Child)
    if self.SortChildrenFunction then
        table.sort(CurrentChildren, self.SortChildrenFunction)
    end
    self.Children:set(CurrentChildren)
    Child.Parent:set(self)
    Child.Level:set(Fusion.peek(self.Level) + 1)
end

--[[
Removes a child list entry.
--]]
function SelectionListEntry.RemoveChild<T>(self: SelectionListEntry<T>, Child: SelectionListEntry<T>): ()
    --Return if the doesn't exist.
    local CurrentChildren = Fusion.peek(self.Children)
    local ChildIndex = table.find(CurrentChildren, Child)
    if not ChildIndex then return end

    --Remove the child.
    table.remove(CurrentChildren, ChildIndex)
    self.Children:set(CurrentChildren)
    Child.Parent:set(nil)
    Child.Level:set(0)
end

--[[
Sorts the child entries.
This is only needed if child data is updated. New child elements will be sorted.
No action is taken if no sort function is in use.
--]]
function SelectionListEntry.SortChildren<T>(self: SelectionListEntry<T>): ()
    if not self.SortChildrenFunction then return end
    local CurrentChildren = Fusion.peek(self.Children)
    table.sort(CurrentChildren, self.SortChildrenFunction)
    self.Children:set(CurrentChildren)
end

--[[
Toggles the selection of the entry.
--]]
function SelectionListEntry.ToggleSelection<T>(self: SelectionListEntry<T>, ControlDown: boolean?, ShiftDown: boolean?): ()
    if not Fusion.peek(self.Selectable) then return end

    --Get the root selection entry.
    local RootListEntry = self
    while true do
        local NewRootListEntry = Fusion.peek(RootListEntry.Parent)
        if not NewRootListEntry then break end
        RootListEntry = NewRootListEntry
    end

    --Add the visible entries inbetween if shift is down.
    if ShiftDown and RootListEntry.LastSelection then
        --Determine the indices to select.
        local VisibleEntries = Fusion.peek(RootListEntry.VisibleEntries)
        local LastIndex, CurrentIndex = table.find(VisibleEntries, RootListEntry.LastSelection), table.find(VisibleEntries, self)
        if not LastIndex or not CurrentIndex then return end
        if LastIndex > CurrentIndex then
            LastIndex, CurrentIndex = CurrentIndex, LastIndex
        end

        --Select the frames in-between.
        --This logic is 100% correct. Ideally, shift-presses should unselect if done again.
        for i = LastIndex, CurrentIndex do
            local CurrentEntry = VisibleEntries[i]
            if not Fusion.peek(CurrentEntry.Selectable) then continue end
            CurrentEntry.Selected:set(true)
        end
    elseif ControlDown then
        --Add the frame to the selection if control is down.
        self.Selected:set(true)
        RootListEntry.LastSelection = self
    else
        --Unselect all other frames and set the selection of this frame.
        for _, Entry in Fusion.peek(RootListEntry.Descendants) do
            Entry.Selected:set(Entry == self)
        end
        RootListEntry.LastSelection = self
    end
end

--[[
Destroys the selection list entry.
--]]
function SelectionListEntry.Destroy<T>(self: SelectionListEntry<T>): ()
    --Remove the child from the parent.
    local CurrentParent = Fusion.peek(self.Parent)
    if CurrentParent then
        CurrentParent:RemoveChild(self)
    end

    --Destroy the children.
    local CurrentChildren = Fusion.peek(self.Children) :: {SelectionListEntry<T>}
    for i = #CurrentChildren, 1, -1 do
        CurrentChildren[i]:Destroy()
    end

    --Clean up the scope.
    if self.Destroyed then return end
    self.Destroyed = true
    self.Scope:doCleanup()
    self.LastSelection = nil
end



return SelectionListEntry