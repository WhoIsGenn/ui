-- ==================== LOAD VICTUI LIBRARY ====================
local Vict = loadstring(game:HttpGet("https://raw.githubusercontent.com/WhoIsGenn/ui/refs/heads/main/victui.lua"))()

-- ==================== CREATE MAIN WINDOW ====================
local Window = Vict:Window({
    Title = "Victoria Hub | Fish It",
    Footer = " ",
    Color = Color3.fromRGB(0, 170, 255),
    ["Tab Width"] = 120,
    Version = "1.0.0",
    Icon = "rbxassetid://96751490485303",
    Image = "96751490485303"
})

local Tab3 = Window:AddTab({
    Name = "Main",
    Icon = "fish"
})

-- FISHING SECTION
local fishingSection = Tab3:AddSection("Fishing Features")

local RS = game:GetService("ReplicatedStorage")
local net = RS:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")

-- FISHING VARIABLES
_G.AutoFishing = false
_G.AutoEquipRod = false
_G.InstantDelay = 0.65
_G.CallMinDelay = 0.18
_G.CallBackoff = 1.5

local fishThread
local lastCall = {}

local function safeCall(k, f)
    local n = os.clock()
    if lastCall[k] and n - lastCall[k] < _G.CallMinDelay then
        task.wait(_G.CallMinDelay - (n - lastCall[k]))
    end
    local ok, result = pcall(f)
    lastCall[k] = os.clock()
    if not ok then
        local msg = tostring(result):lower()
        task.wait(msg:find("429") or msg:find("too many requests") and _G.CallBackoff or 0.2)
    end
    return ok, result
end

local function rod()
    safeCall("rod", function()
        net["RE/EquipToolFromHotbar"]:FireServer(1)
    end)
end

local function autoon()
    safeCall("autoon", function()
        net["RF/UpdateAutoFishingState"]:InvokeServer(true)
    end)
end

local function autooff()
    safeCall("autooff", function()
        net["RF/UpdateAutoFishingState"]:InvokeServer(false)
    end)
end

local function catch()
    safeCall("catch", function()
        net["RE/FishingCompleted"]:FireServer()
    end)
end

local function charge()
    safeCall("charge", function()
        net["RF/ChargeFishingRod"]:InvokeServer()
    end)
end

local function lempar()
    safeCall("lempar", function()
        net["RF/RequestFishingMinigameStarted"]:InvokeServer(-139.63, 0.996, -1761532005.497)
    end)
    safeCall("charge2", function()
        net["RF/ChargeFishingRod"]:InvokeServer()
    end)
end

local function instant_cycle()
    charge()
    lempar()
    task.wait(_G.InstantDelay)
    catch()
end

local mode = "Instant"

-- Auto Fishing Toggle
fishingSection:AddToggle({
    Title = "Auto Fishing",
    Default = false,
    Callback = function(v)
        _G.AutoFishing = v
        
        if fishThread then
            task.cancel(fishThread)
            fishThread = nil
        end
        
        if v then
            if mode == "Instant" then
                fishThread = task.spawn(function()
                    while _G.AutoFishing and mode == "Instant" do
                        instant_cycle()
                        task.wait(_G.InstantDelay)
                    end
                end)
            else
                fishThread = task.spawn(function()
                    while _G.AutoFishing and mode == "Legit" do
                        autoon()
                        task.wait(1)
                    end
                end)
            end
            if not isFirstLoad then
                notif("Auto Fishing: " .. mode .. " Mode", 3, Color3.fromRGB(0, 255, 0))
            end
        else
            autooff()
            if not isFirstLoad then
                notif("Auto Fishing: Disabled", 3, Color3.fromRGB(255, 0, 0))
            end
        end
    end
})

-- Mode Dropdown
local modeOptions = {"Instant", "Legit"}
fishingSection:AddDropdown({
    Title = "Fishing Mode",
    Content = "Select fishing mode",
    Options = modeOptions,
    Default = "Instant",
    Callback = function(v)
        mode = v
        
        -- Stop fishing when switching modes
        if _G.AutoFishing then
            _G.AutoFishing = false
            autooff()
            if fishThread then 
                task.cancel(fishThread) 
                fishThread = nil
            end
        end
        
        notif("Fishing Mode: " .. v, 3, Color3.fromRGB(0, 170, 255))
    end
})

-- Instant Fishing Delay Input
fishingSection:AddInput({
    Title = "Instant Fishing Delay",
    Default = "0.65",
    Callback = function(v)
        local num = tonumber(v)
        if num and num >= 0.05 and num <= 5 then
            _G.InstantDelay = num
            notif("Instant Delay: " .. num .. "s", 3, Color3.fromRGB(0, 255, 0))
        else
            notif("Invalid delay!", 3, Color3.fromRGB(255, 0, 0))
        end
    end
})

-- Auto Equip Rod
fishingSection:AddToggle({
    Title = "Auto Equip Rod",
    Default = false,
    Callback = function(v)
        _G.AutoEquipRod = v
        if v then
            rod()
            if not isFirstLoad then
                notif("Auto Equip Rod: Enabled", 3, Color3.fromRGB(0, 255, 0))
            end
        else
            if not isFirstLoad then
                notif("Auto Equip Rod: Disabled", 3, Color3.fromRGB(255, 0, 0))
            end
        end
    end
})

-- RADAR
local radarEnabled = false
fishingSection:AddToggle({
    Title = "Bypass Radar",
    Default = false,
    Callback = function(s)
        radarEnabled = s
        local RS, L = game.ReplicatedStorage, game.Lighting
        if require(RS.Packages.Replion).Client:GetReplion("Data") then
            require(RS.Packages.Net):RemoteFunction("UpdateFishingRadar"):InvokeServer(s)
        end
        if not isFirstLoad then
            notif("Bypass Radar: " .. (s and "Enabled" or "Disabled"), 3, s and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
        end
    end
})

-- BYPASS OXYGEN
fishingSection:AddToggle({
    Title = "Bypass Oxygen",
    Default = false,
    Callback = function(s)
        if s then 
            net["RF/EquipOxygenTank"]:InvokeServer(105)
            if not isFirstLoad then
                notif("Oxygen Tank Equipped", 3, Color3.fromRGB(0, 255, 0))
            end
        else 
            net["RF/UnequipOxygenTank"]:InvokeServer()
            if not isFirstLoad then
                notif("Oxygen Tank Unequipped", 3, Color3.fromRGB(255, 0, 0))
            end
        end
    end
})

-- BLATANT V3 SECTION
local blatantV3Section = Tab3:AddSection("Blatant Experimental")

local v3 = {
    d = false,
    e = 0.7,  -- complete delay
    f = 0.3,  -- reset delay
    g = 0.794   -- charge delay
}

local v3_m = nil

-- Cancel Delay Input (tidak dipakai di V3, tapi biarin)
blatantV3Section:AddInput({
    Title = "Complete Delay",
    Default = "0.7",
    Callback = function(v)
        local num = tonumber(v)
        if num and num > 0 then
            v3.e = num
            notif("Complete Delay: " .. num .. "s", 3, Color3.fromRGB(0, 255, 0))
        else
            notif("Invalid delay!", 3, Color3.fromRGB(255, 0, 0))
        end
    end
})

-- Reset Delay Input
blatantV3Section:AddInput({
    Title = "Reset Delay",
    Default = "0.3",
    Callback = function(v)
        local num = tonumber(v)
        if num and num > 0 then
            v3.f = num
            notif("Reset Delay: " .. num .. "s", 3, Color3.fromRGB(0, 255, 0))
        else
            notif("Invalid delay!", 3, Color3.fromRGB(255, 0, 0))
        end
    end
})

-- Blatant V3 Toggle
blatantV3Section:AddToggle({
    Title = "Enable Blatant",
    Default = false,
    Callback = function(z2)
        v3.d = z2
        if z2 then
            if v3_m then 
                task.cancel(v3_m) 
            end
            
            v3_m = task.spawn(function()
                while v3.d do
                    -- CANCELLING
                    task.spawn(function()
                        pcall(function()
                            net["RF/CancelFishingInputs"]:InvokeServer()
                            net["RF/ChargeFishingRod"]:InvokeServer(math.huge)
                            net["RF/RequestFishingMinigameStarted"]:InvokeServer(-139.63, 0.996)
                        end)
                    end)
                    
                    -- COMPLETE
                    task.spawn(function()
                        task.wait(v3.e)  -- Complete delay
                        if v3.d then
                            pcall(function()
                                net["RE/FishingCompleted"]:FireServer()
                            end)
                        end
                    end)
                    
                    task.wait(v3.f)  -- Reset delay
                    if not v3.d then break end
                    task.wait(v3.g)  -- Charge delay
                end
            end)
            
            if not isFirstLoad then
                notif("Blatant V3: Enabled", 3, Color3.fromRGB(0, 255, 0))
            end
        else
            if v3_m then 
                task.cancel(v3_m) 
                v3_m = nil
            end
            
            pcall(function()
                net["RF/CancelFishingInputs"]:InvokeServer()
            end)
            
            if not isFirstLoad then
                notif("Blatant V3: Disabled", 3, Color3.fromRGB(255, 0, 0))
            end
        end
    end
})

-- RECOVERY FISHING BUTTON
blatantV3Section:AddButton({
    Title = "Recovery Fishing",
    Callback = function()
        -- Stop Blatant V3
        if v3.d then
            v3.d = false
            if v3_m then 
                task.cancel(v3_m) 
                v3_m = nil
            end
        end
        
        -- Cancel all fishing
        pcall(function() 
            net["RF/CancelFishingInputs"]:InvokeServer() 
        end)
        
        -- Reset rod
        pcall(function() 
            net["RE/EquipToolFromHotbar"]:FireServer(1) 
        end)
        
        notif("Fishing Recovery Applied", 3, Color3.fromRGB(0, 170, 255))
    end
})