--Creates a plugin toggle button for a PluginGui from an existing plugin toolbar button.
--!strict

return function(Button: PluginToolbarButton, PluginGui: LayerCollector): PluginToolbarButton
    --Set up the changed event.
    PluginGui:GetPropertyChangedSignal("Enabled"):Connect(function()
        Button:SetActive(PluginGui.Enabled)
    end)
    Button:SetActive(PluginGui.Enabled)

    --Set up toggling the PluginGui.
    local DB = true
    Button.Click:Connect(function()
        if not DB then return end
        DB = false
        PluginGui.Enabled = not PluginGui.Enabled
        task.wait()
        DB = true
    end)

    --Return the original button.
    return Button
end