-- LonelyLib.lua
local Library = {}
local Themes = {
    Accent = Color3.fromRGB(248, 4, 46),
    Background = Color3.fromRGB(24, 24, 24),
    BackgroundDark = Color3.fromRGB(20, 20, 20),
    BackgroundLight = Color3.fromRGB(30, 30, 30),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(180, 180, 180),
    Border = Color3.fromRGB(255, 255, 255),
    Button = Color3.fromRGB(248, 4, 46),
    ButtonText = Color3.fromRGB(255, 255, 255),
    ToggleOn = Color3.fromRGB(248, 4, 46),
    ToggleOff = Color3.fromRGB(100, 100, 100),
}

local function createUIElement(parent, className, properties)
    local obj = Instance.new(className)
    for k, v in pairs(properties) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local function createCorner(parent, radius)
    if type(radius) == "number" then
        radius = UDim.new(0, radius)
    end
    createUIElement(parent, "UICorner", {
        BottomLeftRadius = radius,
        BottomRightRadius = radius,
        TopLeftRadius = radius,
        TopRightRadius = radius,
    })
end

local function createStroke(parent, color, thickness, transparency)
    createUIElement(parent, "UIStroke", {
        Color = color or Color3.new(1,1,1),
        Thickness = thickness or 1,
        Transparency = transparency or 0,
    })
end

local function createListLayout(parent, padding, sortOrder, fillDirection, horizontalAlignment, verticalAlignment)
    createUIElement(parent, "UIListLayout", {
        Padding = padding or UDim.new(0, 0),
        SortOrder = sortOrder or Enum.SortOrder.LayoutOrder,
        FillDirection = fillDirection or Enum.FillDirection.Vertical,
        HorizontalAlignment = horizontalAlignment or Enum.HorizontalAlignment.Center,
        VerticalAlignment = verticalAlignment or Enum.VerticalAlignment.Top,
    })
end

local function createGridLayout(parent, cellSize, cellPadding, sortOrder)
    createUIElement(parent, "UIGridLayout", {
        CellSize = cellSize or UDim2.new(0.475, 0, 0.175, 0),
        CellPadding = cellPadding or UDim2.new(0.0325, 0, 0.03, 0),
        SortOrder = sortOrder or Enum.SortOrder.LayoutOrder,
    })
end

local Window = {}
Window.__index = Window
Window._tabs = {}
Window._tabObjects = {}

function Library:CreateWindow(options)
    options = options or {}
    local screenGui = createUIElement(nil, "ScreenGui", {
        Name = "LonelyHub",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Enabled = true,
    })
    screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

    local mainFrame = createUIElement(screenGui, "CanvasGroup", {
        Name = "MAIN_UI",
        BackgroundColor3 = Color3.fromRGB(24, 24, 24),
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0.4678, 15, 0.6485, 15),
        ZIndex = 999,
        GroupTransparency = 0,
    })
    createCorner(mainFrame, UDim.new(0.075, 0))
    createUIElement(mainFrame, "UIAspectRatioConstraint", { AspectRatio = 1.50464 })

    local bgGrad = createUIElement(mainFrame, "Frame", {
        Name = "GRADIENT",
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1,0,1,0),
        ZIndex = 0,
    })
    createUIElement(bgGrad, "UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(26, 26, 26)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40)),
        }),
        Rotation = -90,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.9),
            NumberSequenceKeypoint.new(1, 0.9),
        }),
    })
    createUIElement(bgGrad, "ImageLabel", {
        Name = "BACKGROUND_PATTERN",
        Image = "rbxassetid://2151741365",
        ImageTransparency = 0.6,
        ScaleType = Enum.ScaleType.Tile,
        TileSize = UDim2.new(0, 250, 0, 250),
        SliceCenter = Rect.new(0, 256, 0, 256),
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        Size = UDim2.new(1,0,1,0),
        ZIndex = 0,
    })
    createUIElement(bgGrad, "UIStroke", {
        Color = Color3.new(1,1,1),
        Thickness = 2.5,
        Transparency = 0.5,
    })

    local topBar = createUIElement(mainFrame, "Frame", {
        Name = "TOP_BAR",
        BackgroundColor3 = Color3.fromRGB(24, 24, 24),
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, -0.003, 0),
        Size = UDim2.new(0.999, 0, 0.17, 0),
        ZIndex = 4,
        ClipsDescendants = false,
    })
    createUIElement(topBar, "ImageLabel", {
        Name = "BACKGROUND_PATTERN",
        Image = "rbxassetid://2151741365",
        ImageTransparency = 0.6,
        ScaleType = Enum.ScaleType.Tile,
        TileSize = UDim2.new(0, 250, 0, 250),
        SliceCenter = Rect.new(0, 256, 0, 256),
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        Size = UDim2.new(1,0,1,0),
        ZIndex = 0,
    })

    local decoration = createUIElement(topBar, "TextLabel", {
        Name = "DECORATION",
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0.349, 0, 0.5229, 0),
        Size = UDim2.new(0.2983, 0, 0.2955, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Font = Enum.Font.SourceSans,
        Text = [[>>  <font color="#f8042e">>></font>  >>  <font color="#f8042e">>></font>  >>]],
        TextColor3 = Color3.new(1,1,1),
        TextScaled = true,
        TextWrapped = true,
        RichText = true,
        ZIndex = 2,
    })

    local logo = createUIElement(topBar, "ImageLabel", {
        Name = "HUB_LOGO",
        Image = options.Logo or "rbxassetid://16073594682",
        ScaleType = Enum.ScaleType.Fit,
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0.0551, 0, 0.1826, 0),
        Size = UDim2.new(0.1312, 0, 0.7083, 0),
        ZIndex = 2,
    })

    local topHome = createUIElement(topBar, "TextButton", {
        Name = "TOP_HOME",
        Active = true,
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5566, 0, 0.5, 0),
        Size = UDim2.new(0.1475, 0, 0.5981, 0),
        ZIndex = 2,
        Text = "",
        AutoButtonColor = false,
    })
    createUIElement(topHome, "TextLabel", {
        Name = "Title",
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, 0, 0.6, 0),
        Font = Enum.Font.SourceSans,
        Text = "Home",
        TextColor3 = Color3.fromRGB(255, 51, 51),
        TextScaled = true,
        TextWrapped = true,
        ZIndex = 2,
    })

    local topPages = createUIElement(topBar, "TextButton", {
        Name = "TOP_PAGES",
        Active = true,
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.7125, 0, 0.5, 0),
        Size = UDim2.new(0.1475, 0, 0.5981, 0),
        ZIndex = 2,
        Text = "",
        AutoButtonColor = false,
    })
    createUIElement(topPages, "TextLabel", {
        Name = "Title",
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, 0, 0.6, 0),
        Font = Enum.Font.SourceSans,
        Text = "Pages",
        TextColor3 = Color3.new(1,1,1),
        TextScaled = true,
        TextTransparency = 0.5,
        TextWrapped = true,
        ZIndex = 2,
    })

    local topCredits = createUIElement(topBar, "TextButton", {
        Name = "TOP_CREDITS",
        Active = true,
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.8683, 0, 0.5, 0),
        Size = UDim2.new(0.1475, 0, 0.5981, 0),
        ZIndex = 2,
        Text = "",
        AutoButtonColor = false,
    })
    createUIElement(topCredits, "TextLabel", {
        Name = "Title",
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, 0, 0.6, 0),
        Font = Enum.Font.SourceSans,
        Text = "Credits",
        TextColor3 = Color3.new(1,1,1),
        TextScaled = true,
        TextTransparency = 0.5,
        TextWrapped = true,
        ZIndex = 2,
    })

    local splitScreen = createUIElement(mainFrame, "Frame", {
        Name = "SplitScreen",
        BackgroundColor3 = Color3.new(1,1,1),
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0.005, 0, 0.9, 0),
        ZIndex = 0,
    })
    createUIElement(splitScreen, "UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(16, 16, 16)),
            ColorSequenceKeypoint.new(0.1468, Color3.fromRGB(34, 23, 23)),
            ColorSequenceKeypoint.new(0.563, Color3.fromRGB(156, 3, 31)),
            ColorSequenceKeypoint.new(0.9188, Color3.fromRGB(33, 23, 25)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 15, 17)),
        }),
        Rotation = 90,
    })

    local mainZones = createUIElement(mainFrame, "Frame", {
        Name = "MAIN_ZONES",
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1,0,1,0),
        ZIndex = 1,
    })

    local pagesTab = createUIElement(mainZones, "Frame", {
        Name = "PAGES_TAB",
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5897, 0),
        Size = UDim2.new(1,0,1,0),
        ZIndex = 1,
        LayoutOrder = 1,
    })

    local anchor = createUIElement(pagesTab, "Frame", {
        Name = "ANCHOR",
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, -1.5, 0),
        Size = UDim2.new(1,0,1,0),
        LayoutOrder = 1,
    })
    createListLayout(anchor, UDim.new(0,0), Enum.SortOrder.LayoutOrder, Enum.FillDirection.Vertical, Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Top)

    local configPages = createUIElement(anchor, "Frame", {
        Name = "CONFIG_PAGES",
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.6576, 0),
        Size = UDim2.new(1,0,1,0),
        LayoutOrder = 2,
    })

    local miniPages = createUIElement(anchor, "Frame", {
        Name = "MINI_PAGES",
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.6576, 0),
        Size = UDim2.new(1,0,1,0),
        LayoutOrder = 1,
    })

    local homeTab = createUIElement(anchor, "Frame", {
        Name = "HOME_TAB",
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, -2, 0),
        Size = UDim2.new(1,0,1,0),
        Visible = false,
    })

    local creditsTab = createUIElement(anchor, "Frame", {
        Name = "CREDITS_TAB",
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, -2, 0),
        Size = UDim2.new(1,0,1,0),
        LayoutOrder = 2,
        Visible = false,
    })

    local homeUpper = createUIElement(homeTab, "Frame", {
        Name = "Upper",
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1,0,1,0),
    })

    local updateBanner = createUIElement(homeUpper, "ImageLabel", {
        Name = "UPDATE_BANNER1",
        Image = options.Thumbnail or "rbxassetid://16171568093",
        ScaleType = Enum.ScaleType.Fit,
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0.4676, 0, 0.155, 0),
        Size = UDim2.new(0.4831, 0, 0.5338, 0),
        ZIndex = 1,
    })

    local header = createUIElement(homeUpper, "TextLabel", {
        Name = "HEADER",
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.2255, 0, 0.2863, 0),
        Size = UDim2.new(0.3408, 0, 0.2333, 0),
        Font = Enum.Font.SourceSans,
        Text = options.Title or [[WELCOME TO
<font color="#f8042e">BEST FREE</font>
BLOX FRUIT HUB]],
        TextColor3 = Color3.new(1,1,1),
        TextScaled = true,
        TextWrapped = true,
        RichText = true,
        LineHeight = 0.8,
        ZIndex = 1,
    })

    local title1 = createUIElement(homeUpper, "TextLabel", {
        Name = "TITLE1",
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.2478, 0, 0.4853, 0),
        Size = UDim2.new(0.3855, 0, 0.1647, 0),
        Font = Enum.Font.SourceSans,
        Text = options.Description or [[Thanks for using our services. 
We are commited to bring greatest 
experience to users !]],
        TextColor3 = Color3.new(1,1,1),
        TextScaled = true,
        TextWrapped = true,
        RichText = true,
        ZIndex = 1,
    })

    local socialsButtons = createUIElement(homeUpper, "Frame", {
        Name = "SOCIALS_BUTTONS",
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0.0551, 0, 0.5768, 0),
        Size = UDim2.new(0.3855, 0, 0.0786, 0),
    })
    createListLayout(socialsButtons, UDim.new(0.05,0), Enum.SortOrder.LayoutOrder, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Top)

    local social1 = createUIElement(socialsButtons, "ImageButton", {
        Name = "1",
        Image = "rbxassetid://16171891828",
        ImageColor3 = Themes.Accent,
        ScaleType = Enum.ScaleType.Fit,
        Active = false,
        BackgroundColor3 = Color3.fromRGB(255, 51, 51),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.0695, 0, 0.5, 0),
        Size = UDim2.new(0.139, 0, 0.909, 0),
        ZIndex = 1,
    })
    createUIElement(social1, "ImageLabel", {
        Name = "Hover",
        Image = "rbxassetid://16171994145",
        ImageColor3 = Themes.Accent,
        ImageTransparency = 1,
        ScaleType = Enum.ScaleType.Fit,
        BackgroundColor3 = Color3.fromRGB(255, 51, 51),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(2.5, 0, 2.5, 0),
        ZIndex = 1,
    })

    local social2 = createUIElement(socialsButtons, "ImageButton", {
        Name = "2",
        Image = "rbxassetid://16171897995",
        ImageColor3 = Themes.Accent,
        ScaleType = Enum.ScaleType.Fit,
        Active = false,
        BackgroundColor3 = Color3.fromRGB(255, 51, 51),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.4749, 0, 0.3161, 0),
        Size = UDim2.new(0.139, 0, 0.909, 0),
        ZIndex = 1,
    })
    createUIElement(social2, "ImageLabel", {
        Name = "Hover",
        Image = "rbxassetid://16171994145",
        ImageColor3 = Themes.Accent,
        ImageTransparency = 1,
        ScaleType = Enum.ScaleType.Fit,
        BackgroundColor3 = Color3.fromRGB(255, 51, 51),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(2.5, 0, 2.5, 0),
        ZIndex = 1,
    })

    local social3 = createUIElement(socialsButtons, "ImageButton", {
        Name = "3",
        Image = "rbxassetid://16171900314",
        ImageColor3 = Themes.Accent,
        ScaleType = Enum.ScaleType.Fit,
        Active = false,
        BackgroundColor3 = Color3.fromRGB(255, 51, 51),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.4475, 0, 0.5, 0),
        Size = UDim2.new(0.13, 0, 0.8, 0),
        ZIndex = 1,
    })
    createUIElement(social3, "ImageLabel", {
        Name = "Hover",
        Image = "rbxassetid://16171994145",
        ImageColor3 = Themes.Accent,
        ImageTransparency = 1,
        ScaleType = Enum.ScaleType.Fit,
        BackgroundColor3 = Color3.fromRGB(255, 51, 51),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(2.5, 0, 2.5, 0),
        ZIndex = 1,
    })

    local homeFunctions = createUIElement(homeUpper, "Frame", {
        Name = "Functions",
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0.001, 0, 0.672, 0),
        Size = UDim2.new(1, 0, 0.2845, 0),
    })

    local homePager = createUIElement(homeFunctions, "Frame", {
        Name = "HOME_PAGER",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Size = UDim2.new(1, 0, 1, 0),
    })

    local pagesHolder = createUIElement(homePager, "Frame", {
        Name = "PAGES_HOLDER",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(2, 0, 1, 0),
    })

    local pageShortcuts = createUIElement(pagesHolder, "Frame", {
        Name = "PAGE_SHORTCUTS",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(0.5, 0, 1, 0),
    })
    createListLayout(pageShortcuts, UDim.new(0.02,0), Enum.SortOrder.LayoutOrder, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Top)

    local creditsUpper = createUIElement(creditsTab, "Frame", {
        Name = "Upper",
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1,0,1,0),
    })

    local pfp = createUIElement(creditsUpper, "ImageLabel", {
        Name = "Pfp",
        Image = "rbxassetid://16165550572",
        ScaleType = Enum.ScaleType.Fit,
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0.2045, 0, 0.2146, 0),
        Size = UDim2.new(0.2297, 0, 0.2612, 0),
    })
    createCorner(pfp, UDim.new(0.075, 0))

    local invitation = createUIElement(creditsUpper, "TextLabel", {
        Name = "Invitation",
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.6217, 0, 0.2631, 0),
        Size = UDim2.new(0.3757, 0, 0.0972, 0),
        Font = Enum.Font.SourceSans,
        Text = [[JOIN OUR <font color="#f8042e">COMMUNITY</font> !]],
        TextColor3 = Color3.new(1,1,1),
        TextScaled = true,
        TextWrapped = true,
        RichText = true,
    })

    local mems = createUIElement(creditsUpper, "TextLabel", {
        Name = "Mems",
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.6217, 0, 0.3257, 0),
        Size = UDim2.new(0.3757, 0, 0.0639, 0),
        Font = Enum.Font.SourceSans,
        Text = [[<font color="#f8042e">600K+</font> MEMBERS]],
        TextColor3 = Color3.new(1,1,1),
        TextScaled = true,
        TextWrapped = true,
        RichText = true,
    })

    local copyInvite = createUIElement(creditsUpper, "TextButton", {
        Name = "Copy Invite",
        BackgroundColor3 = Color3.fromRGB(248, 4, 46),
        BorderSizePixel = 0,
        Position = UDim2.new(0.6122, 0, 0.4105, 0),
        Size = UDim2.new(0.3561, 0, 0.0782, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        AutoButtonColor = false,
        Active = false,
        Selectable = false,
        Text = "",
        ZIndex = 1,
    })
    createCorner(copyInvite, UDim.new(0.2, 0))
    createUIElement(copyInvite, "TextLabel", {
        Name = "Title",
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, 0, 0.7, 0),
        Font = Enum.Font.SourceSans,
        Text = "COPY INVITE",
        TextColor3 = Color3.new(1,1,1),
        TextScaled = true,
        TextWrapped = true,
    })
    createUIElement(copyInvite, "ImageLabel", {
        Name = "Hover",
        Image = "rbxassetid://16261022724",
        ImageColor3 = Themes.Accent,
        ImageTransparency = 1,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(205, 197, 828, 828),
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1.08, 0, 1.45, 0),
    })

    local creditsLabel = createUIElement(creditsUpper, "TextLabel", {
        Name = "Credits",
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5542, 0, 0.5679, 0),
        Size = UDim2.new(0.6458, 0, 0.132, 0),
        Font = Enum.Font.SourceSans,
        Text = [[BIG <font color="#f8042e">THANKS</font> TO OUR CONTRIBUTORS !]],
        TextColor3 = Color3.new(1,1,1),
        TextScaled = true,
        TextWrapped = true,
        RichText = true,
    })

    local contributors = createUIElement(creditsUpper, "Frame", {
        Name = "Contributors",
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1,0,1,0),
    })

    local scrollFrame = createUIElement(contributors, "ScrollingFrame", {
        Name = "ScrollFrame",
        CanvasSize = UDim2.new(0,0,1,0),
        ScrollBarImageColor3 = Color3.new(0,0,0),
        ScrollBarThickness = 0,
        Active = true,
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0.2026, 0, 0.6339, 0),
        Size = UDim2.new(0.6462, 0, 0.2874, 0),
    })
    createListLayout(scrollFrame, UDim.new(0,0), Enum.SortOrder.LayoutOrder, Enum.FillDirection.Vertical, Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Top)

    local contributor1 = createUIElement(scrollFrame, "TextLabel", {
        Name = "label",
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.6217, 0, 0.3257, 0),
        Size = UDim2.new(1, 0, 0.07, 0),
        Font = Enum.Font.SourceSans,
        Text = "👑 LongHip12 👑",
        TextColor3 = Color3.new(1,1,1),
        TextScaled = true,
        TextWrapped = true,
        RichText = true,
    })

    local contributor2 = createUIElement(scrollFrame, "TextLabel", {
        Name = "label",
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.6217, 0, 0.3257, 0),
        Size = UDim2.new(1, 0, 0.07, 0),
        Font = Enum.Font.SourceSans,
        Text = "Lonely Hub | dsc.gg/lonelyhub",
        TextColor3 = Color3.new(1,1,1),
        TextScaled = true,
        TextWrapped = true,
        RichText = true,
    })

    local returnButton = createUIElement(configPages, "TextButton", {
        Name = "RETURN_BUTTON",
        BackgroundColor3 = Color3.fromRGB(20,20,20),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Position = UDim2.new(0.8671, 0, 0.179, 0),
        Size = UDim2.new(0.078, 0, 0.1161, 0),
        ZIndex = 3,
        AutoButtonColor = false,
        Active = false,
        Selectable = false,
        Text = "",
    })
    createCorner(returnButton, UDim.new(0.3, 0))
    createUIElement(returnButton, "ImageLabel", {
        Name = "Icon",
        Image = "rbxassetid://3926305904",
        ImageRectOffset = Vector2.new(884, 364),
        ImageRectSize = Vector2.new(36, 36),
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0.7728, 0, 0.7728, 0),
        Selectable = true,
        ZIndex = 2,
        LayoutOrder = 4,
    })

    returnButton.MouseButton1Click:Connect(function()
        self:ShowHome()
    end)

    local searchBox = createUIElement(configPages, "Frame", {
        Name = "SearchBox",
        BackgroundColor3 = Color3.fromRGB(20,20,20),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Position = UDim2.new(0.055, 0, 0.179, 0),
        Size = UDim2.new(0.7867, 0, 0.1161, 0),
        ZIndex = 3,
    })
    local searchTextbox = createUIElement(searchBox, "TextBox", {
        Name = "Textbox",
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Font = Enum.Font.SourceSans,
        PlaceholderText = "SEARCH ...",
        PlaceholderColor3 = Color3.fromRGB(117,117,117),
        Text = "",
        TextColor3 = Color3.new(1,1,1),
        TextScaled = true,
        TextWrapped = true,
        RichText = true,
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.new(0.72, 0, 0.5789, 0),
        Selectable = false,
        ZIndex = 2,
    })

    local deepSearchBtn = createUIElement(searchBox, "TextButton", {
        Name = "DeepSearchBtn",
        Font = Enum.Font.Bangers,
        Text = "",
        TextColor3 = Color3.new(1,1,1),
        TextScaled = true,
        TextWrapped = true,
        AutoButtonColor = false,
        BackgroundColor3 = Color3.fromRGB(157, 2, 31),
        BackgroundTransparency = 0.25,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -4, 0.5, 0),
        Size = UDim2.new(0.26, 0, 0.72, 0),
        ZIndex = 4,
    })
    createCorner(deepSearchBtn, UDim.new(0.25, 0))
    createUIElement(deepSearchBtn, "ImageLabel", {
        Name = "Icon",
        Image = "rbxassetid://72965444708833",
        ScaleType = Enum.ScaleType.Fit,
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 4, 0.5, 0),
        Size = UDim2.new(1, 0, 1, -6),
        SizeConstraint = Enum.SizeConstraint.RelativeYY,
        ZIndex = 5,
    })
    createUIElement(deepSearchBtn, "TextLabel", {
        Name = "Label",
        Font = Enum.Font.Bangers,
        Text = "Deep Search",
        TextColor3 = Color3.new(1,1,1),
        TextScaled = true,
        TextWrapped = true,
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -4, 0.5, 0),
        Size = UDim2.new(0.72, 0, 0.6, 0),
        ZIndex = 5,
    })

    local miniConfig1 = createUIElement(configPages, "Frame", {
        Name = "MINI_1",
        BackgroundColor3 = Color3.new(0,0,0),
        BackgroundTransparency = 0.75,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Position = UDim2.new(0.0549, 0, 0.3371, 0),
        Size = UDim2.new(0.8901, 0, 0.6019, 0),
        Visible = false,
        ZIndex = 3,
        LayoutOrder = 1,
    })

    local miniConfig2 = createUIElement(configPages, "Frame", {
        Name = "MINI_2",
        BackgroundColor3 = Color3.new(0,0,0),
        BackgroundTransparency = 0.75,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Position = UDim2.new(0.0549, 0, 0.3371, 0),
        Size = UDim2.new(0.8901, 0, 0.6019, 0),
        Visible = false,
        ZIndex = 3,
        LayoutOrder = 2,
    })

    local miniConfig3 = createUIElement(configPages, "Frame", {
        Name = "MINI_9_CONFIG_3",
        BackgroundColor3 = Color3.fromRGB(0,0,0),
        BackgroundTransparency = 0.75,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Position = UDim2.new(0.0549, 0, 0.3451, 0),
        Size = UDim2.new(0.8901, 0, 0.6019, 0),
        Visible = false,
        ZIndex = 3,
        LayoutOrder = 3,
    })

    local miniConfigScroll1 = createUIElement(miniConfig1, "ScrollingFrame", {
        Name = "ScrollFrame",
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0,0,0,0),
        ScrollBarThickness = 0,
        BackgroundColor3 = Color3.new(0,0,0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = false,
        Position = UDim2.new(0.0217, 0, 0.0537, 0),
        Size = UDim2.new(0.9653, 0, 0.9463, 0),
        Selectable = false,
        ZIndex = 3,
    })
    createGridLayout(miniConfigScroll1, UDim2.new(0.475,0,0.175,0), UDim2.new(0.0325,0,0.03,0), Enum.SortOrder.LayoutOrder)

    local miniConfig2Scroll = createUIElement(miniConfig2, "ScrollingFrame", {
        Name = "ScrollFrame",
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0,0,0,0),
        ScrollBarThickness = 0,
        BackgroundColor3 = Color3.new(0,0,0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = false,
        Position = UDim2.new(0.0217, 0, 0.0537, 0),
        Size = UDim2.new(0.9653, 0, 0.9463, 0),
        Selectable = false,
        ZIndex = 3,
    })
    createGridLayout(miniConfig2Scroll, UDim2.new(0.475,0,0.175,0), UDim2.new(0.0325,0,0.03,0), Enum.SortOrder.LayoutOrder)

    local miniConfig3Scroll = createUIElement(miniConfig3, "ScrollingFrame", {
        Name = "ScrollFrame",
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0,0,0,0),
        ScrollBarThickness = 0,
        BackgroundColor3 = Color3.new(0,0,0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = false,
        Position = UDim2.new(0.0217, 0, 0.0537, 0),
        Size = UDim2.new(0.9653, 0, 0.9463, 0),
        Selectable = false,
        ZIndex = 3,
    })
    createGridLayout(miniConfig3Scroll, UDim2.new(0.475,0,0.175,0), UDim2.new(0.0325,0,0.03,0), Enum.SortOrder.LayoutOrder)

    local windowObj = setmetatable({
        _screenGui = screenGui,
        _mainFrame = mainFrame,
        _configPages = configPages,
        _miniPages = miniPages,
        _homeTab = homeTab,
        _creditsTab = creditsTab,
        _miniConfig1 = miniConfig1,
        _miniConfig2 = miniConfig2,
        _miniConfig3 = miniConfig3,
        _miniConfig1Scroll = miniConfig1Scroll,
        _miniConfig2Scroll = miniConfig2Scroll,
        _miniConfig3Scroll = miniConfig3Scroll,
        _topHome = topHome,
        _topPages = topPages,
        _topCredits = topCredits,
        _pageShortcuts = pageShortcuts,
        _social1 = social1,
        _social2 = social2,
        _social3 = social3,
        _copyInvite = copyInvite,
        _tabs = {},
        _tabObjects = {},
        _activeTab = nil,
        _homepageSet = false,
        _youtube = options.Youtube or "",
        _tiktok = options.Tiktok or "",
        _discord = options.Discord or "",
    }, Window)

    topHome.MouseButton1Click:Connect(function()
        windowObj:ShowHome()
    end)

    topCredits.MouseButton1Click:Connect(function()
        windowObj:ShowCredits()
    end)

    social1.MouseButton1Click:Connect(function()
        if windowObj._discord ~= "" then
            setclipboard(windowObj._discord)
        end
    end)

    social2.MouseButton1Click:Connect(function()
        if windowObj._youtube ~= "" then
            setclipboard(windowObj._youtube)
        end
    end)

    social3.MouseButton1Click:Connect(function()
        if windowObj._tiktok ~= "" then
            setclipboard(windowObj._tiktok)
        end
    end)

    copyInvite.MouseButton1Click:Connect(function()
        if windowObj._discord ~= "" then
            setclipboard(windowObj._discord)
        end
    end)

    topPages.MouseButton1Click:Connect(function()
        if not windowObj._homepageSet then
            print("Error: Please set homepage shortcuts first using SetHomepageShortcut")
            return
        end
        windowObj:ShowPages()
    end)

    deepSearchBtn.MouseButton1Click:Connect(function()
        local query = searchTextbox.Text
        if query == "" then
            return
        end
        for _, tab in pairs(windowObj._tabs) do
            if tab._miniConfig then
                local visible = false
                local titleLabel = tab._miniConfig:FindFirstChild("Title")
                local descLabel = tab._miniConfig:FindFirstChild("Desc")
                if titleLabel and string.lower(titleLabel.Text):find(string.lower(query)) then
                    visible = true
                end
                if descLabel and string.lower(descLabel.Text):find(string.lower(query)) then
                    visible = true
                end
                tab._miniConfig.Visible = visible
            end
        end
    end)

    return windowObj
end

function Window:ShowHome()
    self._homeTab.Visible = true
    self._creditsTab.Visible = false
    self._configPages.Visible = false
    self._miniPages.Visible = false
    for _, tab in pairs(self._tabs) do
        if tab._miniConfig then
            tab._miniConfig.Visible = false
        end
    end
end

function Window:ShowCredits()
    self._homeTab.Visible = false
    self._creditsTab.Visible = true
    self._configPages.Visible = false
    self._miniPages.Visible = false
    for _, tab in pairs(self._tabs) do
        if tab._miniConfig then
            tab._miniConfig.Visible = false
        end
    end
end

function Window:ShowPages()
    self._homeTab.Visible = false
    self._creditsTab.Visible = false
    self._configPages.Visible = true
    self._miniPages.Visible = true
end

function Window:SetHomepageShortcut(tab1, tab2, tab3)
    if not tab1 or not tab2 or not tab3 then
        print("Error: SetHomepageShortcut requires exactly 3 tabs")
        return
    end
    self._tabs = {tab1, tab2, tab3}
    self._tabObjects = {tab1, tab2, tab3}
    self._homepageSet = true

    local shortcuts = self._pageShortcuts:GetChildren()
    local shortcutIndex = 1
    for _, child in ipairs(shortcuts) do
        if child:IsA("TextButton") and child.Name == "HOMEPAGE_BUTTON" then
            local tab = self._tabs[shortcutIndex]
            if tab then
                child.MouseButton1Click:Connect(function()
                    self:SelectTab(tab)
                end)
                shortcutIndex = shortcutIndex + 1
            end
        end
    end

    self:ShowHome()
end

function Window:AddTab(options)
    options = options or {}
    local tab = {
        Title = options.Title or "Tab",
        Description = options.Description or "",
        Image = options.Image or "",
        Side = options.Side or "Left",
        _elements = {},
        _parent = self,
        _miniConfig = nil,
        _active = false,
    }
    table.insert(self._tabs, tab)
    return tab
end

function Window:SelectTab(tab)
    if not self._homepageSet then
        print("Error: Please set homepage shortcuts first using SetHomepageShortcut")
        return
    end

    self:ShowPages()

    for _, t in pairs(self._tabs) do
        if t == tab then
            t._active = true
            self._activeTab = tab
            if t._miniConfig then
                t._miniConfig.Visible = true
            end
        else
            if t._miniConfig then
                t._miniConfig.Visible = false
            end
            t._active = false
        end
    end

    self._configPages.Visible = true
    self._miniPages.Visible = true
end

function Window:CreateSectionFrame(parent, title, description, image, side)
    local frame = createUIElement(parent, "TextButton", {
        Name = "Button",
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Position = UDim2.new(0.3634, 0, 0.1283, 0),
        Size = UDim2.new(0.2906, 0, 0.2725, 0),
        LayoutOrder = #parent:GetChildren() + 1,
        AutoButtonColor = false,
        Active = false,
        Selectable = false,
        Text = "",
        ZIndex = 1,
    })
    createUIElement(frame, "UIAspectRatioConstraint", { AspectRatio = 2.915 })
    createUIElement(frame, "UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(157, 2, 31)),
            ColorSequenceKeypoint.new(0.525, Color3.fromRGB(134, 2, 31)),
            ColorSequenceKeypoint.new(0.815, Color3.fromRGB(40, 23, 24)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(24, 18, 19)),
        }),
        Rotation = -57,
    })
    createUIElement(frame, "UIStroke", {
        Color = Color3.new(1,1,1),
        Thickness = 2,
    })

    local bg = createUIElement(frame, "Frame", {
        Name = "Background",
        BackgroundColor3 = Color3.new(0,0,0),
        BackgroundTransparency = 0.6,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.3322, 0, 0.79, 0),
        Size = UDim2.new(0.6042, 0, 0.3, 0),
    })
    createCorner(bg, UDim.new(0, 20))

    local titleLabel = createUIElement(frame, "TextLabel", {
        Name = "Title",
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.3408, 0, 0.34, 0),
        Size = UDim2.new(0.587, 0, 0.6442, 0),
        Font = Enum.Font.SourceSans,
        Text = title or "Section",
        TextColor3 = Color3.new(1,1,1),
        TextScaled = true,
        TextWrapped = true,
        RichText = true,
        LineHeight = 0.8,
        ZIndex = 2,
    })

    local descLabel = createUIElement(frame, "TextLabel", {
        Name = "Desc",
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.332, 0, 0.775, 0),
        Size = UDim2.new(0.5, 0, 0.268, 0),
        Font = Enum.Font.SourceSans,
        Text = description or "",
        TextColor3 = Color3.new(1,1,1),
        TextScaled = true,
        TextWrapped = true,
        RichText = true,
        LineHeight = 0.8,
        ZIndex = 2,
    })

    local icon = createUIElement(frame, "CanvasGroup", {
        Name = "Icon",
        BackgroundColor3 = Color3.new(0,0,0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.8257, 0, 0.5, 0),
        Size = UDim2.new(0.2724, 0, 0.8152, 0),
        ZIndex = 99,
    })
    createUIElement(icon, "ImageLabel", {
        Name = "Display",
        Image = image or "rbxassetid://16126564089",
        ScaleType = Enum.ScaleType.Fit,
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1,0,1,0),
    })
    createCorner(icon, UDim.new(0, 18))

    return frame
end

function Window:AddSection(tab, options)
    options = options or {}
    local targetFrame
    if tab == self._tabs[1] then
        targetFrame = self._miniConfig1Scroll
    elseif tab == self._tabs[2] then
        targetFrame = self._miniConfig2Scroll
    elseif tab == self._tabs[3] then
        targetFrame = self._miniConfig3Scroll
    else
        return nil
    end

    local sectionFrame = self:CreateSectionFrame(targetFrame, options.Title, options.Description, options.Image, options.Side)
    tab._miniConfig = sectionFrame

    local sectionObj = {
        _frame = sectionFrame,
        _parent = self,
        _tab = tab,
        _elements = {},
    }

    sectionFrame.MouseButton1Click:Connect(function()
        self:SelectTab(tab)
    end)

    return sectionObj
end

function Window:AddToggle(section, options)
    options = options or {}
    local frame = createUIElement(section._frame, "TextButton", {
        Name = "Toggle",
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.1206, 0, 0.79, 0),
        Size = UDim2.new(0.1464, 0, 0.2676, 0),
        LayoutOrder = #section._frame:GetChildren() + 1,
        AutoButtonColor = false,
        Active = false,
        Selectable = false,
        Text = "",
        ZIndex = 2,
    })
    local holder = createUIElement(frame, "Frame", {
        Name = "Holder",
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0.8, 0, 0.6, 0),
        ZIndex = 99,
    })
    createCorner(holder, UDim.new(0, 20))
    createStroke(holder, Color3.new(1,1,1), 2, 0.75)
    local marker = createUIElement(holder, "ImageLabel", {
        Name = "Marker",
        Image = options.ToggleIcon or "rbxassetid://16284242787",
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Fit,
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.22, 0, 0.5, 0),
        Size = UDim2.new(0.5, 0, 0.8, 0),
    })
    local titleLabel = createUIElement(frame, "TextLabel", {
        Name = "Title",
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.3408, 0, 0.34, 0),
        Size = UDim2.new(0.587, 0, 0.6442, 0),
        Font = Enum.Font.SourceSans,
        Text = options.Title or "Toggle",
        TextColor3 = Color3.new(1,1,1),
        TextScaled = true,
        TextWrapped = true,
        RichText = true,
        LineHeight = 0.8,
        ZIndex = 2,
    })
    local descLabel = createUIElement(frame, "TextLabel", {
        Name = "Desc",
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.406, 0, 0.79, 0),
        Size = UDim2.new(0.3862, 0, 0.2677, 0),
        Font = Enum.Font.SourceSans,
        Text = options.Description or "",
        TextColor3 = Color3.new(1,1,1),
        TextScaled = true,
        TextWrapped = true,
        RichText = true,
        LineHeight = 0.8,
        ZIndex = 2,
    })
    local icon = createUIElement(frame, "CanvasGroup", {
        Name = "Icon",
        BackgroundColor3 = Color3.new(0,0,0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.8257, 0, 0.5, 0),
        Size = UDim2.new(0.2724, 0, 0.8152, 0),
        ZIndex = 99,
    })
    createUIElement(icon, "ImageLabel", {
        Name = "Display",
        Image = options.Image or "rbxassetid://15057692658",
        ScaleType = Enum.ScaleType.Fit,
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1,0,1,0),
    })
    createCorner(icon, UDim.new(0, 18))

    local toggleObj = {
        _frame = frame,
        _marker = marker,
        _state = options.Default or false,
        _callback = options.Callback,
        _parent = section,
    }

    frame.MouseButton1Click:Connect(function()
        toggleObj._state = not toggleObj._state
        if toggleObj._state then
            toggleObj._marker.Position = UDim2.new(0.78, 0, 0.5, 0)
        else
            toggleObj._marker.Position = UDim2.new(0.22, 0, 0.5, 0)
        end
        if toggleObj._callback then
            toggleObj._callback(toggleObj._state)
        end
    end)

    if options.Default then
        toggleObj._marker.Position = UDim2.new(0.78, 0, 0.5, 0)
    end

    return toggleObj
end

function Window:AddButton(section, options)
    options = options or {}
    local frame = createUIElement(section._frame, "TextButton", {
        Name = "Button",
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Position = UDim2.new(0.3634, 0, 0.1283, 0),
        Size = UDim2.new(0.2906, 0, 0.2725, 0),
        LayoutOrder = #section._frame:GetChildren() + 1,
        AutoButtonColor = false,
        Active = false,
        Selectable = false,
        Text = "",
        ZIndex = 1,
    })
    createUIElement(frame, "UIAspectRatioConstraint", { AspectRatio = 2.915 })
    createUIElement(frame, "UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(157, 2, 31)),
            ColorSequenceKeypoint.new(0.525, Color3.fromRGB(134, 2, 31)),
            ColorSequenceKeypoint.new(0.815, Color3.fromRGB(40, 23, 24)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(24, 18, 19)),
        }),
        Rotation = -57,
    })
    createUIElement(frame, "UIStroke", {
        Color = Color3.new(1,1,1),
        Thickness = 2,
    })
    local bg = createUIElement(frame, "Frame", {
        Name = "Background",
        BackgroundColor3 = Color3.new(0,0,0),
        BackgroundTransparency = 0.6,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.3322, 0, 0.79, 0),
        Size = UDim2.new(0.6042, 0, 0.3, 0),
    })
    createCorner(bg, UDim.new(0, 20))
    local titleLabel = createUIElement(frame, "TextLabel", {
        Name = "Title",
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.3408, 0, 0.34, 0),
        Size = UDim2.new(0.587, 0, 0.6442, 0),
        Font = Enum.Font.SourceSans,
        Text = options.Title or "Button",
        TextColor3 = Color3.new(1,1,1),
        TextScaled = true,
        TextWrapped = true,
        RichText = true,
        LineHeight = 0.8,
        ZIndex = 2,
    })
    local descLabel = createUIElement(frame, "TextLabel", {
        Name = "Desc",
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.332, 0, 0.775, 0),
        Size = UDim2.new(0.5, 0, 0.268, 0),
        Font = Enum.Font.SourceSans,
        Text = options.Description or "",
        TextColor3 = Color3.new(1,1,1),
        TextScaled = true,
        TextWrapped = true,
        RichText = true,
        LineHeight = 0.8,
        ZIndex = 2,
    })
    local icon = createUIElement(frame, "CanvasGroup", {
        Name = "Icon",
        BackgroundColor3 = Color3.new(0,0,0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.8257, 0, 0.5, 0),
        Size = UDim2.new(0.2724, 0, 0.8152, 0),
        ZIndex = 99,
    })
    createUIElement(icon, "ImageLabel", {
        Name = "Display",
        Image = options.Image or "rbxassetid://16126564089",
        ScaleType = Enum.ScaleType.Fit,
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1,0,1,0),
    })
    createCorner(icon, UDim.new(0, 18))

    local buttonObj = {
        _frame = frame,
        _callback = options.Callback,
        _parent = section,
    }

    frame.MouseButton1Click:Connect(function()
        if buttonObj._callback then
            buttonObj._callback()
        end
    end)

    return buttonObj
end

return Library
