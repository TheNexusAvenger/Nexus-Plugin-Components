--[[
TheNexusAvenger

Wrapped plugin instance with additional functionality.
--]]

local INSTANCE_CREATION_PRESETS = {
	Frame = {
		BackgroundColor3 = Enum.StudioStyleGuideColor.MainBackground,
		BorderColor3 = Enum.StudioStyleGuideColor.Border,
		BorderSizePixel = 0,
	},
    ImageButton = {
        BackgroundColor3 = Enum.StudioStyleGuideColor.Button,
        BorderColor3 = Enum.StudioStyleGuideColor.ButtonBorder,
    },
    ScrollingFrame = {
        BackgroundColor3 = Enum.StudioStyleGuideColor.MainBackground,
        BorderColor3 = Enum.StudioStyleGuideColor.Border,
    },
	TextLabel = {
		BackgroundTransparency = 1,
		TextColor3 = Enum.StudioStyleGuideColor.MainText,
		TextXAlignment = Enum.TextXAlignment.Left,
		Font = Enum.Font.SourceSans,
		TextSize = 14,
	},
	TextButton = {
		BackgroundColor3 = Enum.StudioStyleGuideColor.Button,
		BorderColor3 = Enum.StudioStyleGuideColor.ButtonBorder,
		BorderSizePixel = 1,
		TextColor3 = Enum.StudioStyleGuideColor.ButtonText,
		Font = Enum.Font.SourceSans,
		TextSize = 14,
	},
	TextBox = {
		BackgroundColor3 = Enum.StudioStyleGuideColor.InputFieldBackground,
		BorderColor3 = Enum.StudioStyleGuideColor.InputFieldBorder,
		BorderSizePixel = 1,
		TextColor3 = Enum.StudioStyleGuideColor.MainText,
		PlaceholderColor3 = Enum.StudioStyleGuideColor.DimmedText,
		TextXAlignment = Enum.TextXAlignment.Left,
		Font = Enum.Font.SourceSans,
		TextSize = 14,
		ClearTextOnFocus = false,
		ClipsDescendants = true,
	},
}



local NexusPluginComponents = require(script.Parent.Parent)

local NexusWrappedInstance = NexusPluginComponents:GetResource("NexusWrappedInstance")
local PluginColor = NexusPluginComponents:GetResource("Base.PluginColor")

local PluginInstance = NexusWrappedInstance:Extend()
PluginInstance:SetClassName("PluginInstance")
PluginInstance.ColorProperties = {}
PluginInstance.Settings = settings()



--[[
Creates the plugin instance.
--]]
function PluginInstance:__new(InstanceToWrap)
    self:InitializeSuper(InstanceToWrap)

    --Set up the color property storage.
    self:DisableChangeReplication("WrappedClassName")
    local WrappedInstance = self:GetWrappedInstance()
    local WrappedClassName = WrappedInstance.ClassName
    self.WrappedClassName = WrappedClassName
    if not self.ColorProperties[WrappedClassName] then
        self.ColorProperties[WrappedClassName] = {}
    end
    local ColorProperties = self.ColorProperties[WrappedClassName]

    --Connect colors being changed.
    self:AddGenericPropertyValidator({
        ValidateChange = function(_, _, Name, Value)
            --Determine if the property is a Color3.
            if ColorProperties[Name] == nil then
                xpcall(function()
                    --Store if the property is a Color3.
                    ColorProperties[Name] = (typeof(WrappedInstance[Name]) == "Color3")
                end, function()
                    --Store false (failed to index).
                    ColorProperties[Name] = false
                end)
            end

            --Return the PluginColor or the original value.
            if ColorProperties[Name] and typeof(Value) ~= "Color3" and (typeof(Value) == "string" or typeof(Value) == "EnumItem") then
                return PluginColor.new(Value)
            end
            return Value
        end,
    })

    --Connect updating the themes.
    table.insert(self.EventsToDisconnect, self.Settings.Studio.ThemeChanged:Connect(function()
        for PropertyName, IsColorProperty in pairs(ColorProperties) do
            if IsColorProperty then
                local Color = self[PropertyName]
                if typeof(Color) == "table" and Color.IsA and Color:IsA("PluginColor") then
                    self[PropertyName] = PluginColor.new(Color.ColorEnum, Color.ModiferEnum)
                end
            end
        end
    end))

    --Set the defaults.
    if typeof(InstanceToWrap) == "string" and INSTANCE_CREATION_PRESETS[WrappedClassName] then
        for Name, Value in pairs(INSTANCE_CREATION_PRESETS[WrappedClassName]) do
            self[Name] = Value
        end
    end
end

--[[
Updates the modifier of a plugin color. If a PluginColor is not
in use, there will be no effect.
--]]
function PluginInstance:SetColorModifier(PropertyName, Modifier)
    Modifier = Modifier or Enum.StudioStyleGuideModifier.Default

    --Return if the color isn't a PluginColor.
    local Color = self[PropertyName]
    if not (typeof(Color) == "table" and Color.IsA and Color:IsA("PluginColor")) then
        return
    end

    --Return if the modifer is the same.
    if Color.ModiferEnum == Modifier then
        return
    end

    --Change the color.
    self[PropertyName] = PluginColor.new(Color.ColorEnum, Modifier)
end

--[[
Sets all the color modifiers of the plugin colors.
--]]
function PluginInstance:SetAllColorModifiers(Modifier)
    for PropertyName, IsColorProperty in pairs(self.ColorProperties[self.WrappedClassName]) do
        if IsColorProperty then
            self:SetColorModifier(PropertyName, Modifier)
        end
    end
end

--[[
Converts a property for replicating to the wrapped instance.
--]]
function PluginInstance:ConvertProperty(PropertyName, PropertyValue)
    --Return the color if a PluginColor is used.
    if typeof(PropertyValue) == "table" and PropertyValue.IsA and PropertyValue:IsA("PluginColor") then
        return PropertyValue:GetColor()
    end

    --Return the super result.
    return self.super:ConvertProperty(PropertyName, PropertyValue)
end



return PluginInstance