local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local spearthrow = ReplicatedStorage:WaitForChild("Remotes")
    :WaitForChild("Killers"):WaitForChild("Veil"):WaitForChild("Spearthrow")
local updatewep = ReplicatedStorage:WaitForChild("Remotes")
    :WaitForChild("Killers"):WaitForChild("Veil"):WaitForChild("updatewep")

local spearMode = false

local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()

    if method == "FireServer" and self == updatewep then
        local a1 = ...
        spearMode = (a1 == true)
        return old(self, ...)
    end

    if method == "FireServer" and self == spearthrow and spearMode then
        local a1, a2, a3 = ...
        if typeof(a1) == "Vector3" then
            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            
            -- Cari target
            local closest, shortest = nil, math.huge
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Team and p.Team.Name == "Survivors" then
                    local arm = p.Character:FindFirstChild("Left Arm")
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    if arm and hum and hum.Health > 0 and myRoot then
                        local dist = (arm.Position - myRoot.Position).Magnitude
                        if dist < shortest then shortest = dist; closest = arm end
                    end
                end
            end

            if closest and myRoot then
                local targetPos = closest.Position
                local distToTarget = (targetPos - myRoot.Position).Magnitude
                local originalA3Dist = (a3 - myRoot.Position).Magnitude
                
                print("Target:", closest.Parent.Name)
                print("Dist to target:", distToTarget)
                print("Original a3 dist:", originalA3Dist)
                print("Original a3:", a3)
                print("Target pos:", targetPos)
                
                -- Coba kirim targetPos langsung
                return old(self, a1, a2, targetPos)
            end
        end
    end
    return old(self, ...)
end)
setreadonly(mt, true)
print("Hook ready!")
