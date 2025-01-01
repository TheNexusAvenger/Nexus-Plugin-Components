--Selection list frame entry frame. Intended to be used with Nexus Virtual List.
--!strict

local EXPANDED_ARROW_IMAGE = "rbxasset://textures/DeveloperFramework/button_arrow_down.png"
local COLLAPSED_ARROW_IMAGE = "rbxasset://textures/DeveloperFramework/button_arrow_right.png"
local DOUBLE_CLICK_MAX_SECONDS = 0.5

local Fusion = require(script.Parent.Parent:WaitForChild("Fusion"))
local CreateFusionScope = require(script.Parent.Parent:WaitForChild("CreateFusionScope"))
local SelectionListEntry = require(script.Parent:WaitForChild("SelectionListEntry"))

local Children = Fusion.Children
local OnEvent = Fusion.OnEvent
local Out = Fusion.Out

local SelectionListEntryFrame = {}
SelectionListEntryFrame.__index = SelectionListEntryFrame

export type ContentsConstructor<T> = (Scope: CreateFusionScope.FusionScope, Entry: Fusion.Value<SelectionListEntry.SelectionListEntry<T>>, DoubleClickEvent: RBXScriptSignal) -> ({Instance})
export type SelectionListEntryFrame<T> = {
    GuiInstance: Frame,
    Entry: Fusion.Value<SelectionListEntry.SelectionListEntry<T>>,
    Scope: CreateFusionScope.FusionScope
} & typeof(setmetatable({}, SelectionListEntryFrame))



--[[
Creates a slection list entry frame.
--]]
function SelectionListEntryFrame.new<T>(ParentScope: CreateFusionScope.FusionScope, InitialIndex: number, InitialEntry: SelectionListEntry.SelectionListEntry<T>, CreateContents: ContentsConstructor<T>): SelectionListEntryFrame<T>
    --Create the frames.
    local Scope = ParentScope:innerScope() :: CreateFusionScope.FusionScope
    local Hovering = Scope:Value(false)
    local Entry = Scope:Value(InitialEntry)
    local GuiInstanceAbsoluteSize = Scope:Value(Vector2.zero)
    local DoubleClickEvent = Instance.new("BindableEvent")
    table.insert(Scope, DoubleClickEvent)
    local LastClickTime: number? = nil

    local GuiInstance = Scope:Create("Frame")({
        BackgroundTransparency = Scope:Computed(function(use)
            return (not use(Hovering) and not use(use(Entry).Selected)) and 1 or 0
        end),
        BackgroundColor3 = Scope:PluginColor(Enum.StudioStyleGuideColor.TableItem, Scope:Computed(function(use)
            if use(use(Entry).Selected) then
                return Enum.StudioStyleGuideModifier.Selected
            elseif use(Hovering) then
                return Enum.StudioStyleGuideModifier.Hover
            end
            return Enum.StudioStyleGuideModifier.Default
        end)),
        [Out("AbsoluteSize")] = GuiInstanceAbsoluteSize,
        [OnEvent("MouseEnter")] = function()
            Hovering:set(true)
        end,
        [OnEvent("MouseLeave")] = function()
            Hovering:set(false)
        end,
        [Children] = {
            --Arrow.
            Scope:Create("ImageButton")({
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Size = UDim2.new(0, 8, 0, 8),
                Position = Scope:Computed(function(use)
                    local CurrentHeight = use(GuiInstanceAbsoluteSize).Y
                    return UDim2.new(0, (use(use(Entry).Level) - 0.5) * CurrentHeight, 0.5, 0)
                end),
                SizeConstraint = Enum.SizeConstraint.RelativeYY,
                Visible = Scope:Computed(function(use)
                    local CurrentEntry = use(Entry)
                    return use(CurrentEntry.Expandable) and #use(CurrentEntry.Children) > 0
                end),
                Image = Scope:Computed(function(use)
                    return use(use(Entry).Expanded) and EXPANDED_ARROW_IMAGE or COLLAPSED_ARROW_IMAGE
                end),
                ImageColor3 = Enum.StudioStyleGuideColor.MainText,
                [OnEvent("MouseButton1Down")] = function()
                    local CurrentEntry = Fusion.peek(Entry)
                    if not Fusion.peek(CurrentEntry.Expandable) or #Fusion.peek(CurrentEntry.Children) <= 0 then return end
                    CurrentEntry.Expanded:set(not Fusion.peek(CurrentEntry.Expanded))
                end,
            }),

            --Contents.
            Scope:Create("Frame")({
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(1, 0),
                Size = Scope:Computed(function(use)
                    return UDim2.new(1, -(use(GuiInstanceAbsoluteSize).Y) * use(use(Entry).Level), 1, 0)
                end),
                Position = UDim2.new(1, 0, 0, 0),
                [OnEvent("InputBegan")] = function(Input: InputObject, Processed: boolean)
                    if Processed then return end
                    if Input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end

                    --Handle the click and double-click.
                    if not LastClickTime or (tick() - LastClickTime) > DOUBLE_CLICK_MAX_SECONDS then
                        LastClickTime = tick()
                        Fusion.peek(Entry):ToggleSelection(Input:IsModifierKeyDown(Enum.ModifierKey.Ctrl), Input:IsModifierKeyDown(Enum.ModifierKey.Shift))
                    else
                        LastClickTime = nil
                        DoubleClickEvent:Fire()
                    end
                end,
                [Children] = CreateContents(Scope, Entry, DoubleClickEvent.Event),
            }),
        },
    }) :: Frame

    --End the hovering if the content changes.
    Scope:Observer(Entry):onChange(function()
        Hovering:set(false)
    end)

    --Create and return the object.
    return setmetatable({
        GuiInstance = GuiInstance,
        Entry = Entry,
        Scope = Scope,
    }, SelectionListEntryFrame) :: SelectionListEntryFrame<T>
end

--[[
Updates the list entry.
--]]
function SelectionListEntryFrame.Update<T>(self: SelectionListEntryFrame<T>, Index: number, Entry: SelectionListEntry.SelectionListEntry<T>): ()
    self.Entry:set(Entry)
end

--[[
Destroys the list entry.
--]]
function SelectionListEntryFrame.Destroy<T>(self: SelectionListEntryFrame<T>): ()
    self.Scope:doCleanup()
end



return SelectionListEntryFrame