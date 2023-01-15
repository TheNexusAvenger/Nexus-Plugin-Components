--[[
TheNexusAvenger

Custom slider input for scaling number values.
--]]
--!strict

local NexusPluginComponents = script.Parent.Parent.Parent
local PluginInstance = require(NexusPluginComponents:WaitForChild("Base"):WaitForChild("PluginInstance"))
local PluginColor = require(NexusPluginComponents:WaitForChild("Base"):WaitForChild("PluginColor"))
local TextButton = require(NexusPluginComponents:WaitForChild("Input"):WaitForChild("Roblox"):WaitForChild("TextButton"))
local TextBox = require(NexusPluginComponents:WaitForChild("Input"):WaitForChild("Roblox"):WaitForChild("TextBox"))
local UserInputService = require(NexusPluginComponents:WaitForChild("Input"):WaitForChild("Service"):WaitForChild("UserInputService"))

local Slider = PluginInstance:Extend()
Slider:SetClassName("Slider")

export type Slider = {
    new: () -> (Slider),
    Extend: (self: Slider) -> (Slider),

    Value: number,
    MinimumValue: number,
    MaximumValue: number,
    ValueIncrement: number,
    ConnectTextBox: (self: Slider, TextBox: TextBox.PluginTextBox) -> (),
} & PluginInstance.PluginInstance & Frame



--[[
Formats the number for a text box.
--]]
local function FormatNumber(Number: number): string
    local Text = string.format("%.3f", Number)
    Text = string.match(Text, "(%-?%d-)%.0+$") or string.match(Text, "(%-?[%d%.]-)0+$") or Text
    return Text
end



--[[
Creates the Slider.
--]]
function Slider:__new()
    PluginInstance.__new(self, "Frame")
    self.BackgroundTransparency = 1

    --Create the frames.
    local SliderBar = PluginInstance.new("Frame")
    SliderBar.BorderColor3 = PluginColor.new(Enum.StudioStyleGuideColor.TitlebarText, Enum.StudioStyleGuideModifier.Disabled)
    SliderBar.BorderSizePixel = 1
    SliderBar.Size = UDim2.new(1, 0, 0, 0)
    SliderBar.Position = UDim2.new(0, 0, 0.5, 0)
    SliderBar.Parent = self
    self:DisableChangeReplication("SliderBar")
    self.SliderBar = SliderBar

    local SliderButton = TextButton.new("TextButton")
    SliderButton.BackgroundColor3 = Enum.StudioStyleGuideColor.Button
    SliderButton.BorderColor3 = Enum.StudioStyleGuideColor.Border
    SliderButton.Size = UDim2.new(0, 8, 1, 0)
    SliderButton.Text = ""
    SliderButton.Parent = self
    self:DisableChangeReplication("SliderButton")
    self.SliderButton = SliderButton

    --Store the values.
    self:DisableChangeReplication("Value")
    self.Value = 0
    self:DisableChangeReplication("MinimumValue")
    self.MinimumValue = 0
    self:DisableChangeReplication("MaximumValue")
    self.MaximumValue = 1
    self:DisableChangeReplication("ValueIncrement")
    self.ValueIncrement = 0.001

    --Add the Disabled property.
    local DragEvents = {} :: {RBXScriptConnection}
    self:DisableChangeReplication("TextBox")
    self:DisableChangeReplication("Disabled")
    self:GetPropertyChangedSignal("Disabled"):Connect(function()
        SliderButton.Disabled = self.Disabled
        self:SetAllColorModifiers(self.Disabled and Enum.StudioStyleGuideModifier.Disabled or Enum.StudioStyleGuideModifier.Default)
        if self.TextBox then
            self.TextBox.Disabled = self.Disabled
        end
        for _, Event in DragEvents do
            Event:Disconnect()
        end
    end)
    self.Disabled = false

    --Connect the events.
    self:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        self:UpdatePosition()
    end)
    self:GetPropertyChangedSignal("Value"):Connect(function()
        self:UpdatePosition()
    end)
    self:GetPropertyChangedSignal("MinimumValue"):Connect(function()
        self:UpdatePosition()
    end)
    self:GetPropertyChangedSignal("MaximumValue"):Connect(function()
        self:UpdatePosition()
    end)
    self:GetPropertyChangedSignal("ValueIncrement"):Connect(function()
        self:UpdatePosition()
    end)

    --Connect dragging.
    SliderButton.MouseButton1Down:Connect(function(StartX: number, StartY: number): ()
        for _, Event in DragEvents do
            Event:Disconnect()
        end
        DragEvents = {}
        if self.Disabled then return end

        --Get the upper-most parent.
        local InputParent = self
        while InputParent do
            if not InputParent.Parent or not InputParent.Parent:IsA("GuiObject") then
                break
            end
            InputParent = InputParent.Parent
        end

        --Connect moving the mouse.
        local XOffset = SliderButton.AbsolutePosition.X - StartX
        table.insert(DragEvents, InputParent.InputChanged:Connect(function(Input: InputObject): ()
            if Input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
            local PositionX = Input.Position.X + XOffset
            local NewPercent = math.clamp((PositionX - self.AbsolutePosition.X) / math.max(1, self.AbsoluteSize.X - 8), 0, 1)
            local NewValue = self.MinimumValue + ((self.MaximumValue - self.MinimumValue) * NewPercent)
            self.Value = self.ValueIncrement * math.floor((NewValue / self.ValueIncrement) + 0.5)
        end))

        --Connect releasing the mouse.
        table.insert(DragEvents, UserInputService.InputEnded:Connect(function(Input: InputObject): ()
            if Input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
            for _, Event in DragEvents do
                Event:Disconnect()
            end
        end))
    end)
end

--[[
Updates the slider position.
--]]
function Slider:UpdatePosition(): ()
    local SliderPercent = math.clamp((self.Value - self.MinimumValue) / (self.MaximumValue - self.MinimumValue), 0, 1)
    local SliderWidth = math.max(8, self.AbsoluteSize.X - 8)
    self.SliderButton.Position = UDim2.new(0, SliderPercent * SliderWidth, 0, 0)
end

--[[
Connects a TextBox to the slider.
--]]
function Slider:ConnectTextBox(TextBox: TextBox.PluginTextBox): ()
    --Set the initial value.
    TextBox.Text = FormatNumber(self.Value)
    TextBox.Disabled = self.Disabled
    self.TextBox = TextBox

    --Connect the value changing.
    self:GetPropertyChangedSignal("Value"):Connect(function()
        TextBox.Text = FormatNumber(self.Value)
    end)

    --Connect the text changing.
    TextBox:GetPropertyChangedSignal("Text"):Connect(function()
        local NewValue = tonumber(TextBox.Text)
        if NewValue then
            self.Value = NewValue
        elseif not TextBox:IsFocused() then
            TextBox.Text = FormatNumber(self.Value)
        end
    end)
    TextBox.FocusLost:Connect(function()
        local NewValue = tonumber(TextBox.Text)
        if NewValue then
            self.Value = NewValue
        else
            TextBox.Text = FormatNumber(self.Value)
        end
    end)
end



return (Slider :: any) :: Slider