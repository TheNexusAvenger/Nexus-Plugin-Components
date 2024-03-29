--[[
TheNexusAvenger

List frame that can be expanded and collapsed.
Intended to be used with ElementList and SelectionList.
--]]
--!strict

local DOUBLE_CLICK_MAX_TIME = 0.5
local EXPANDED_ARROW_IMAGE = "rbxasset://textures/StudioToolbox/ArrowDownIconWhite.png"
local COLLAPSED_ARROW_IMAGE = "rbxasset://textures/ui/LuaApp/icons/ic-arrow-right.png"
local ARROW_RELATIVE_SIZE = (10 / 20) * (54 / 38)



local NexusPluginComponents = script.Parent.Parent.Parent
local PluginInstance = require(NexusPluginComponents:WaitForChild("Base"):WaitForChild("PluginInstance"))
local NexusEvent = require(NexusPluginComponents:WaitForChild("NexusInstance"):WaitForChild("Event"):WaitForChild("NexusEvent"))

local CollapsableListFrame = PluginInstance:Extend()
CollapsableListFrame:SetClassName("CollapsableListFrame")

export type CollapsableListFrame = {
    new: () -> (CollapsableListFrame),
    Extend: (self: CollapsableListFrame) -> (CollapsableListFrame),

    DoubleClicked: NexusEvent.NexusEvent<>,
    DelayClicked: NexusEvent.NexusEvent<>,
    ArrowVisible: boolean,
    CurrentOffset: Vector2,
    Update: (self: CollapsableListFrame, Data: any) -> (),
} & PluginInstance.PluginInstance & Frame



--[[
Creates the collapsable list frame.
--]]
function CollapsableListFrame:__new(): ()
    PluginInstance.__new(self, "Frame")

    --Craete the events.
    self:DisableChangeReplication("DoubleClicked")
    self:DisableChangeReplication("DelayClicked")
    self.DoubleClicked = NexusEvent.new()
    self.DelayClicked = NexusEvent.new()

    --Stop the properties from replicating.
    self:DisableChangeReplication("ArrowVisible")
    self:DisableChangeReplication("ArrowVisible")
    self:DisableChangeReplication("Hovering")
    self:DisableChangeReplication("Arrow")
    self:DisableChangeReplication("AdornFrame")
    self:DisableChangeReplication("ElementList")
    self:DisableChangeReplication("SelectionList")
    self:DisableChangeReplication("SelectionListEntry")
    self:DisableChangeReplication("UpdateElementList")

    --Create the frames.
    self.BackgroundColor3 = Enum.StudioStyleGuideColor.TableItem
    local Arrow = PluginInstance.new("ImageButton")
    Arrow.Name = "Arrow"
    Arrow.BackgroundTransparency = 1
    Arrow.SizeConstraint = "RelativeYY"
    Arrow.AnchorPoint = Vector2.new(0.5, 0.5)
    Arrow.ImageColor3 = Color3.new(151/255, 151/255, 151/255)
    Arrow.Parent = self
    self.Arrow = Arrow

    local Container = PluginInstance.new("Frame")
    Container.BackgroundTransparency = 1
    Container.Name = "Container"
    Container.Size = UDim2.new(1, 0, 1, 0)
    Container.Position = UDim2.new(1, 0, 0, 0)
    Container.AnchorPoint = Vector2.new(1, 0)
    Container.Parent = self
    self.AdornFrame = Container

    --Set the initial properties.
    self.BackgroundTransparency = 1
    self.ArrowVisible = true
    self.Hovering = false
    self:GetPropertyChangedSignal("ArrowVisible"):Connect(function()
        self:UpdateArrow()
    end)

    --Connect toggling expanding.
    local DB = true
    Arrow.MouseButton1Down:Connect(function()
        if DB then
            DB = false
            if self.SelectionListEntry then
                --Toggle the expand property.
                self.SelectionListEntry.Expanded = not self.SelectionListEntry.Expanded

                --Update the entries.
                if self.ElementList and self.SelectionList then
                    if self.UpdateElementList then
                        self.UpdateElementList()
                    else
                        self.ElementList:SetEntries(self.SelectionList:GetDescendants())
                    end
                end
            end
            task.wait()
            DB = true
        end
    end)

    --Connect hovering.
    self.MouseEnter:Connect(function()
        self.Hovering = true
        self:UpdateColors()
    end)
    self.MouseLeave:Connect(function()
        self.Hovering = false
        self:UpdateColors()
    end)

    --Set up selecting.
    local LastClickTime = 0
    self.InputBegan:Connect(function(Input, Processed)
        if Processed then return end
        if DB and Input.UserInputType == Enum.UserInputType.MouseButton1 then
            DB = false
            local List = self.SelectionList
            local Entry = self.SelectionListEntry
            if Entry and Entry.Selectable then
                if Entry.Selected then
                    --Handle double clicking and delayed clicking.
                    if LastClickTime ~= nil then
                        if tick() - LastClickTime < DOUBLE_CLICK_MAX_TIME then
                            self.DoubleClicked:Fire()
                        else
                            self.DelayClicked:Fire()
                        end
                        LastClickTime = nil :: any
                    else
                        LastClickTime = tick()
                    end
                elseif List then
                    --Toggle the selection.
                    List:ToggleSelection(Entry)
                    if self.ElementList then
                        if self.UpdateElementList then
                            self.UpdateElementList()
                        else
                            self.ElementList:SetEntries(List:GetDescendants())
                        end
                    end
                    LastClickTime = tick()
                end
            end
            task.wait()
            DB = true
        end
    end)

    --Update the size.
    self:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        self:UpdateSize()
    end)
    self:UpdateSize()
    self:UpdateArrow()
end

--[[
Updates the colors of the container.
--]]
function CollapsableListFrame:UpdateColors(): ()
    local Entry = self.SelectionListEntry
    if not Entry or not Entry.Selectable or (not Entry.Selected and not self.Hovering) then
        self.BackgroundTransparency = 1
    else
        self.BackgroundTransparency = 0
        self:SetColorModifier("BackgroundColor3", (Entry.Selected and Enum.StudioStyleGuideModifier.Selected) or (self.Hovering and Enum.StudioStyleGuideModifier.Hover) or Enum.StudioStyleGuideModifier.Default)
    end
end

--[[
Updates the size of the frame.
--]]
function CollapsableListFrame:UpdateSize(): ()
    local SizeY = self.AbsoluteSize.Y
    local ArrowSize = SizeY * ARROW_RELATIVE_SIZE
    local Indent = (self.SelectionListEntry and self.SelectionListEntry.Indent and self.SelectionListEntry.Indent - 1 or 0)
    self.Arrow.Size = UDim2.new(0, ArrowSize, 0, ArrowSize)
    self.Arrow.Position = UDim2.new(0, (Indent * SizeY) + (SizeY / 2), 0, SizeY / 2)
    self.AdornFrame.Size = UDim2.new(1, -SizeY - (Indent * SizeY), 1, 0)
end

--[[
Updates the arrow.
--]]
function CollapsableListFrame:UpdateArrow(): ()
    local Entry = self.SelectionListEntry
    self.Arrow.Visible = self.ArrowVisible and (Entry and #Entry.Children > 0)
    self.Arrow.Image = ((Entry and Entry.Expanded) and EXPANDED_ARROW_IMAGE or COLLAPSED_ARROW_IMAGE)
end

--[[
Updates the list.
--]]
function CollapsableListFrame:Update(Data: any): ()
    --Hide the frame if there is no data.
    self.SelectionListEntry = Data
    self.Visible = (Data ~= nil)
    if not Data then
        return
    end

    --Update the size and arrow.
    self:UpdateSize()
    self:UpdateArrow()
    self:UpdateColors()
end



return (CollapsableListFrame :: any) :: CollapsableListFrame