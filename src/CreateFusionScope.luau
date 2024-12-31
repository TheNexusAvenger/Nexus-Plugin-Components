--Creates scopes in Fusion for plugins.
--!strict

local INSTANCE_PROPERTY_DEFAULTS = {
    ScrollingFrame = {
        BorderSizePixel = 1,
        ScrollBarThickness = 12,
        BottomImage = "rbxasset://textures/AvatarEditorImages/LightPixel.png",
        MidImage = "rbxasset://textures/AvatarEditorImages/LightPixel.png",
        TopImage = "rbxasset://textures/AvatarEditorImages/LightPixel.png",
    },
    TextLabel = {
        BackgroundTransparency = 1,
    },
    TextButton = {
        BorderSizePixel = 1,
    },
    TextBox = {
        BorderSizePixel = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClipsDescendants = true,
    },
} :: {[string]: {[string]: any}}
local INSTANCE_COLOR_DEFAULTS = {
    Frame = {
        BackgroundColor3 = Enum.StudioStyleGuideColor.MainBackground,
        BorderColor3 = Enum.StudioStyleGuideColor.Border,
    },
    ImageButton = {
        BackgroundColor3 = Enum.StudioStyleGuideColor.Button,
        BorderColor3 = Enum.StudioStyleGuideColor.ButtonBorder,
    },
    ScrollingFrame = {
        BackgroundColor3 = Enum.StudioStyleGuideColor.MainBackground,
        BorderColor3 = Enum.StudioStyleGuideColor.Border,
        ScrollBarImageColor3 = Enum.StudioStyleGuideColor.ScrollBar,
    },
    TextLabel = {
        TextColor3 = Enum.StudioStyleGuideColor.MainText,
    },
    TextButton = {
        BackgroundColor3 = Enum.StudioStyleGuideColor.Button,
        BorderColor3 = Enum.StudioStyleGuideColor.ButtonBorder,
        TextColor3 = Enum.StudioStyleGuideColor.ButtonText,
    },
    TextBox = {
        BackgroundColor3 = Enum.StudioStyleGuideColor.InputFieldBackground,
        BorderColor3 = Enum.StudioStyleGuideColor.InputFieldBorder,
        TextColor3 = Enum.StudioStyleGuideColor.MainText,
        PlaceholderColor3 = Enum.StudioStyleGuideColor.DimmedText,
    },
} :: {[string]: {[string]: Enum.StudioStyleGuideColor}}

local Fusion = require(script.Parent:WaitForChild("Fusion"))
local FusionTypes = require(script.Parent:WaitForChild("Fusion"):WaitForChild("Types"))

export type FusionScope = FusionTypes.Fusion & {
    PluginColor: (Scope: FusionScope, Color: Fusion.UsedAs<Enum.StudioStyleGuideColor>, Modifier: Fusion.UsedAs<Enum.StudioStyleGuideModifier>?) -> (Fusion.UsedAs<Color3>),
    Create: (Scope: FusionScope, ClassName: string) -> (FusionTypes.PropertyTable) -> (Instance),
}

return function(OverrideStudioSettings: Studio?): FusionScope
    return Fusion.scoped(Fusion, {
        PluginColor = function(Scope: FusionScope, Color: Fusion.UsedAs<Enum.StudioStyleGuideColor>, Modifier: Fusion.UsedAs<Enum.StudioStyleGuideModifier>?): Fusion.UsedAs<Color3>
            --Get the Studio theme.
            local StudioSettings = OverrideStudioSettings or settings().Studio
            local StudioTheme = Scope:Value(StudioSettings.Theme)
            table.insert(Scope, StudioSettings.ThemeChanged:Connect(function()
                StudioTheme:set(StudioSettings.Theme)
            end))

            --Return a value based on the current color.
            return Scope:Computed(function(use)
                return (use(StudioTheme) :: StudioTheme):GetColor(use(Color), use(Modifier))
            end)
        end,
        Create = function(Scope: FusionScope, ClassName: string): (FusionTypes.PropertyTable) -> (Instance)
            return function(Properties: FusionTypes.PropertyTable): Instance
                --Add the defaults.
                if INSTANCE_PROPERTY_DEFAULTS[ClassName] then
                    for PropertyName, PropertyValue in INSTANCE_PROPERTY_DEFAULTS[ClassName] do
                        if Properties[PropertyName] then continue end
                        Properties[PropertyName] = PropertyValue
                    end
                end
                if INSTANCE_COLOR_DEFAULTS[ClassName] then
                    for PropertyName, PropertyColor in INSTANCE_COLOR_DEFAULTS[ClassName] do
                        if Properties[PropertyName] then continue end
                        Properties[PropertyName] = Scope:PluginColor(PropertyColor)
                    end
                end

                --Create and return the instance.
                return Fusion.New(Scope, ClassName)(Properties)
            end
        end,
    }) :: FusionScope
end