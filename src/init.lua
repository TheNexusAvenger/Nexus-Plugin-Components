--[[
TheNexusAvenger

Main project for using Nexus Plugin Components.
--]]
--!strict

local NexusEvent = require(script:WaitForChild("NexusInstance"):WaitForChild("Event"):WaitForChild("NexusEvent"))
local PluginColor = require(script:WaitForChild("Base"):WaitForChild("PluginColor"))
local PluginInstance = require(script:WaitForChild("Base"):WaitForChild("PluginInstance"))
local SelectionList = require(script:WaitForChild("State"):WaitForChild("SelectionList"))

local NexusPluginComponents = {}
NexusPluginComponents.ClassNameToPath = {
    --Nexus Instance.
    Event = NexusEvent,

    --Helper.
    PluginColor = PluginColor,
    SelectionList = SelectionList,
}

export type Event<T...> = NexusEvent.NexusEvent<T...>
export type PluginColor = PluginColor.PluginColor
export type PluginInstance = PluginInstance.PluginInstance
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