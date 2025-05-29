--Main module for Nexus Plugin Components.
--!strict

local CreatePluginToggleButton = require(script:WaitForChild("Input"):WaitForChild("Plugin"):WaitForChild("CreatePluginToggleButton"))
local CreateCheckbox = require(script:WaitForChild("Input"):WaitForChild("CreateCheckbox"))
local CreateSlider = require(script:WaitForChild("Input"):WaitForChild("CreateSlider"))
local CreateExpandableList = require(script:WaitForChild("List"):WaitForChild("CreateExpandableList"))
local SelectionListEntry = require(script:WaitForChild("List"):WaitForChild("SelectionListEntry"))
local SelectionListEntryFrame = require(script:WaitForChild("List"):WaitForChild("SelectionListEntryFrame"))
local Fusion = require(script:WaitForChild("Packages"):WaitForChild("Fusion"))
local NexusVirtualList = require(script:WaitForChild("Packages"):WaitForChild("NexusVirtualList"))
local CreateFusionScope = require(script:WaitForChild("CreateFusionScope"))

local NexusPluginComponents = {
    Input = {
        Plugin = {
            CreatePluginToggleButton = CreatePluginToggleButton,
        },
        CreateCheckbox = CreateCheckbox,
        CreateSlider = CreateSlider,
    },
    List = {
        CreateExpandableList = CreateExpandableList,
        SelectionListEntry = SelectionListEntry,
        SelectionListEntryFrame = SelectionListEntryFrame,
    },
    Fusion = Fusion,
    NexusVirtualList = NexusVirtualList,
    CreateFusionScope = CreateFusionScope,
}

export type CheckboxState = CreateCheckbox.CheckboxState
export type SliderOptions = CreateSlider.Options
export type SelectionListEntry<T> = SelectionListEntry.SelectionListEntry<T>
export type SelectionListEntryFrameContentsConstructor<T> = SelectionListEntryFrame.ContentsConstructor<T>
export type SelectionListEntryFrame<T> = SelectionListEntryFrame.SelectionListEntryFrame<T>
export type FusionScope = CreateFusionScope.FusionScope

export type Animatable = Fusion.Animatable
export type UsedAs<T> = Fusion.UsedAs<T>
export type Child = Fusion.Child
export type Computed<T> = Fusion.Computed<T>
export type Contextual<T> = Fusion.Contextual<T>
export type GraphObject = Fusion.GraphObject
export type For<KO, VO> = Fusion.For<KO, VO>
export type Observer = Fusion.Observer
export type PropertyTable = Fusion.PropertyTable
export type Scope<Constructors > = Fusion.Scope<Constructors >
export type ScopedObject = Fusion.SpecialKey
export type Spring<T> = Fusion.Spring<T>
export type StateObject<T> = Fusion.StateObject<T>
export type Task = Fusion.Task
export type Tween<T> = Fusion.Tween<T>
export type Use = Fusion.Use
export type Value<T, S = T> = Fusion.Value<T, S >
export type Version = Fusion.Version

export type ListEntry<T> = NexusVirtualList.ListEntry<T>
export type ListEntryConstructor<T> = NexusVirtualList.ListEntryConstructor<T>
export type VirtualScrollList<T> = NexusVirtualList.VirtualScrollList<T>
export type AutoScrollingVirtualScrollList<T> = NexusVirtualList.AutoScrollingVirtualScrollList<T>

return NexusPluginComponents