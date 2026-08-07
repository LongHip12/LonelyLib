local Library = {}
local _theme = {
    Background = Color3.fromRGB(24, 24, 24),
    Accent = Color3.fromRGB(248, 4, 46),
    Secondary = Color3.fromRGB(40, 40, 40),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(150, 150, 150),
    Border = Color3.fromRGB(60, 60, 60),
    SliderFill = Color3.fromRGB(175, 40, 42),
    SliderBackground = Color3.fromRGB(255, 255, 255)
}

local function Create(className, properties)
    local instance = Instance.new(className)
    for prop, value in pairs(properties) do
        instance[prop] = value
    end
    return instance
end

local function CreateText(className, text, parent)
    local instance = Create(className, {
        Text = text,
        TextColor3 = _theme.Text,
        TextScaled = false,
        TextSize = 14,
        Font = Enum.Font.SourceSans,
        BackgroundTransparency = 1,
        Parent = parent,
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center
    })
    return instance
end

local Window = {}
Window.__index = Window

function Window.new(config)
    local self = setmetatable({}, Window)
    self._config = config or {}
    self._tabs = {}
    self._currentTab = nil
    self._sections = {}

    self._screenGui = Instance.new("ScreenGui")
    self._screenGui.Name = "LonelyLib"
    self._screenGui.ResetOnSpawn = false
    self._screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    self._mainFrame = Create("Frame", {
        Name = "MAIN_UI",
        Parent = self._screenGui,
        Size = UDim2.new(0.4678339958190918, 15, 0.6484929919242859, 15),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = _theme.Background,
        BackgroundTransparency = 0.25,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = 999
    })

    Create("UICorner", {
        Parent = self._mainFrame,
        CornerRadius = UDim.new(0.075, 0)
    })

    local stroke = Create("UIStroke", {
        Parent = self._mainFrame,
        Color = _theme.Text,
        Thickness = 2.5
    })
    Create("UIGradient", {
        Parent = stroke,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(26, 25, 25)),
            ColorSequenceKeypoint.new(0.1468, Color3.fromRGB(34, 23, 25)),
            ColorSequenceKeypoint.new(0.563, Color3.fromRGB(156, 3, 31)),
            ColorSequenceKeypoint.new(0.9188, Color3.fromRGB(33, 23, 25)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(37, 22, 25))
        }),
        Rotation = 90
    })

    local split = Create("Frame", {
        Name = "SplitScreen",
        Parent = self._mainFrame,
        Size = UDim2.new(0.004999999888241291, 0, 0.8999999761581421, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0
    })
    Create("UIGradient", {
        Parent = split,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(16, 16, 16)),
            ColorSequenceKeypoint.new(0.1468, Color3.fromRGB(34, 23, 25)),
            ColorSequenceKeypoint.new(0.563, Color3.fromRGB(156, 3, 31)),
            ColorSequenceKeypoint.new(0.9188, Color3.fromRGB(33, 23, 25)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 15, 17))
        }),
        Rotation = 90
    })

    local titleFrame = Create("Frame", {
        Name = "Title",
        Parent = self._mainFrame,
        Size = UDim2.new(1, 0, 0.12, 0),
        Position = UDim2.new(0, 0, 0.03, 0),
        BackgroundTransparency = 1,
        ClipsDescendants = true
    })
    local title = CreateText("TextLabel", config.Title or "LonelyLib", titleFrame)
    title.TextColor3 = _theme.Text
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Center
    local subtitle = CreateText("TextLabel", config.Subtitle or "Advanced UI Library", titleFrame)
    subtitle.Position = UDim2.new(0, 0, 0, 20)
    subtitle.TextColor3 = _theme.SubText
    subtitle.TextSize = 14
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextXAlignment = Enum.TextXAlignment.Center

    self._tabContainer = Create("Frame", {
        Name = "TabContainer",
        Parent = self._mainFrame,
        Size = UDim2.new(1, 0, 0.07, 0),
        Position = UDim2.new(0, 0, 0.15, 0),
        BackgroundTransparency = 1
    })

    self._contentContainer = Create("Frame", {
        Name = "Content",
        Parent = self._mainFrame,
        Size = UDim2.new(1, 0, 0.78, 0),
        Position = UDim2.new(0, 0, 0.22, 0),
        BackgroundTransparency = 1,
        ClipsDescendants = true
    })

    local dragging = false
    local dragStart = nil
    local startPos = nil

    self._mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self._mainFrame.Position
        end
    end)

    self._mainFrame.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            self._mainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    self._mainFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    return self
end

function Window:AddTab(config)
    local tab = {}
    tab._config = config or {}
    tab._sections = {}
    tab._window = self

    local button = Create("TextButton", {
        Name = "Tab_" .. (#self._tabs + 1),
        Parent = self._tabContainer,
        Size = UDim2.new(0.2, 0, 1, 0),
        Position = UDim2.new(#self._tabs * 0.2, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 2
    })

    local label = CreateText("TextLabel", config.Title or "Tab", button)
    label.TextColor3 = _theme.SubText
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Center

    local content = Create("Frame", {
        Name = "Content_" .. (#self._tabs + 1),
        Parent = self._contentContainer,
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Visible = #self._tabs == 0,
        ClipsDescendants = true
    })

    local scrollFrame = Create("ScrollingFrame", {
        Name = "ScrollFrame",
        Parent = content,
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = _theme.Accent,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    })

    local layout = Create("UIListLayout", {
        Parent = scrollFrame,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })

    tab._button = button
    tab._label = label
    tab._content = content
    tab._scrollFrame = scrollFrame

    button.MouseButton1Click:Connect(function()
        for _, t in ipairs(self._tabs) do
            t._content.Visible = false
            t._label.TextColor3 = _theme.SubText
        end
        content.Visible = true
        label.TextColor3 = _theme.Text
        self._currentTab = tab
    end)

    table.insert(self._tabs, tab)

    if #self._tabs == 1 then
        content.Visible = true
        label.TextColor3 = _theme.Text
        self._currentTab = tab
    end

    for i, t in ipairs(self._tabs) do
        t._button.Position = UDim2.new((i - 1) * 0.2, 0, 0, 0)
    end

    return tab
end

function Window:SetMainTab(tab1, tab2, tab3)
    if not tab1 or not tab2 or not tab3 then
        warn("SetMainTab requires 3 tabs!")
        return
    end
end

function Tab:AddSection(config)
    local section = {}
    section._config = config or {}
    section._elements = {}
    section._tab = self

    local frame = Create("Frame", {
        Name = "Section_" .. (#self._sections + 1),
        Parent = self._scrollFrame,
        Size = UDim2.new(1, -10, 0, 60),
        Position = UDim2.new(0, 5, 0, 0),
        BackgroundColor3 = _theme.Secondary,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        LayoutOrder = #self._sections + 1,
        ZIndex = 3
    })

    Create("UICorner", {
        Parent = frame,
        CornerRadius = UDim.new(0.075, 0)
    })

    local stroke = Create("UIStroke", {
        Parent = frame,
        Color = _theme.Border,
        Thickness = 2.5,
        Transparency = 0.7
    })

    local titleLabel = CreateText("TextLabel", config.Title or "Section", frame)
    titleLabel.Position = UDim2.new(0.02, 0, 0.1, 0)
    titleLabel.TextColor3 = _theme.Text
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Size = UDim2.new(0.6, 0, 0.3, 0)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    if config.Description then
        local desc = CreateText("TextLabel", config.Description, frame)
        desc.Position = UDim2.new(0.02, 0, 0.35, 0)
        desc.TextColor3 = _theme.SubText
        desc.TextSize = 12
        desc.Font = Enum.Font.Gotham
        desc.Size = UDim2.new(0.6, 0, 0.2, 0)
        desc.TextXAlignment = Enum.TextXAlignment.Left
    end

    local elementContainer = Create("Frame", {
        Name = "Elements",
        Parent = frame,
        Size = UDim2.new(1, 0, 1, -30),
        Position = UDim2.new(0, 0, 0.45, 0),
        BackgroundTransparency = 1,
        ClipsDescendants = true
    })

    local elementLayout = Create("UIListLayout", {
        Parent = elementContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2)
    })

    section._frame = frame
    section._elementContainer = elementContainer
    section._elementLayout = elementLayout
    section._titleLabel = titleLabel

    table.insert(self._sections, section)

    local function updateHeight()
        local count = #section._elements
        local height = 60 + count * 25
        frame.Size = UDim2.new(1, -10, 0, height)
    end

    section._updateHeight = updateHeight

    return section
end

function Section:AddCheckbox(config)
    local element = {}
    element._config = config or {}
    element._section = self
    element._value = config.Default or false

    local frame = Create("Frame", {
        Name = "Checkbox_" .. (#self._elements + 1),
        Parent = self._elementContainer,
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        LayoutOrder = #self._elements + 1
    })

    local title = CreateText("TextLabel", config.Title or "Checkbox", frame)
    title.Size = UDim2.new(0.7, 0, 1, 0)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextColor3 = _theme.Text
    title.TextSize = 13
    title.Font = Enum.Font.Gotham

    local toggleFrame = Create("Frame", {
        Parent = frame,
        Size = UDim2.new(0.14, 0, 0.75, 0),
        Position = UDim2.new(0.85, 0, 0.125, 0),
        BackgroundColor3 = _theme.Secondary,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        ZIndex = 5
    })
    Create("UICorner", {
        Parent = toggleFrame,
        CornerRadius = UDim.new(0.3, 0)
    })

    local indicator = Create("Frame", {
        Parent = toggleFrame,
        Size = UDim2.new(0.9, 0, 0.9, 0),
        Position = UDim2.new(0.05, 0, 0.05, 0),
        BackgroundColor3 = _theme.Accent,
        BackgroundTransparency = element._value and 0 or 0.5,
        BorderSizePixel = 0
    })
    Create("UICorner", {
        Parent = indicator,
        CornerRadius = UDim.new(0.3, 0)
    })

    local function setValue(val)
        element._value = val
        indicator.BackgroundTransparency = val and 0 or 0.5
        if config.Callback then
            config.Callback(val)
        end
    end

    local button = Create("TextButton", {
        Parent = frame,
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 6
    })

    button.MouseButton1Click:Connect(function()
        setValue(not element._value)
    end)

    element._frame = frame
    element._setValue = setValue

    table.insert(self._elements, element)
    self._updateHeight()

    return element
end

function Section:AddSlider(config)
    local element = {}
    element._config = config or {}
    element._section = self
    element._value = config.Default or 0
    element._min = config.Min or 0
    element._max = config.Max or 100
    element._increase = config.Increase or 1

    local frame = Create("Frame", {
        Name = "Slider_" .. (#self._elements + 1),
        Parent = self._elementContainer,
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundTransparency = 1,
        LayoutOrder = #self._elements + 1
    })

    local title = CreateText("TextLabel", config.Title or "Slider", frame)
    title.Size = UDim2.new(0.7, 0, 0.4, 0)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextColor3 = _theme.Text
    title.TextSize = 13
    title.Font = Enum.Font.Gotham

    local valueLabel = CreateText("TextLabel", tostring(element._value), frame)
    valueLabel.Size = UDim2.new(0.2, 0, 0.4, 0)
    valueLabel.Position = UDim2.new(0.8, 0, 0, 0)
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.TextColor3 = _theme.Text
    valueLabel.TextSize = 13
    valueLabel.Font = Enum.Font.Gotham

    local sliderFrame = Create("Frame", {
        Parent = frame,
        Size = UDim2.new(0.9, 0, 0.3, 0),
        Position = UDim2.new(0.05, 0, 0.5, 0),
        BackgroundColor3 = _theme.SliderBackground,
        BackgroundTransparency = 0.8,
        BorderSizePixel = 0
    })
    Create("UICorner", {
        Parent = sliderFrame,
        CornerRadius = UDim.new(1, 10)
    })

    local fill = Create("Frame", {
        Parent = sliderFrame,
        Size = UDim2.new((element._value - element._min) / (element._max - element._min), 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = _theme.SliderFill,
        BorderSizePixel = 0
    })
    Create("UICorner", {
        Parent = fill,
        CornerRadius = UDim.new(1, 10)
    })

    local function setValue(val)
        val = math.clamp(val, element._min, element._max)
        val = math.round(val / element._increase) * element._increase
        element._value = val
        valueLabel.Text = tostring(val)
        fill.Size = UDim2.new((val - element._min) / (element._max - element._min), 0, 1, 0)
        if config.Callback then
            config.Callback(val)
        end
    end

    local dragging = false
    local sliderButton = Create("TextButton", {
        Parent = sliderFrame,
        Size = UDim2.new(1, 0, 5, 0),
        Position = UDim2.new(0, 0, -2, 0),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 2
    })

    sliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    sliderButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    sliderButton.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local scale = math.clamp((input.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
            setValue(element._min + scale * (element._max - element._min))
        end
    end)

    element._frame = frame
    element._setValue = setValue

    table.insert(self._elements, element)
    self._updateHeight()

    return element
end

function Section:AddDropdown(config)
    local element = {}
    element._config = config or {}
    element._section = self
    element._values = config.Values or {}
    element._multi = config.Multi or false
    element._selected = {}
    element._default = config.Default or element._values[1] or ""

    local frame = Create("Frame", {
        Name = "Dropdown_" .. (#self._elements + 1),
        Parent = self._elementContainer,
        Size = UDim2.new(1, 0, 0, 25),
        BackgroundTransparency = 1,
        LayoutOrder = #self._elements + 1
    })

    local title = CreateText("TextLabel", config.Title or "Dropdown", frame)
    title.Size = UDim2.new(0.4, 0, 1, 0)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextColor3 = _theme.Text
    title.TextSize = 13
    title.Font = Enum.Font.Gotham

    local dropdownFrame = Create("Frame", {
        Parent = frame,
        Size = UDim2.new(0.5, 0, 0.8, 0),
        Position = UDim2.new(0.45, 0, 0.1, 0),
        BackgroundColor3 = _theme.Secondary,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        ZIndex = 3,
        ClipsDescendants = true
    })
    Create("UICorner", {
        Parent = dropdownFrame,
        CornerRadius = UDim.new(0.3, 0)
    })

    local selectedText = CreateText("TextLabel", element._default, dropdownFrame)
    selectedText.TextXAlignment = Enum.TextXAlignment.Left
    selectedText.TextColor3 = _theme.Text
    selectedText.TextSize = 13
    selectedText.Size = UDim2.new(0.85, 0, 1, 0)
    selectedText.Position = UDim2.new(0.05, 0, 0, 0)

    local arrow = CreateText("TextLabel", "▼", dropdownFrame)
    arrow.TextXAlignment = Enum.TextXAlignment.Right
    arrow.TextColor3 = _theme.SubText
    arrow.TextSize = 12
    arrow.Size = UDim2.new(0.15, 0, 1, 0)
    arrow.Position = UDim2.new(0.85, 0, 0, 0)

    local dropdownList = Create("ScrollingFrame", {
        Parent = dropdownFrame,
        Size = UDim2.new(1, 0, 0, 100),
        Position = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = _theme.Secondary,
        BackgroundTransparency = 0.9,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 10,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 2,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ClipsDescendants = true
    })
    Create("UICorner", {
        Parent = dropdownList,
        CornerRadius = UDim.new(0.3, 0)
    })

    local listLayout = Create("UIListLayout", {
        Parent = dropdownList,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2)
    })

    local function updateList()
        for _, child in ipairs(dropdownList:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end

        for _, value in ipairs(element._values) do
            local item = Create("TextButton", {
                Parent = dropdownList,
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                Text = "",
                ZIndex = 11
            })

            local label = CreateText("TextLabel", value, item)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.TextColor3 = _theme.Text
            label.TextSize = 13
            label.Font = Enum.Font.Gotham
            label.Size = UDim2.new(0.9, 0, 1, 0)
            label.Position = UDim2.new(0.05, 0, 0, 0)

            local check = Create("Frame", {
                Parent = item,
                Size = UDim2.new(0.1, 0, 0.6, 0),
                Position = UDim2.new(0.9, 0, 0.2, 0),
                BackgroundColor3 = _theme.Accent,
                BackgroundTransparency = 0.7,
                BorderSizePixel = 0,
                Visible = element._multi and table.find(element._selected, value) ~= nil or (not element._multi and element._selected[1] == value)
            })
            Create("UICorner", {
                Parent = check,
                CornerRadius = UDim.new(0.2, 0)
            })

            item.MouseButton1Click:Connect(function()
                if element._multi then
                    local idx = table.find(element._selected, value)
                    if idx then
                        table.remove(element._selected, idx)
                    else
                        table.insert(element._selected, value)
                    end
                else
                    element._selected = {value}
                    selectedText.Text = value
                    dropdownList.Visible = false
                end
                updateList()
                if config.Callback then
                    config.Callback(element._multi and element._selected or element._selected[1])
                end
            end)
        end
    end

    if element._multi then
        element._selected = {}
    else
        element._selected = {element._default}
    end

    local function toggleDropdown()
        dropdownList.Visible = not dropdownList.Visible
        if dropdownList.Visible then
            updateList()
            local count = #element._values
            local height = math.min(count * 22, 120)
            dropdownList.Size = UDim2.new(1, 0, 0, height)
        end
    end

    dropdownFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            toggleDropdown()
        end
    end)

    element._frame = frame

    table.insert(self._elements, element)
    self._updateHeight()

    return element
end

function Section:AddInput(config)
    local element = {}
    element._config = config or {}
    element._section = self
    element._value = config.Default or ""

    local frame = Create("Frame", {
        Name = "Input_" .. (#self._elements + 1),
        Parent = self._elementContainer,
        Size = UDim2.new(1, 0, 0, 25),
        BackgroundTransparency = 1,
        LayoutOrder = #self._elements + 1
    })

    local title = CreateText("TextLabel", config.Title or "Input", frame)
    title.Size = UDim2.new(0.4, 0, 1, 0)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextColor3 = _theme.Text
    title.TextSize = 13
    title.Font = Enum.Font.Gotham

    local inputFrame = Create("Frame", {
        Parent = frame,
        Size = UDim2.new(0.5, 0, 0.8, 0),
        Position = UDim2.new(0.45, 0, 0.1, 0),
        BackgroundColor3 = _theme.Secondary,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0
    })
    Create("UICorner", {
        Parent = inputFrame,
        CornerRadius = UDim.new(0.3, 0)
    })
    Create("UIStroke", {
        Parent = inputFrame,
        Color = _theme.Border,
        Thickness = 1.5,
        Transparency = 0.7
    })

    local textBox = Create("TextBox", {
        Parent = inputFrame,
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = element._value,
        PlaceholderText = config.Placeholder or "Type here...",
        TextColor3 = _theme.Text,
        PlaceholderColor3 = _theme.SubText,
        TextSize = 13,
        Font = Enum.Font.Gotham,
        ClearTextOnFocus = false,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center
    })

    textBox:GetPropertyChangedSignal("Text"):Connect(function()
        element._value = textBox.Text
        if config.Callback then
            config.Callback(element._value)
        end
    end)

    element._frame = frame
    element._textBox = textBox

    table.insert(self._elements, element)
    self._updateHeight()

    return element
end

function Section:AddButton(config)
    local element = {}
    element._config = config or {}
    element._section = self

    local frame = Create("Frame", {
        Name = "Button_" .. (#self._elements + 1),
        Parent = self._elementContainer,
        Size = UDim2.new(1, 0, 0, 25),
        BackgroundTransparency = 1,
        LayoutOrder = #self._elements + 1
    })

    local button = Create("TextButton", {
        Parent = frame,
        Size = UDim2.new(0.3, 0, 0.9, 0),
        Position = UDim2.new(0.35, 0, 0.05, 0),
        BackgroundColor3 = _theme.Secondary,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Text = config.Title or "Button",
        TextColor3 = _theme.Text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        ZIndex = 4
    })
    Create("UICorner", {
        Parent = button,
        CornerRadius = UDim.new(0.3, 0)
    })

    local hover = Create("Frame", {
        Parent = button,
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = _theme.Accent,
        BackgroundTransparency = 0.95,
        BorderSizePixel = 0
    })
    Create("UICorner", {
        Parent = hover,
        CornerRadius = UDim.new(0.3, 0)
    })

    button.MouseEnter:Connect(function()
        hover.BackgroundTransparency = 0.85
    end)

    button.MouseLeave:Connect(function()
        hover.BackgroundTransparency = 0.95
    end)

    button.MouseButton1Click:Connect(function()
        if config.Callback then
            config.Callback()
        end
    end)

    element._frame = frame

    table.insert(self._elements, element)
    self._updateHeight()

    return element
end

function Section:AddButtonGroup(config)
    local element = {}
    element._config = config or {}
    element._section = self

    local frame = Create("Frame", {
        Name = "ButtonGroup_" .. (#self._elements + 1),
        Parent = self._elementContainer,
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundTransparency = 1,
        LayoutOrder = #self._elements + 1
    })

    local title = CreateText("TextLabel", config.Title or "Actions", frame)
    title.Size = UDim2.new(0.4, 0, 0.5, 0)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextColor3 = _theme.Text
    title.TextSize = 13
    title.Font = Enum.Font.Gotham

    local groupFrame = Create("Frame", {
        Parent = frame,
        Size = UDim2.new(0.55, 0, 0.6, 0),
        Position = UDim2.new(0.42, 0, 0.25, 0),
        BackgroundTransparency = 1
    })

    local layout = Create("UIListLayout", {
        Parent = groupFrame,
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 5)
    })

    for i, btnConfig in ipairs(config.Buttons or {}) do
        local button = Create("TextButton", {
            Parent = groupFrame,
            Size = UDim2.new(0, 50, 1, 0),
            BackgroundColor3 = _theme.Accent,
            BackgroundTransparency = 0.3,
            BorderSizePixel = 0,
            Text = btnConfig.Title or "Button",
            TextColor3 = _theme.Text,
            TextSize = 12,
            Font = Enum.Font.GothamBold
        })
        Create("UICorner", {
            Parent = button,
            CornerRadius = UDim.new(0.2, 0)
        })

        button.MouseButton1Click:Connect(function()
            if btnConfig.Callback then
                btnConfig.Callback()
            end
        end)
    end

    element._frame = frame

    table.insert(self._elements, element)
    self._updateHeight()

    return element
end

function Section:AddLabel(config)
    local element = {}
    element._config = config or {}
    element._section = self

    local frame = Create("Frame", {
        Name = "Label_" .. (#self._elements + 1),
        Parent = self._elementContainer,
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        LayoutOrder = #self._elements + 1
    })

    local label = CreateText("TextLabel", config.Title or "Label", frame)
    label.TextXAlignment = config.Side == "Right" and Enum.TextXAlignment.Right or Enum.TextXAlignment.Left
    label.TextColor3 = _theme.Text
    label.TextSize = 13
    label.Font = Enum.Font.Gotham

    element._frame = frame

    table.insert(self._elements, element)
    self._updateHeight()

    return element
end

function Section:AddParagraph(config)
    local element = {}
    element._config = config or {}
    element._section = self

    local frame = Create("Frame", {
        Name = "Paragraph_" .. (#self._elements + 1),
        Parent = self._elementContainer,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        LayoutOrder = #self._elements + 1,
        ClipsDescendants = true
    })

    local label = CreateText("TextLabel", config.Title or "Paragraph", frame)
    label.TextXAlignment = config.Side == "Right" and Enum.TextXAlignment.Right or Enum.TextXAlignment.Left
    label.TextColor3 = _theme.Text
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextWrapped = true
    label.Size = UDim2.new(1, 0, 1, 0)

    element._frame = frame

    table.insert(self._elements, element)
    self._updateHeight()

    return element
end

function Section:AddImageLabel(config)
    local element = {}
    element._config = config or {}
    element._section = self

    local frame = Create("Frame", {
        Name = "ImageLabel_" .. (#self._elements + 1),
        Parent = self._elementContainer,
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundTransparency = 1,
        LayoutOrder = #self._elements + 1
    })

    local image = Create("ImageLabel", {
        Parent = frame,
        Size = UDim2.new(0, 50, 0, 50),
        Position = UDim2.new(0.5, -25, 0, 0),
        BackgroundTransparency = 1,
        Image = config.Image or "rbxassetid://112485471724320",
        ScaleType = Enum.ScaleType.Fit
    })

    local label = CreateText("TextLabel", config.Title or "Image", frame)
    label.Position = UDim2.new(0, 0, 0, 50)
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextColor3 = _theme.SubText
    label.TextSize = 12
    label.Font = Enum.Font.Gotham

    element._frame = frame

    table.insert(self._elements, element)
    self._updateHeight()

    return element
end

function Section:AddSelector(config)
    local element = {}
    element._config = config or {}
    element._section = self

    local frame = Create("Frame", {
        Name = "Selector_" .. (#self._elements + 1),
        Parent = self._elementContainer,
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundTransparency = 1,
        LayoutOrder = #self._elements + 1,
        ClipsDescendants = true
    })

    local title = CreateText("TextLabel", config.Title or "Select", frame)
    title.Size = UDim2.new(1, 0, 0.2, 0)
    title.Position = UDim2.new(0.02, 0, 0, 0)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextColor3 = _theme.Text
    title.TextSize = 14
    title.Font = Enum.Font.GothamBold

    local scroll = Create("ScrollingFrame", {
        Parent = frame,
        Size = UDim2.new(1, 0, 0.7, 0),
        Position = UDim2.new(0, 0, 0.3, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 0,
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    })

    local layout = Create("UIListLayout", {
        Parent = scroll,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2)
    })

    for i, value in ipairs(config.Values or {}) do
        local btn = Create("TextButton", {
            Parent = scroll,
            Size = UDim2.new(1, 0, 0, 20),
            BackgroundTransparency = 1,
            Text = "",
            LayoutOrder = i
        })

        local label = CreateText("TextLabel", value, btn)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextColor3 = _theme.Text
        label.TextSize = 13
        label.Font = Enum.Font.Gotham

        btn.MouseButton1Click:Connect(function()
            if config.Callback then
                config.Callback(value)
            end
        end)
    end

    element._frame = frame

    table.insert(self._elements, element)
    self._updateHeight()

    return element
end

function Section:AddColorPicker(config)
    local element = {}
    element._config = config or {}
    element._section = self
    element._value = config.Default or Color3.fromRGB(255, 255, 255)

    local frame = Create("Frame", {
        Name = "ColorPicker_" .. (#self._elements + 1),
        Parent = self._elementContainer,
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        LayoutOrder = #self._elements + 1
    })

    local title = CreateText("TextLabel", config.Title or "Color", frame)
    title.Size = UDim2.new(0.6, 0, 1, 0)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextColor3 = _theme.Text
    title.TextSize = 13
    title.Font = Enum.Font.Gotham

    local colorDisplay = Create("Frame", {
        Parent = frame,
        Size = UDim2.new(0.08, 0, 0.7, 0),
        Position = UDim2.new(0.62, 0, 0.15, 0),
        BackgroundColor3 = element._value,
        BorderSizePixel = 1,
        BorderColor3 = _theme.Border,
        ZIndex = 2
    })
    Create("UICorner", {
        Parent = colorDisplay,
        CornerRadius = UDim.new(0.2, 0)
    })

    local pickerFrame = Create("Frame", {
        Parent = frame,
        Size = UDim2.new(0.3, 0, 0, 150),
        Position = UDim2.new(0.7, 0, 1, 0),
        BackgroundColor3 = _theme.Secondary,
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 10,
        ClipsDescendants = true
    })
    Create("UICorner", {
        Parent = pickerFrame,
        CornerRadius = UDim.new(0.1, 0)
    })
    Create("UIStroke", {
        Parent = pickerFrame,
        Color = _theme.Border,
        Thickness = 1.5,
        Transparency = 0.5
    })

    local hueSlider = Create("Frame", {
        Parent = pickerFrame,
        Size = UDim2.new(0.8, 0, 0.15, 0),
        Position = UDim2.new(0.1, 0, 0.05, 0),
        BackgroundColor3 = _theme.SliderBackground,
        BackgroundTransparency = 0.8,
        BorderSizePixel = 0
    })
    Create("UICorner", {
        Parent = hueSlider,
        CornerRadius = UDim.new(1, 5)
    })

    local hueGradient = Create("UIGradient", {
        Parent = hueSlider,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
        }),
        Rotation = 0
    })

    local hueFill = Create("Frame", {
        Parent = hueSlider,
        Size = UDim2.new(0.5, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = _theme.Accent,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0
    })
    Create("UICorner", {
        Parent = hueFill,
        CornerRadius = UDim.new(1, 5)
    })

    local satSlider = Create("Frame", {
        Parent = pickerFrame,
        Size = UDim2.new(0.8, 0, 0.15, 0),
        Position = UDim2.new(0.1, 0, 0.25, 0),
        BackgroundColor3 = _theme.SliderBackground,
        BackgroundTransparency = 0.8,
        BorderSizePixel = 0
    })
    Create("UICorner", {
        Parent = satSlider,
        CornerRadius = UDim.new(1, 5)
    })
    local satFill = Create("Frame", {
        Parent = satSlider,
        Size = UDim2.new(0.5, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = _theme.Accent,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0
    })
    Create("UICorner", {
        Parent = satFill,
        CornerRadius = UDim.new(1, 5)
    })

    local valSlider = Create("Frame", {
        Parent = pickerFrame,
        Size = UDim2.new(0.8, 0, 0.15, 0),
        Position = UDim2.new(0.1, 0, 0.45, 0),
        BackgroundColor3 = _theme.SliderBackground,
        BackgroundTransparency = 0.8,
        BorderSizePixel = 0
    })
    Create("UICorner", {
        Parent = valSlider,
        CornerRadius = UDim.new(1, 5)
    })
    local valFill = Create("Frame", {
        Parent = valSlider,
        Size = UDim2.new(0.5, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = _theme.Accent,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0
    })
    Create("UICorner", {
        Parent = valFill,
        CornerRadius = UDim.new(1, 5)
    })

    local function updateColor()
        local h, s, v = element._value:ToHSV()
        hueFill.Size = UDim2.new(h, 0, 1, 0)
        satFill.Size = UDim2.new(s, 0, 1, 0)
        valFill.Size = UDim2.new(v, 0, 1, 0)
        colorDisplay.BackgroundColor3 = element._value
    end

    local function setupSlider(slider, fill, callback)
        local dragging = false
        local button = Create("TextButton", {
            Parent = slider,
            Size = UDim2.new(1, 0, 3, 0),
            Position = UDim2.new(0, 0, -1, 0),
            BackgroundTransparency = 1,
            Text = "",
            ZIndex = 2
        })

        button.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)

        button.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)

        button.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local scale = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
                callback(scale)
                updateColor()
                if config.Callback then
                    config.Callback(element._value)
                end
            end
        end)
    end

    setupSlider(hueSlider, hueFill, function(scale)
        local r, g, b = Color3.fromHSV(scale, 0.5, 0.5):ToRGB()
        element._value = Color3.fromRGB(r, g, b)
    end)

    setupSlider(satSlider, satFill, function(scale)
        local h, s, v = element._value:ToHSV()
        element._value = Color3.fromHSV(h, scale, v)
    end)

    setupSlider(valSlider, valFill, function(scale)
        local h, s, v = element._value:ToHSV()
        element._value = Color3.fromHSV(h, s, scale)
    end)

    colorDisplay.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            pickerFrame.Visible = not pickerFrame.Visible
        end
    end)

    element._frame = frame
    element._setValue = function(val)
        element._value = val
        updateColor()
        if config.Callback then
            config.Callback(val)
        end
    end

    updateColor()

    table.insert(self._elements, element)
    self._updateHeight()

    return element
end

function Library:Notify(config)
    local title = config.Title or "Notification"
    local message = config.Content or ""
    local image = config.Image or ""
    local duration = config.Duration or 5

    local screenGui = self._windows[1] and self._windows[1]._screenGui
    if not screenGui then
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "LonelyLib_Notify"
        screenGui.ResetOnSpawn = false
    end

    local zone = screenGui:FindFirstChild("NOTIFICATION_ZONE")
    if not zone then
        zone = Create("Frame", {
            Name = "NOTIFICATION_ZONE",
            Parent = screenGui,
            Size = UDim2.new(0.2134149968624115, 0, 1, 0),
            Position = UDim2.new(1, 0, 1, 0),
            AnchorPoint = Vector2.new(1, 1),
            BackgroundColor3 = Color3.new(0, 0, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            ZIndex = 1000
        })
        local layout = Create("UIListLayout", {
            Parent = zone,
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0, 5)
        })
        Create("UIAspectRatioConstraint", {
            Parent = zone,
            AspectRatio = 0.4247570037841797
        })
    end

    local noti = Create("Frame", {
        Parent = zone,
        Size = UDim2.new(1, 0, 0.17389200627803802, 0),
        BackgroundColor3 = Color3.fromRGB(85, 255, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0
    })

    local main = Create("CanvasGroup", {
        Parent = noti,
        Size = UDim2.new(0.9430000185966492, 0, 0.8989049792289734, 0),
        Position = UDim2.new(0, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Color3.fromRGB(24, 24, 24),
        BackgroundTransparency = 0.25,
        BorderSizePixel = 0,
        ZIndex = 2
    })
    Create("UICorner", {
        Parent = main,
        CornerRadius = UDim.new(0.1, 0)
    })

    if image and image ~= "" then
        local icon = Create("ImageLabel", {
            Parent = main,
            Size = UDim2.new(0, 40, 0, 40),
            Position = UDim2.new(0.05, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundTransparency = 1,
            Image = image,
            ScaleType = Enum.ScaleType.Fit
        })
    end

    local titleLabel = CreateText("TextLabel", title, main)
    titleLabel.Position = UDim2.new(0.15, 0, 0.15, 0)
    titleLabel.Size = UDim2.new(0.8, 0, 0.35, 0)
    titleLabel.TextColor3 = _theme.Text
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local messageLabel = CreateText("TextLabel", message, main)
    messageLabel.Position = UDim2.new(0.15, 0, 0.55, 0)
    messageLabel.Size = UDim2.new(0.8, 0, 0.35, 0)
    messageLabel.TextColor3 = _theme.SubText
    messageLabel.TextSize = 13
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextWrapped = true

    task.delay(duration, function()
        noti:Destroy()
    end)

    return noti
end

function Library:AddWindow(config)
    local win = Window.new(config)
    table.insert(self._windows, win)
    return win
end

return Library
