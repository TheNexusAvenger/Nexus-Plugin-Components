--Creates a slider for scaling numbers.
--!strict

local SLIDER_BUTTON_WIDTH = 8

local Fusion = require(script.Parent.Parent:WaitForChild("Packages"):WaitForChild("Fusion"))
local CreateFusionScope = require(script.Parent.Parent:WaitForChild("CreateFusionScope"))

local Children = Fusion.Children
local OnEvent = Fusion.OnEvent
local Out = Fusion.Out

export type Options = {
    ValueRange: Fusion.UsedAs<NumberRange>?,
    ValueIncrement: Fusion.UsedAs<number>?,
}

return function(Scope: CreateFusionScope.FusionScope, Value: Fusion.Value<number>, Options: Options?): Frame
    local Parent = Scope:Value(nil :: GuiObject?)
    local FrameAbsoluteSize = Scope:Value(Vector2.zero)
    local FrameAbsolutePosition = Scope:Value(Vector2.zero)
    local SliderButtonAbsolutePosition = Scope:Value(Vector2.zero)
    local ValueRange = (Options and Options.ValueRange) or NumberRange.new(0, 1)
    local ValueIncrement = (Options and Options.ValueIncrement) or 0.001
    local DragEventConnections = {} :: {RBXScriptConnection}
    return Scope:Create("Frame")({
        BackgroundTransparency = 1,
        [Out("AbsoluteSize")] = FrameAbsoluteSize,
        [Out("AbsolutePosition")] = FrameAbsolutePosition,
        [Out("Parent")] = Parent,
        [Children] = {
            --Center slider bar background.
            Scope:Create("Frame")({
                BorderColor3 = Scope:PluginColor(Enum.StudioStyleGuideColor.TitlebarText, Enum.StudioStyleGuideModifier.Disabled),
                BorderSizePixel = 1,
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 0.5, 0),
            }),

            --Slider button.
            Scope:Create("TextButton")({
                BackgroundColor3 = Scope:PluginColor(Enum.StudioStyleGuideColor.Button),
                BorderColor3 = Scope:PluginColor(Enum.StudioStyleGuideColor.Border),
                Size = UDim2.new(0, SLIDER_BUTTON_WIDTH, 1, 0),
                Position = Scope:Computed(function(use)
                    local CurrentValue = use(Value)
                    local CurrentValueRange = use(ValueRange) :: NumberRange
                    local SliderPercent = math.clamp((CurrentValue - CurrentValueRange.Min) / (CurrentValueRange.Max - CurrentValueRange.Min), 0, 1)
                    local SliderWidth = math.max(SLIDER_BUTTON_WIDTH, use(FrameAbsoluteSize).X - SLIDER_BUTTON_WIDTH)
                    return UDim2.new(0, SliderPercent * SliderWidth, 0, 0)
                end),
                Text = "",
                [Out("AbsolutePosition")] = SliderButtonAbsolutePosition,
                [OnEvent("MouseButton1Down")] = function(StartX: number, StartY: number)
                    --Clear the previous events.
                    for _, EventConnection in DragEventConnections do
                        EventConnection:Disconnect()
                    end
                    DragEventConnections = {}
            
                    --Get the upper-most parent.
                    local InputParent = Fusion.peek(Parent)
                    while InputParent do
                        if not InputParent.Parent or not InputParent.Parent:IsA("GuiObject") then
                            break
                        end
                        InputParent = InputParent.Parent
                    end
                    if not InputParent then return end
            
                    --Connect moving the mouse.
                    local XOffset = Fusion.peek(SliderButtonAbsolutePosition).X - StartX
                    table.insert(DragEventConnections, InputParent.InputChanged:Connect(function(Input: InputObject): ()
                        if Input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
                        local CurrentValueRange = Fusion.peek(ValueRange) :: NumberRange
                        local CurrentValueIncrement = Fusion.peek(ValueIncrement) :: number
                        local PositionX = Input.Position.X + XOffset
                        local NewPercent = math.clamp((PositionX - Fusion.peek(FrameAbsolutePosition).X) / math.max(1, Fusion.peek(FrameAbsoluteSize).X - SLIDER_BUTTON_WIDTH), 0, 1)
                        local NewValue = CurrentValueRange.Min + ((CurrentValueRange.Max - CurrentValueRange.Min) * NewPercent)
                        Value:set(CurrentValueIncrement * math.floor((NewValue / CurrentValueIncrement) + 0.5))
                    end))
            
                    --Connect releasing the mouse.
                    for _, ChildGuiObject in InputParent:GetDescendants() do
                        if not ChildGuiObject:IsA("GuiObject") then continue end
                        table.insert(DragEventConnections, ChildGuiObject.InputEnded:Connect(function(Input: InputObject): ()
                            if Input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
                            for _, Event in DragEventConnections do
                                Event:Disconnect()
                            end
                            DragEventConnections = {}
                        end))
                    end
                end,
            }),
        },
    }) :: Frame
end