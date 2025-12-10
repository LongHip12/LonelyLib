local SaveManager = {}
local HttpService = game:GetService("HttpService")

-- Cấu hình
local FolderName = "Lonely Hub"
local CurrentFileName = "config"
local AutoSaveEnabled = true
local AutoSaveDelay = 0.5 -- Delay trước khi lưu (tránh spam)

-- Tạo folder
if not isfolder(FolderName) then
    makefolder(FolderName)
end

-- Khởi tạo Config
if not getgenv().Config then
    getgenv().Config = {}
end

-- Biến tracking
local SaveScheduled = false
local OriginalCallbacks = {}
local IsLoading = false

-- =====================================================
-- HELPER FUNCTIONS
-- =====================================================

local function GetFilePath(fileName)
    return FolderName .. "/" .. (fileName or CurrentFileName) .. ".json"
end

local function ScheduleSave()
    if not AutoSaveEnabled or IsLoading then return end
    
    if SaveScheduled then return end
    SaveScheduled = true
    
    task.delay(AutoSaveDelay, function()
        SaveScheduled = false
        SaveManager:SaveConfig()
    end)
end

-- =====================================================
-- HOOK FUNCTIONS - TỰ ĐỘNG HOOK VÀO CONTROL
-- =====================================================

function SaveManager:HookToggle(toggleObject, name)
    if not toggleObject or not toggleObject.SetStage then return end
    
    -- Lưu callback gốc
    local originalSetStage = toggleObject.SetStage
    
    -- Override SetStage
    toggleObject.SetStage = function(self, value)
        originalSetStage(self, value)
        
        -- Chỉ lưu khi không đang load config
        if not IsLoading then
            getgenv().Config[name] = value
            ScheduleSave()
        end
    end
    
    print("[SaveManager] Hooked Toggle: " .. name)
end

function SaveManager:HookSlider(sliderObject, name)
    if not sliderObject or not sliderObject.SetValue then return end
    
    local originalSetValue = sliderObject.SetValue
    
    sliderObject.SetValue = function(self, value)
        originalSetValue(self, value)
        
        if not IsLoading then
            getgenv().Config[name] = value
            ScheduleSave()
        end
    end
    
    print("[SaveManager] Hooked Slider: " .. name)
end

function SaveManager:HookInput(inputObject, name)
    if not inputObject or not inputObject.SetValue then return end
    
    local originalSetValue = inputObject.SetValue
    
    inputObject.SetValue = function(self, value)
        originalSetValue(self, value)
        
        if not IsLoading then
            getgenv().Config[name] = value
            ScheduleSave()
        end
    end
    
    print("[SaveManager] Hooked Input: " .. name)
end

function SaveManager:HookDropdown(dropdownObject, name)
    if not dropdownObject then return end
    
    -- Dropdown có thể có rf (refresh function)
    -- Ta hook vào callback thay vì SetValue
    -- Do đó cần lưu trong callback của Dropdown
    
    print("[SaveManager] Hooked Dropdown: " .. name)
end

function SaveManager:HookKeybind(keybindObject, name)
    if not keybindObject or not keybindObject.Set then return end
    
    local originalSet = keybindObject.Set
    
    keybindObject.Set = function(self, key)
        originalSet(self, key)
        
        if not IsLoading then
            getgenv().Config[name] = key
            ScheduleSave()
        end
    end
    
    print("[SaveManager] Hooked Keybind: " .. name)
end

-- =====================================================
-- AUTO HOOK TẤT CẢ CONTROL
-- =====================================================

function SaveManager:AutoHookAll()
    if not getgenv().AllControls then
        warn("[SaveManager] AllControls not found! Run this after creating UI")
        return
    end
    
    print("[SaveManager] Auto hooking all controls...")
    
    for _, control in pairs(getgenv().AllControls) do
        local name = control.Name
        
        -- Xác định loại control và hook tương ứng
        if control.SetStage then
            -- Toggle
            self:HookToggle(control, name)
        elseif control.SetValue and control.GetValue then
            -- Slider hoặc Input
            self:HookSlider(control, name)
        elseif control.Set and control.Get then
            -- Keybind
            self:HookKeybind(control, name)
        elseif control.rf then
            -- Dropdown
            self:HookDropdown(control, name)
        end
    end
    
    print("[SaveManager] Auto hook complete!")
end

-- =====================================================
-- SAVE/LOAD FUNCTIONS
-- =====================================================

function SaveManager:SaveConfig(fileName)
    local filePath = GetFilePath(fileName)
    local success, err = pcall(function()
        local jsonString = HttpService:JSONEncode(getgenv().Config)
        writefile(filePath, jsonString)
    end)
    
    if success then
        print("[SaveManager] ✓ Config saved: " .. filePath)
    else
        warn("[SaveManager] ✗ Error saving: " .. tostring(err))
    end
end

function SaveManager:LoadConfig(fileName)
    local filePath = GetFilePath(fileName)
    
    if not isfile(filePath) then
        warn("[SaveManager] File not found: " .. filePath)
        return false
    end
    
    local success, result = pcall(function()
        local data = readfile(filePath)
        return HttpService:JSONDecode(data)
    end)
    
    if success and type(result) == "table" then
        getgenv().Config = result
        print("[SaveManager] ✓ Config loaded: " .. filePath)
        self:ApplyConfig()
        return true
    else
        warn("[SaveManager] ✗ Error loading: " .. tostring(result))
        return false
    end
end

function SaveManager:ApplyConfig()
    if not getgenv().AllControls then
        warn("[SaveManager] AllControls not found!")
        return
    end
    
    -- Đặt cờ đang load để tránh auto save
    IsLoading = true
    
    print("[SaveManager] Applying config...")
    
    for _, control in pairs(getgenv().AllControls) do
        local name = control.Name
        local value = getgenv().Config[name]
        
        if value ~= nil then
            pcall(function()
                if control.SetStage then
                    -- Toggle
                    control:SetStage(value)
                elseif control.SetValue then
                    -- Slider / Input
                    control:SetValue(value)
                elseif control.Set then
                    -- Keybind
                    control:Set(value)
                end
            end)
        end
    end
    
    -- Tắt cờ loading
    task.delay(0.5, function()
        IsLoading = false
        print("[SaveManager] ✓ Config applied")
    end)
end

-- =====================================================
-- UTILITY FUNCTIONS
-- =====================================================

function SaveManager:SetAutoSave(enabled)
    AutoSaveEnabled = enabled
    print("[SaveManager] Auto save: " .. (enabled and "ON" or "OFF"))
end

function SaveManager:SetFileName(fileName)
    if not fileName or fileName == "" then
        warn("[SaveManager] Invalid file name!")
        return false
    end
    
    CurrentFileName = fileName
    print("[SaveManager] ✓ File name set to: " .. CurrentFileName)
    return true
end

function SaveManager:GetFileName()
    return CurrentFileName
end

function SaveManager:ListConfigs()
    local configs = {}
    
    if not isfolder(FolderName) then
        return configs
    end
    
    for _, file in ipairs(listfiles(FolderName)) do
        if file:match("%.json$") then
            local name = file:match("([^/\\]+)%.json$")
            table.insert(configs, name)
        end
    end
    
    return configs
end

function SaveManager:DeleteConfig(fileName)
    local filePath = GetFilePath(fileName)
    
    if isfile(filePath) then
        delfile(filePath)
        print("[SaveManager] ✓ Config deleted: " .. fileName)
        return true
    else
        warn("[SaveManager] File not found: " .. fileName)
        return false
    end
end

function SaveManager:ResetConfig()
    getgenv().Config = {}
    self:SaveConfig()
    self:ApplyConfig()
    print("[SaveManager] ✓ Config reset")
end

function SaveManager:CopyConfigString()
    local configStr = HttpService:JSONEncode(getgenv().Config)
    
    if setclipboard then
        setclipboard(configStr)
        print("[SaveManager] ✓ Config copied to clipboard")
    else
        print("[SaveManager] Config string:")
        print(configStr)
    end
    
    return configStr
end

function SaveManager:ImportConfig(configString)
    local success, result = pcall(function()
        return HttpService:JSONDecode(configString)
    end)
    
    if success and type(result) == "table" then
        getgenv().Config = result
        self:ApplyConfig()
        self:SaveConfig()
        print("[SaveManager] ✓ Config imported")
        return true
    else
        warn("[SaveManager] ✗ Invalid config string")
        return false
    end
end

function SaveManager:PrintConfig()
    print("=== Current Config ===")
    for k, v in pairs(getgenv().Config) do
        print(string.format('  ["%s"] = %s', k, tostring(v)))
    end
    print("======================")
end

-- =====================================================
-- INITIALIZATION
-- =====================================================

function SaveManager:Initialize()
    print("[SaveManager] Initializing...")
    
    -- Auto hook tất cả control
    self:AutoHookAll()
    
    -- Auto load config nếu có
    if isfile(GetFilePath()) then
        self:LoadConfig()
    else
        print("[SaveManager] No config found, using defaults")
    end
end

return SaveManager
