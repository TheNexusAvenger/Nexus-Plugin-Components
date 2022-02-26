--[[
TheNexusAvenger

Manages displaying a list of elements so only the visible elements are shown.
--]]

local NexusPluginComponents = require(script.Parent.Parent.Parent)

local PluginInstance = NexusPluginComponents:GetResource("Base.PluginInstance")

local ElementList = PluginInstance:Extend()
ElementList:SetClassName("ElementList")



--[[
Creates the Element List.
--]]
function ElementList:__new(EntryClass)
    self:InitializeSuper("Frame")

    --Set up the container.
    self.BackgroundTransparency = 1
    self.ClipsDescendants = true

    local AdornFrame = PluginInstance.new("Frame")
    AdornFrame.BackgroundTransparency = 1
    AdornFrame.Parent = self
    self:DisableChangeReplication("AdornFrame")
    self.AdornFrame = AdornFrame

    --Set the defaults.
    self:DisableChangeReplication("FrameEntries")
    self.FrameEntries = {}
    self:DisableChangeReplication("DataEntries")
    self.DataEntries = {}
    self:DisableChangeReplication("CreateEntry")
    self.CreateEntry = (typeof(EntryClass) == "function" and EntryClass or EntryClass.new)
    self:DisableChangeReplication("EntryHeight")
    self.EntryHeight = 16
    self:DisableChangeReplication("CurrentOffset")
    self.CurrentOffset = Vector2.new(0, 0)
    self:DisableChangeReplication("CurrentWidth")
    self.CurrentWidth = 0
    self:DisableChangeReplication("CurrentDataIndex")
    self.CurrentDataIndex = 0
    self:DisableChangeReplication("AttachedScrollingFrame")

    --Connect the events.
    self:GetPropertyChangedSignal("EntryHeight"):Connect(function()
        self:UpdateFrameContents()
    end)
    self:GetPropertyChangedSignal("CurrentOffset"):Connect(function()
        self:UpdateFrameContents()
    end)
    self:GetPropertyChangedSignal("CurrentWidth"):Connect(function()
        self:UpdateAdornSize()
    end)
end

--[[
Updates the size and position of the adorn.
--]]
function ElementList:UpdateAdornSize()
    self.AdornFrame.Size = UDim2.new(self.CurrentWidth == 0 and 1 or 0, self.CurrentWidth, 0, self.EntryHeight)
    self.AdornFrame.Position = UDim2.new(0, -self.CurrentOffset.X, 0, -(self.CurrentOffset.Y % self.EntryHeight))

    if self.AttachedScrollingFrame then
        self.AttachedScrollingFrame.CanvasSize = UDim2.new(0, self.CurrentWidth, 0, #self.DataEntries * self.EntryHeight)
    end
end

--[[
Updates the total frames.
--]]
function ElementList:UpdateTotalFrames()
    self:UpdateAdornSize()

    --Create the entries.
    local StartIndex = self.CurrentOffset.Y / self.EntryHeight
    local RequiredEntries = math.ceil(self.AbsoluteSize.Y / self.EntryHeight) + 1
    local FrameEntries, DataEntries = self.FrameEntries, self.DataEntries
    for i = #FrameEntries + 1, RequiredEntries do
        local Entry = self.CreateEntry()
        Entry.Size = UDim2.new(1, 0, 1, 0)
        Entry.Position = UDim2.new(0, 0, i - 1, 0)
        if Entry:IsA("CollapsableListFrame") then
            Entry.ElementList = self
        end
        Entry.Parent = self.AdornFrame
        Entry:Update(DataEntries[i + math.floor(StartIndex)])
        table.insert(FrameEntries, Entry)
    end
    for i = #FrameEntries, RequiredEntries + 1, -1 do
        FrameEntries[i]:Destroy()
        FrameEntries[i] = nil
    end
end

--[[
Updates the contents of the frames.
--]]
function ElementList:UpdateFrameContents(Force)
    --Update the existing frames if it is forced or the start index changed.
    local StartIndex = math.floor(self.CurrentOffset.Y / self.EntryHeight)
    local RequiredEntries = math.ceil(self.AbsoluteSize.Y / self.EntryHeight) + 1
    if Force or self.CurrentDataIndex ~= StartIndex then
        self.CurrentDataIndex = StartIndex
        local FrameEntries, DataEntries = self.FrameEntries, self.DataEntries
        for i = 1, math.min(RequiredEntries, #self.FrameEntries) do
            FrameEntries[i]:Update(DataEntries[i + math.floor(StartIndex)])
        end
    end

    --Update the total frames.
    --Done after updating the frames to reduce "double updates" occuring.
    self:UpdateTotalFrames()
end

--[[
Sets the entries to display.
--]]
function ElementList:SetEntries(Entries)
    self.DataEntries = Entries
    self:UpdateFrameContents(true)
end

--[[
Updates the ScrollingFrame attachment values.
--]]
function ElementList:UpdateScrollingFrameProperties()
    --Return if no ScrollingFrame is connected.
    local ScrollingFrame = self.AttachedScrollingFrame
    if not self.AttachedScrollingFrame then return end

    --Mirror the properties.
    self.Parent = ScrollingFrame.Parent
    self.Position = ScrollingFrame.Position
    self.Size = UDim2.new(0, ScrollingFrame.AbsoluteWindowSize.X, 0, ScrollingFrame.AbsoluteWindowSize.Y)
    self.CurrentOffset = ScrollingFrame.CanvasPosition
end

--[[
Connects a ScrollingFrame to the element list.
--]]
function ElementList:ConnectScrollingFrame(ScrollingFrame)
    self.AttachedScrollingFrame = ScrollingFrame
    self.AttachedScrollingFrame.Changed:Connect(function()
        self:UpdateScrollingFrameProperties()
    end)
    self:UpdateScrollingFrameProperties()
    self:UpdateAdornSize()
end



return ElementList