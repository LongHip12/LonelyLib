if getgenv().Lonely_SaveManager then
    return getgenv().Lonely_SaveManager
end

local httpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local SaveManager = {}
SaveManager.__index = SaveManager

SaveManager.Folder = "LonelyHub"  -- Default value
SaveManager.Options = {}
SaveManager.AutoSaveEnabled = true
SaveManager.AutoSaveInterval = 5
SaveManager.GameName = ""
SaveManager.Library = nil
SaveManager.IsInitialized = false
SaveManager.AutoSaveThread = nil

-- Create new instance
function SaveManager.new()
    local self = setmetatable({}, SaveManager)
    
    self.Folder = "LonelyHub"  -- Default folder
    self.Options = {}
    self.AutoSaveEnabled = true
    self.AutoSaveInterval = 5
    self.GameName = ""
    self.Library = nil
    self.IsInitialized = false
    self.AutoSaveThread = nil
    
    return self
end

-- Set custom folder name
function SaveManager:SetFolder(folderName)
    if type(folderName) ~= "string" or folderName == "" then
        return self
    end

    self.Folder = folderName

    -- Rebuild folder tree if already initialized
    if self.IsInitialized then
        self:BuildFolderTree()
    end

    return self
end

-- Initialize the SaveManager
function SaveManager:Init()
    if self.IsInitialized then return self end
    
    self:BuildFolderTree()
    self.IsInitialized = true
    
    -- Bật auto-save ngay khi khởi động
    self:StartAutoSave()
    
    -- Auto-load khi khởi động
    self:AutoLoad()
    
    return self
end

-- Setup Library reference
function SaveManager:SetLibrary(library)
    self.Library = library
    return self
end

-- Set Game Name
function SaveManager:SetGameName(name)
    self.GameName = name
    return self
end

-- Register an option
function SaveManager:RegisterOption(id, optionData)
    if not id or not optionData then return self end
    
    self.Options[id] = optionData
    return self
end

-- Create necessary folders
function SaveManager:BuildFolderTree()
    if not makefolder then return end
    
    local paths = {
        self.Folder,
        self.Folder .. "/settings"
    }
    
    for _, path in ipairs(paths) do
        if not isfolder then break end
        if not isfolder(path) then
            makefolder(path)
        end
    end
end

-- Get auto-save filename (theo player và game)
function SaveManager:GetAutoSaveFileName()
    local player = Players.LocalPlayer
    local playerName = player and player.Name or "Player"
    local gameName = self.GameName ~= "" and self.GameName or tostring(game.PlaceId)
    
    -- Safe filename
    local safePlayerName = string.gsub(playerName, "[^%w_-]", "_")
    local safeGameName = string.gsub(gameName, "[^%w_-]", "_")
    
    return safePlayerName .. "_" .. safeGameName
end

-- Collect all current values (chỉ lấy giá trị của các phần tử)
function SaveManager:GetCurrentValues()
    local values = {}
    
    for id, option in pairs(self.Options) do
        if option.GetValue then
            values[id] = option.GetValue()
        elseif option.Value ~= nil then
            values[id] = option.Value
        end
    end
    
    return values
end

-- Save current state
function SaveManager:SaveCurrentState()
    if not writefile then return false end
    
    local fileName = self:GetAutoSaveFileName()
    local filePath = self.Folder .. "/settings/" .. fileName .. ".json"
    local values = self:GetCurrentValues()
    
    -- Chỉ lưu nếu có giá trị
    if next(values) == nil then return false end
    
    local success, jsonData = pcall(httpService.JSONEncode, httpService, values)
    if not success then return false end
    
    writefile(filePath, jsonData)
    return true
end

-- Load saved state
function SaveManager:LoadSavedState(jsonData)
    local values = {}
    
    -- Nếu có jsonData, load từ đó
    if jsonData then
        local success, data = pcall(httpService.JSONDecode, httpService, jsonData)
        if success and type(data) == "table" then
            values = data
        else
            return false, "Invalid JSON format"
        end
    else
        -- Load từ file auto-save
        local fileName = self:GetAutoSaveFileName()
        local filePath = self.Folder .. "/settings/" .. fileName .. ".json"
        
        if not isfile(filePath) then
            return false, "No saved settings found"
        end
        
        local content = readfile(filePath)
        local success, data = pcall(httpService.JSONDecode, httpService, content)
        if not success then
            return false, "Failed to decode JSON"
        end
        
        values = data
    end
    
    -- Apply loaded values
    local appliedCount = 0
    for id, value in pairs(values) do
        local option = self.Options[id]
        if option and option.SetValue then
            pcall(function()
                option.SetValue(value)
                appliedCount = appliedCount + 1
            end)
        elseif option and option.SetStage then
            pcall(function()
                option.SetStage(value)
                appliedCount = appliedCount + 1
            end)
        end
    end
    
    return true, string.format("Loaded %d settings", appliedCount)
end

-- Start auto-save loop
function SaveManager:StartAutoSave()
    if self.AutoSaveThread then
        self:StopAutoSave()
    end
    
    self.AutoSaveEnabled = true
    
    self.AutoSaveThread = task.spawn(function()
        while self.AutoSaveEnabled do
            task.wait(self.AutoSaveInterval)
            self:SaveCurrentState()
        end
    end)
    
    return self
end

-- Stop auto-save
function SaveManager:StopAutoSave()
    self.AutoSaveEnabled = false
    self.AutoSaveThread = nil
    return self
end

-- Auto-load on startup
function SaveManager:AutoLoad()
    local success, message = self:LoadSavedState()
    return success, message
end

-- Get current config as JSON string
function SaveManager:GetConfigAsJSON()
    local values = self:GetCurrentValues()
    local success, jsonData = pcall(httpService.JSONEncode, httpService, values)
    
    if success then
        return jsonData
    else
        return "{}"
    end
end

-- Copy current config to clipboard
function SaveManager:CopyConfigToClipboard()
    local jsonData = self:GetConfigAsJSON()
    
    if setclipboard then
        setclipboard(jsonData)
        return true, "Config copied to clipboard"
    else
        return false, "Clipboard not available"
    end
end

-- Validate JSON string
function SaveManager:ValidateJSON(jsonString)
    if not jsonString or jsonString:gsub("%s", "") == "" then
        return false, "JSON is empty"
    end
    
    local success, data = pcall(httpService.JSONDecode, httpService, jsonString)
    if not success then
        return false, "Invalid JSON format"
    end
    
    if type(data) ~= "table" then
        return false, "JSON must be an object"
    end
    
    return true, data
end

-- Load config from JSON string
function SaveManager:LoadConfigFromJSON(jsonString)
    local valid, result = self:ValidateJSON(jsonString)
    if not valid then
        return false, result
    end
    
    return self:LoadSavedState(jsonString)
end

-- Create simple GUI
function SaveManager:CreateSimpleGUI(parentTab)
    if not self.Library or not parentTab then return end
    
    local section = parentTab:AddLeftGroupbox("Save Manager")
    
    -- JSON TextBox
    local jsonText = ""
    section:AddLabel("Paste JSON config below:")
    
    local jsonInput = section:AddInput("SaveManager_JSON", {
        Text = "JSON Config",
        Placeholder = '{"Option1": true, "Option2": false, ...}',
        Callback = function(value)
            jsonText = value
        end
    })
    
    -- Buttons
    section:AddButton({
        Text = "Load Config",
        Callback = function()
            if jsonText == "" then
                if self.Library.Notify then
                    self.Library:Notify({
                        Title = "Load Error",
                        Desc = "Please paste JSON config",
                        Duration = 3
                    })
                end
                return
            end
            
            local success, message = self:LoadConfigFromJSON(jsonText)
            
            if self.Library.Notify then
                self.Library:Notify({
                    Title = success and "Success" or "Error",
                    Desc = message,
                    Duration = success and 3 or 5
                })
            end
        end
    })
    
    section:AddButton({
        Text = "Copy Config",
        Callback = function()
            local success, message = self:CopyConfigToClipboard()
            
            if self.Library.Notify then
                self.Library:Notify({
                    Title = success and "Success" or "Error",
                    Desc = message,
                    Duration = 3
                })
            end
        end
    })
    
    return section
end

-- Get current folder path
function SaveManager:GetCurrentFolder()
    return self.Folder
end

-- Global instance
local instance = SaveManager.new()
getgenv().Lonely_SaveManager = instance

return instance
