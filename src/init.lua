--[[
TheNexusAvenger

Main project for using Nexus Plugin Components.
--]]
--!strict

local NexusEvent = require(script:WaitForChild("NexusInstance"):WaitForChild("Event"):WaitForChild("NexusEvent"))
local PluginColor = require(script:WaitForChild("Base"):WaitForChild("PluginColor"))
local PluginInstance = require(script:WaitForChild("Base"):WaitForChild("PluginInstance"))
local Checkbox = require(script:WaitForChild("Input"):WaitForChild("Custom"):WaitForChild("Checkbox"))
local CollapsableListFrame = require(script:WaitForChild("Input"):WaitForChild("Custom"):WaitForChild("CollapsableListFrame"))
local ElementList = require(script:WaitForChild("Input"):WaitForChild("Custom"):WaitForChild("ElementList"))
local PluginToggleButton = require(script:WaitForChild("Input"):WaitForChild("Custom"):WaitForChild("PluginToggleButton"))
local Slider = require(script:WaitForChild("Input"):WaitForChild("Custom"):WaitForChild("Slider"))
local ImageButton = require(script:WaitForChild("Input"):WaitForChild("Roblox"):WaitForChild("ImageButton"))
local TextButton = require(script:WaitForChild("Input"):WaitForChild("Roblox"):WaitForChild("TextButton"))
local TextBox = require(script:WaitForChild("Input"):WaitForChild("Roblox"):WaitForChild("TextBox"))
local UserInputService = require(script:WaitForChild("Input"):WaitForChild("Service"):WaitForChild("UserInputService"))
local SelectionList = require(script:WaitForChild("State"):WaitForChild("SelectionList"))

local NexusPluginComponents = {}
NexusPluginComponents.ClassNameToPath = {
    --Nexus Instance.
    Event = NexusEvent,

    --Helper.
    PluginColor = PluginColor,
    ElementList = ElementList,
    SelectionList = SelectionList,

    --Roblox.
    ImageButton = ImageButton,
    TextButton = TextButton,
    TextBox = TextBox,

    --Custom.
    Checkbox = Checkbox,
    CollapsableListFrame = CollapsableListFrame,
    PluginToggleButton = PluginToggleButton,
    Slider = Slider,
}

export type Event<T...> = NexusEvent.NexusEvent<T...>
export type PluginColor = PluginColor.PluginColor
export type PluginInstance = PluginInstance.PluginInstance
export type Checkbox = Checkbox.Checkbox
export type CollapsableListFrame = CollapsableListFrame.CollapsableListFrame
export type ElementList = ElementList.ElementList
export type PluginToggleButton = PluginToggleButton.PluginToggleButton
export type Slider = Slider.Slider
export type ImageButton = ImageButton.PluginImageButton
export type TextButton = TextButton.PluginTextButton
export type TextBox = TextBox.PluginTextBox
export type UserInputService = UserInputService.PluginUserInputService
export type SelectionList = SelectionList.SelectionList



--[[
Creates an instance of a given class name.
--]]
function NexusPluginComponents.new(ClassName: string, ...: any): any
    if NexusPluginComponents.ClassNameToPath[ClassName] then
        return NexusPluginComponents.ClassNameToPath[ClassName].new(...)
    end
    return PluginInstance.new(ClassName)
end

--[[
Returns a resource for a path.
Legacy from Nexus Project.
--]]
function NexusPluginComponents:GetResource(Path: string): any
    local ModuleScript = script
    for _, PathPart in string.split(Path, ".") do
        ModuleScript = (ModuleScript :: any)[PathPart]
    end
    return require(ModuleScript :: ModuleScript) :: any
end



return NexusPluginComponents