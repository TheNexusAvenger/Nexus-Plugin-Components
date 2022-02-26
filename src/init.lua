--[[
TheNexusAvenger

Main project for using Nexus Plugin Components.
--]]

local CLASS_NAME_TO_PATH = {
    --Nexus Instance.
    Event = "NexusInstance.Event.NexusEvent",

    --Helper.
    PluginColor = "Base.PluginColor",
    ElementList = "Input.Custom.ElementList",
    SelectionList = "State.SelectionList",

    --Roblox.
    ImageButton = "Input.Roblox.ImageButton",
    TextButton = "Input.Roblox.TextButton",
    TextBox = "Input.Roblox.TextBox",

    --Custom.
    CollapsableListFrame = "Input.Custom.CollapsableListFrame",
}



local NexusProject = require(script:WaitForChild("NexusProject"))
local NexusPluginComponentsProject = NexusProject.new(script)



--[[
Creates an instance of a given class name.
--]]
function NexusPluginComponentsProject.new(ClassName, ...)
    if CLASS_NAME_TO_PATH[ClassName] then
        return NexusPluginComponentsProject:GetResource(CLASS_NAME_TO_PATH[ClassName]).new(...)
    end
    return NexusPluginComponentsProject:GetResource("Base.PluginInstance").new(ClassName)
end



return NexusPluginComponentsProject