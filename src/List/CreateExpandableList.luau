--Creates an expandable entry list.
--!strict

local Fusion = require(script.Parent.Parent:WaitForChild("Fusion"))
local CreateFusionScope = require(script.Parent.Parent:WaitForChild("CreateFusionScope"))
local NexusVirtualList = require(script.Parent.Parent:WaitForChild("NexusVirtualList"))
local SelectionListEntry = require(script.Parent:WaitForChild("SelectionListEntry"))
local SelectionListEntryFrame = require(script.Parent:WaitForChild("SelectionListEntryFrame"))

return function<T>(Scope: CreateFusionScope.FusionScope, ScrollingFrame: ScrollingFrame, RootEntry: SelectionListEntry.SelectionListEntry<T>, CreateContents: SelectionListEntryFrame.ContentsConstructor<T>): NexusVirtualList.VirtualScrollList<SelectionListEntry.SelectionListEntry<T>>
    --Create the initial list.
    local List = NexusVirtualList.CreateVirtualScrollList(ScrollingFrame, function(InitialIndex: number, InitialEntry: SelectionListEntry.SelectionListEntry<T>)
        return SelectionListEntryFrame.new(Scope, InitialIndex, InitialEntry, CreateContents) :: any
    end)
    List:SetEntryHeight(18)

    --Set the contents of the list.
    --The root entry is ignored to allow it to be a simple container.
    --RootEntry.Scope is used to prevent a parent watching a child scope.
    RootEntry.Scope:Observer(RootEntry.VisibleEntries):onBind(function()
        local CurrentVisibleEntries = Fusion.peek(RootEntry.VisibleEntries)
        local NewEntries = table.create(#CurrentVisibleEntries - 1)
        for i = 2, #CurrentVisibleEntries do
            table.insert(NewEntries, CurrentVisibleEntries[i])
        end
        List:SetData(NewEntries)
    end)

    --Return the list.
    return List
end