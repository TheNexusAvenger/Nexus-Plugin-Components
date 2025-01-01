# Lists
Lists use a combination of [Fusion](https://elttob.uk/Fusion/) for managinge values
and [Nexus Virtual List](https://github.com/TheNexusAvenger/Nexus-Virtual-List) for
efficently displaying them.

## List Entries
In order to display the list, the contents of the list must be created using
`SelectionListEntry`. It is strongly recommended that the type of data stored
is consistent between **all** entries, since the frames in the list can display
any entry and be changed to display any other frame.

A root `SelectionListEntry` is required for statement management, but won't be
presented.

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CreateFusionScope = require(ReplicatedStorage:WaitForChild("NexusPluginComponents"):WaitForChild("CreateFusionScope"))
local SelectionListEntry = require(ReplicatedStorage:WaitForChild("NexusPluginComponents"):WaitForChild("List"):WaitForChild("SelectionListEntry"))

export type EntryData = { --Can be any data, including non-tables.
    Text: string,
    Color: Color3,
}

local Root = SelectionListEntry.new(Scope, {Text = "", Color = Color.fromRGB(0, 0, 0)}) --This root entry will not be displayed.
local Child1 = SelectionListEntry.new(Scope, {Text = "Entry1", Color = Color.fromRGB(0, 255, 0)})
local Child2 = SelectionListEntry.new(Scope, {Text = "Entry2", Color = Color.fromRGB(0, 0, 255)})
local Child3 = SelectionListEntry.new(Scope, {Text = "Entry3", Color = Color.fromRGB(0, 255, 0)})
local Child4 = SelectionListEntry.new(Scope, {Text = "Entry4", Color = Color.fromRGB(0, 0, 255)})

--AddChild will create the list. Any entry can contain multiple sub-entries.
--RemoveChild can be called to remove child entries. Destroy will also clear them.
Root:AddChild(Child1)
Child1:AddChild(Child2)
Root:AddChild(Child3)
Child3:AddChild(Child4)

--Optional setup.
Child1.Expandable:set(false) --Hides the expand button for the row.
Child1.Expanded:set(false) --Collapses the row.
Child1.Selectable:set(false) --Prevents the row from being selected.
```

## List
With the entries created, a `ScrollingFrame` needs to be creatted and used with
`CreateExpandableList`.

```luau
... --Previous section.

local CreateExpandableList = require(ReplicatedStorage:WaitForChild("NexusPluginComponents"):WaitForChild("List"):WaitForChild("CreateExpandableList"))

--Create the ScrollingFrame.
--Note: Create will add defaults for plugins, New (from Fusion) will not.
local ScrollingFrame = Scope:Create("ScrollingFrame")({
    Size = UDim2.new(0, 400, 0, 600),
    Parent = ...,
    --CanvasSize is handled by NexusVirtualList. It does not need to be set here.
}) :: ScrollingFrame

--Create the list. It has 4 parameters:
--1. Scope - The Fusion scope used to create instances.
--2. ScrollingFrame - The ScrollingFrame instance to control.
--3. RootEntry - The root SelectionListEntry to show.
--4. ContentsConstructor - Creates the display for the frame. This provides:
--   a. The scope for creating frames
--   b. Fusion value for the contents to display (will change while scrolling)
--   c. An Event for the row being double-clicked
local VirtualList = CreateExpandableList(Scope, ScrollingFrame, Root, function(Scope: CreateFusionScope.FusionScope, Entry: SelectionListEntry.SelectionListEntry<EntryData>, DoubleClicked: RBXScriptSignal)
    --Do something with the row when double clicked.
    --This event is cleared when the row is destroyed, so the connection does not need to be stored.
    DoubleClicked:Connect(function()
        print(`{Fusion.peek(Fusion.peek(Entry).Data).Text} was double clicked!`)
    end)

    --Create the display text.
    --Can be any set of instances.
    return {
        Scope:Create("TextLabel")({
            Size = UDim2.new(1, 0, 1, 0),
            Text = Scope:Computed(function(use)
                return use(use(Entry).Data).Text
            end),
            TextTextColor3 = Scope:Computed(function(use)
                return use(use(Entry).Data).Color
            end),
            TextXAlignment = Enum.TextXAlignment.Left,
        })
    }
end)

--Optionally, call VirtualList::SetScrollWidth or VirtualList::SetEntryHeight. See Nexus Virutal List for more.
```