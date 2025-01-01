--[[
TheNexusAvenger

Main project for using Nexus Plugin Components.
--]]
--!strict

local SelectionList = require(script:WaitForChild("State"):WaitForChild("SelectionList"))

local NexusPluginComponents = {}
NexusPluginComponents.ClassNameToPath = {
    --Helper.
    SelectionList = SelectionList,
}

export type SelectionList = SelectionList.SelectionList



--[[
Creates an instance of a given class name.
--]]
function NexusPluginComponents.new(ClassName: string, ...: any): any
    if NexusPluginComponents.ClassNameToPath[ClassName] then
        return NexusPluginComponents.ClassNameToPath[ClassName].new(...)
    end
    return nil
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