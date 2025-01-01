--State for an entry in a selection list.
--!strict

local Fusion = require(script.Parent.Parent:WaitForChild("Fusion"))
local CreateFusionScope = require(script.Parent.Parent:WaitForChild("CreateFusionScope"))

local SelectionListEntry = {}
SelectionListEntry.__index = SelectionListEntry

export type SelectionListEntry<T> = {
    Destroyed: boolean,
    Scope: CreateFusionScope.FusionScope,
    Data: Fusion.Value<T>,
    Level: Fusion.Value<number>,
    Expanded: Fusion.Value<boolean>,
    Expandable: Fusion.Value<boolean>,
    Selected: Fusion.Value<boolean>,
    Selectable: Fusion.Value<boolean>,
    Parent: Fusion.Value<SelectionListEntry<T>?>,
    Children: Fusion.Value<{SelectionListEntry<T>}>,
    VisibleEntries: Fusion.UsedAs<{SelectionListEntry<T>}>,
} & typeof(setmetatable({}, SelectionListEntry))



--[[
Creates a selection list entry with initial data.
--]]
function SelectionListEntry.new<T>(ParentScope: CreateFusionScope.FusionScope, InitialData: T): SelectionListEntry<T>
    --Create the values.
    local Scope = ParentScope:innerScope() :: CreateFusionScope.FusionScope
    local Data = ParentScope:Value(InitialData)
    local Level = ParentScope:Value(0)
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
        Expanded = Expanded,
        Expandable = Expandable,
        Selected = Selected,
        Selectable = Selectable,
        Parent = Parent,
        Children = Children,
    }, SelectionListEntry) :: SelectionListEntry<T>
    self.VisibleEntries = Scope:Computed(function(use)
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
end



return SelectionListEntry