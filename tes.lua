-- ts file was generated at discord.gg/25ms

local genv = getgenv()
local fenv = getfenv()
local _5 = loadstring(game:HttpGet('https://raw.githubusercontent.com/kezodxyz/KezodX/refs/heads/main/Library.lua'))()
local _9 = loadstring(game:HttpGet('https://raw.githubusercontent.com/kezodxyz/KezodX/refs/heads/main/addons/ThemeManager.lua'))()
local _13 = loadstring(game:HttpGet('https://raw.githubusercontent.com/kezodxyz/KezodX/refs/heads/main/addons/SaveManager.lua'))()
local _call15 = game:GetService('Players')
local _call17 = game:GetService('RunService')
local _call19 = game:GetService('Workspace')
local _call21 = game:GetService('ReplicatedStorage')
local _call23 = game:GetService('Lighting')
local _call25 = game:GetService('UserInputService')

game:GetService('VirtualInputManager')
game:GetService('Stats')
game:GetService('TweenService')

local _LocalPlayer32 = _call15.LocalPlayer

_LocalPlayer32:WaitForChild('PlayerGui')

local _ = workspace.CurrentCamera
local _call37 = _call21:WaitForChild('Remotes')

_call37:WaitForChild('Attacks'):WaitForChild('BasicAttack')
_call37:WaitForChild('Generator'):WaitForChild('SkillCheckResultEvent')

local _call47 = _call37:FindFirstChild('Items')

_call47:FindFirstChild('Twist of Fate'):FindFirstChild('Fire')
_call47:FindFirstChild('Flashlight'):FindFirstChild('GotBlinded')

local _ = Enum.KeyCode.K
local _ = workspace.CurrentCamera.FieldOfView

Color3.fromRGB(255, 255, 255)
Color3.fromRGB(255, 255, 255)

local _ = _call23.Brightness
local _ = _call23.ClockTime
local _ = _call23.Ambient
local _ = _call23.OutdoorAmbient
local _ = _call23.GlobalShadows
local _call86 = RaycastParams.new()

_call86.FilterType = Enum.RaycastFilterType.Blacklist

_call37:WaitForChild('EmoteHandler')

fenv.VeilConfig = {
    Enabled = false,
    InfLakeMist = false,
    HorizontalPredictFactor = 1,
    Gravity = 5,
    InfPursuit = false,
    MaxDist = 200,
    TargetPart = 'Torso',
    SpearSpeed = 165,
    ShowTargetLaser = true,
    FOV = 150,
    ShowFOV = true,
    AutoPredict = false,
}
fenv.VeilState = {
    passiveCooldown = false,
    remoteHooked = false,
    chargingSpear = false,
    attackCooldown = false,
}
fenv.VeilVelocityCache = {}

local _call92 = Drawing.new('Circle')
local _call94 = Instance.new('Highlight')
local _call96 = Drawing.new('Circle')

fenv.VeilDraw = {
    FOVCircle = _call92,
    Highlight = _call94,
    Tracer = _call96,
}
_call92.Color = Color3.fromRGB(255, 0, 255)
_call92.Thickness = 1.5
_call92.Filled = false
_call92.Visible = false
_call94.Name = 'VD_VeilTarget'
_call94.FillColor = Color3.fromRGB(255, 0, 0)
_call94.OutlineColor = Color3.fromRGB(255, 255, 255)
_call94.FillTransparency = 0.5
_call94.OutlineTransparency = 0
_call96.Thickness = 2
_call96.Radius = 5
_call96.Color = Color3.fromRGB(255, 0, 255)
_call96.Filled = true
_call96.Visible = false
fenv.Veil_GetRealVelocity = function(_105, _105_2)
    local _ = _105.Position
    local _ = Vector3.zero

    return Vector3.zero
end
fenv.veil_getTargetPart = function(_109)
    return _109:FindFirstChild('Torso')
end
fenv.veil_getClosestSurvivor = function()
    _LocalPlayer32.Character:FindFirstChild('HumanoidRootPart')

    local _workspaceCurrentCamera116 = workspace.CurrentCamera

    Vector2.new((_workspaceCurrentCamera116.ViewportSize.X / 2), (_workspaceCurrentCamera116.ViewportSize.Y / 2))

    for _129, _129_2 in ipairs(game:GetService('Players'):GetPlayers())do
        local _ = _129_2 == _LocalPlayer32
        local _ = _129_2.Team
        local _ = _129_2.Team.Name
    end

    return nil
end
fenv.veil_fire = function()
    task.delay(2, function() end)

    local _Character138 = _LocalPlayer32.Character

    _LocalPlayer32.Character:FindFirstChild('HumanoidRootPart')

    local _workspaceCurrentCamera145 = workspace.CurrentCamera

    Vector2.new((_workspaceCurrentCamera145.ViewportSize.X / 2), (_workspaceCurrentCamera145.ViewportSize.Y / 2))

    for _158, _158_2 in ipairs(game:GetService('Players'):GetPlayers())do
        local _ = _158_2 == _LocalPlayer32
        local _ = _158_2.Team
        local _ = _158_2.Team.Name
    end

    local _call173 = game:GetService('ReplicatedStorage'):FindFirstChild('Remotes'):FindFirstChild('Killers'):FindFirstChild('Veil')

    _call173:FindFirstChild('Spearthrow')

    local _Spearthrow176 = _call173.Spearthrow

    _Spearthrow176:FireServer(workspace.CurrentCamera.CFrame.LookVector, 165, _Character138:FindFirstChild('Head').Position)

    _call92.Color = Color3.fromRGB(255, 0, 255)

    task.delay(30, function()
        _call92.Color = Color3.fromRGB(255, 0, 255)
    end)
end

local _call187 = Instance.new('CylinderHandleAdornment')

_call187.Name = 'KYS_ParryRange'
_call187.Radius = 8
_call187.InnerRadius = 7.85
_call187.Height = 0.01
_call187.Color3 = Color3.fromRGB(255, 80, 80)
_call187.AlwaysOnTop = false
_call187.Adornee = _call19:FindFirstChildOfClass('Terrain')
_call187.Transparency = 1
_call187.Parent = game:GetService('CoreGui')
fenv.VD_UpdateParryRange = function()
    _call187.Transparency = 1
end
fenv.tapMobileParryButton = function()
    local _call197 = _LocalPlayer32:FindFirstChild('PlayerGui'):FindFirstChild('Survivor-mob')

    _call197:FindFirstChild('Controls')

    local _call202 = _call197.Controls:FindFirstChild('Gui-mob')
    local _ = _call202.Visible

    firesignal(_call202.MouseButton1Down)
    task.wait(0.01)
    firesignal(_call202.MouseButton1Up)
end
fenv.ExecuteParry = function()
    local _call216 = _call21:FindFirstChild('Remotes'):FindFirstChild('Items'):FindFirstChild('Parrying Dagger'):FindFirstChild('parry')

    _call216:FireServer()
    _call216:FireServer()
    _call216:FireServer()
    _call216:FireServer()
    _call216:FireServer()
    _call216:FireServer()
    _call216:FireServer()
    _call216:FireServer()
    _call216:FireServer()
    _call216:FireServer()
    task.spawn(function()
        local _call243 = _LocalPlayer32:FindFirstChild('PlayerGui'):FindFirstChild('Survivor-mob')

        _call243:FindFirstChild('Controls')

        local _call248 = _call243.Controls:FindFirstChild('Gui-mob')
        local _ = _call248.Visible

        firesignal(_call248.MouseButton1Down)
        task.wait(0.01)
        firesignal(_call248.MouseButton1Up)
    end)
end
fenv.ListenToParryResult = function()
    task.spawn(function()
        _call21:WaitForChild('Remotes', 5):WaitForChild('Items', 5):WaitForChild('Parrying Dagger', 5):WaitForChild('parryResult', 5).OnClientEvent:Connect(function(_269, _269_2)
            task.delay(60, function() end)
        end)
    end)
end

task.spawn(function()
    _call21:WaitForChild('Remotes', 5):WaitForChild('Items', 5):WaitForChild('Parrying Dagger', 5):WaitForChild('parryResult', 5).OnClientEvent:Connect(function(_287, _287_2)
        task.cancel(_call271)
        task.delay(60, function() end)
    end)
end)

fenv.IsDowned = function(_293)
    _293:FindFirstChild('HumanoidRootPart')
    _293:GetAttribute('State')

    return false
end
fenv.IsSafeToParry = function(_298)
    _298:FindFirstChild('HumanoidRootPart')
    _298:GetAttribute('State')

    return true
end
fenv.AttachParrySensor = function(_303)
    local _call305 = _303:FindFirstChild('Humanoid')

    _call305.ChildAdded:Connect(function(_311)
        _311:IsA('Animator')

        local _ = fenv.AttachParrySensor

        error('line 2: attempt to call a nil value')
    end)
    _303.AncestryChanged:Connect(function(_318, _318_2) end)
    _call305:FindFirstChildOfClass('Animator').AnimationPlayed:Connect(function(_322)
        local _ = _322.Animation

        _322.Animation.AnimationId:match('%d+')
    end)
end
fenv.TryAttach = function(_328)
    local _ = _328 == _LocalPlayer32
    local _ = _328.Team
    local _ = _328.Team.Name
end
fenv.SetupPlayer = function(_334)
    local _ = _334 == _LocalPlayer32

    _334.CharacterAdded:Connect(function()
        local _ = _334 == _LocalPlayer32
        local _ = _334.Team
        local _ = _334.Team.Name
    end)
    _334:GetPropertyChangedSignal('Team'):Connect(function()
        local _ = _334 == _LocalPlayer32
        local _ = _334.Team
        local _ = _334.Team.Name
    end)

    local _ = _334.Character
    local _ = _334 == _LocalPlayer32
    local _ = _334.Team
    local _ = _334.Team.Name
end

for _359, _359_2 in pairs(_call15:GetPlayers())do
    local _ = _359_2 == _LocalPlayer32

    _359_2.CharacterAdded:Connect(function()
        local _ = _359_2 == _LocalPlayer32
        local _ = _359_2.Team
        local _ = _359_2.Team.Name
    end)
    _359_2:GetPropertyChangedSignal('Team'):Connect(function()
        local _ = _359_2 == _LocalPlayer32
        local _ = _359_2.Team
        local _ = _359_2.Team.Name
    end)

    local _ = _359_2.Character
    local _ = _359_2 == _LocalPlayer32
    local _ = _359_2.Team
    local _ = _359_2.Team.Name
end

_call15.PlayerAdded:Connect(function(_386)
    local _ = _386 == _LocalPlayer32

    _386.CharacterAdded:Connect(function()
        local _ = _386 == _LocalPlayer32
        local _ = _386.Team
        local _ = _386.Team.Name
    end)
    _386:GetPropertyChangedSignal('Team'):Connect(function()
        local _ = _386 == _LocalPlayer32
        local _ = _386.Team
        local _ = _386.Team.Name
    end)

    local _ = _386.Character
    local _ = _386 == _LocalPlayer32
    local _ = _386.Team
    local _ = _386.Team.Name
end)
task.spawn(function()
    task.wait(5)

    for _415, _415_2 in pairs(_call15:GetPlayers())do
        local _ = _415_2 == _LocalPlayer32
        local _ = _415_2.Team
        local _ = _415_2.Team.Name
    end

    task.wait(5)

    for _422, _422_2 in pairs(_call15:GetPlayers())do
        local _ = _422_2 == _LocalPlayer32
        local _ = _422_2.Team
        local _ = _422_2.Team.Name
    end

    task.wait(5)

    for _429, _429_2 in pairs(_call15:GetPlayers())do
        local _ = _429_2 == _LocalPlayer32
        local _ = _429_2.Team
        local _ = _429_2.Team.Name
    end

    task.wait(5)

    for _436, _436_2 in pairs(_call15:GetPlayers())do
        local _ = _436_2 == _LocalPlayer32
        local _ = _436_2.Team
        local _ = _436_2.Team.Name
    end

    task.wait(5)

    for _443, _443_2 in pairs(_call15:GetPlayers())do
        local _ = _443_2 == _LocalPlayer32
        local _ = _443_2.Team
        local _ = _443_2.Team.Name
    end

    task.wait(5)

    for _450, _450_2 in pairs(_call15:GetPlayers())do
        local _ = _450_2 == _LocalPlayer32
        local _ = _450_2.Team
        local _ = _450_2.Team.Name
    end

    task.wait(5)

    for _457, _457_2 in pairs(_call15:GetPlayers())do
        local _ = _457_2 == _LocalPlayer32
        local _ = _457_2.Team
        local _ = _457_2.Team.Name
    end

    task.wait(5)

    for _464, _464_2 in pairs(_call15:GetPlayers())do
        local _ = _464_2 == _LocalPlayer32
        local _ = _464_2.Team
        local _ = _464_2.Team.Name
    end

    task.wait(5)

    for _471, _471_2 in pairs(_call15:GetPlayers())do
        local _ = _471_2 == _LocalPlayer32
        local _ = _471_2.Team
        local _ = _471_2.Team.Name
    end

    task.wait(5)

    for _478, _478_2 in pairs(_call15:GetPlayers())do
        local _ = _478_2 == _LocalPlayer32
        local _ = _478_2.Team
        local _ = _478_2.Team.Name
    end

    task.wait(5)

    for _485, _485_2 in pairs(_call15:GetPlayers())do
        local _ = _485_2 == _LocalPlayer32
        local _ = _485_2.Team
        local _ = _485_2.Team.Name
    end

    task.wait(5)

    for _492, _492_2 in pairs(_call15:GetPlayers())do
        local _ = _492_2 == _LocalPlayer32
        local _ = _492_2.Team
        local _ = _492_2.Team.Name
    end

    task.wait(5)

    for _499, _499_2 in pairs(_call15:GetPlayers())do
        local _ = _499_2 == _LocalPlayer32
        local _ = _499_2.Team
        local _ = _499_2.Team.Name
    end

    task.wait(5)

    for _506, _506_2 in pairs(_call15:GetPlayers())do
        local _ = _506_2 == _LocalPlayer32
        local _ = _506_2.Team
        local _ = _506_2.Team.Name
    end

    task.wait(5)

    for _513, _513_2 in pairs(_call15:GetPlayers())do
        local _ = _513_2 == _LocalPlayer32
        local _ = _513_2.Team
        local _ = _513_2.Team.Name
    end

    task.wait(5)

    for _520, _520_2 in pairs(_call15:GetPlayers())do
        local _ = _520_2 == _LocalPlayer32
        local _ = _520_2.Team
        local _ = _520_2.Team.Name
    end

    task.wait(5)

    for _527, _527_2 in pairs(_call15:GetPlayers())do
        local _ = _527_2 == _LocalPlayer32
        local _ = _527_2.Team
        local _ = _527_2.Team.Name
    end

    task.wait(5)

    for _534, _534_2 in pairs(_call15:GetPlayers())do
        local _ = _534_2 == _LocalPlayer32
        local _ = _534_2.Team
        local _ = _534_2.Team.Name
    end

    task.wait(5)

    for _541, _541_2 in pairs(_call15:GetPlayers())do
        local _ = _541_2 == _LocalPlayer32

        error('internal 583: <25ms: infinitelooperror>')
    end
end)

fenv.VD_SetAutoParry = function(_544)
    _call187.Transparency = 1

    local _ = _G.VD_ParryRenderConnection
end

local _ = Enum.KeyCode.Q
local _ = Enum.KeyCode.E
local _ = Enum.KeyCode.R
local _ = Enum.KeyCode.T
local _ = Enum.KeyCode.F
local _ = Enum.KeyCode.G
local _ = Enum.KeyCode.H
local _ = Enum.KeyCode.J
local _ = Enum.KeyCode.K
local _ = Enum.KeyCode.L
local _ = Enum.KeyCode.X
local _ = Enum.KeyCode.Z

fenv.KYS_ToFSetTargetMode = function(_571, _571_2) end

_call25.InputBegan:Connect(function(_575, _575_2) end)
_call25.InputEnded:Connect(function(_579)
    local _ = _579.UserInputType == Enum.UserInputType.MouseButton1

    error('internal 583: <25ms: infinitelooperror>')
end)

genv.KYS_SetToFSilentAim = function(_585)
    local _callgethui586 = gethui()

    _callgethui586:FindFirstChild('ToFTargetSelector'):Destroy()

    local _call592 = Instance.new('ScreenGui')

    _call592.Name = 'ToFTargetSelector'
    _call592.ResetOnSpawn = false
    _call592.IgnoreGuiInset = true
    _call592.Parent = _callgethui586

    local _call594 = Instance.new('Frame')

    _call594.Name = 'Main'
    _call594.Size = UDim2.new(0, 180, 0, 126)
    _call594.Position = UDim2.new(0.5, -120, 0, 110)
    _call594.BackgroundColor3 = Color3.fromRGB(16, 18, 24)
    _call594.BorderSizePixel = 0
    _call594.Active = true
    _call594.Parent = _call592

    local _call600 = Instance.new('UICorner', _call594)

    _call600.CornerRadius = UDim.new(0, 8)

    local _call604 = Instance.new('UIStroke', _call594)

    _call604.Color = Color3.fromRGB(96, 72, 160)
    _call604.Thickness = 1

    local _call608 = Instance.new('Frame')

    _call608.Size = UDim2.new(1, 0, 0, 28)
    _call608.BackgroundColor3 = Color3.fromRGB(24, 26, 34)
    _call608.BorderSizePixel = 0
    _call608.Parent = _call594

    local _call614 = Instance.new('UICorner', _call608)

    _call614.CornerRadius = UDim.new(0, 8)

    local _call618 = Instance.new('Frame')

    _call618.Size = UDim2.new(1, 0, 0, 10)
    _call618.Position = UDim2.new(0, 0, 1, -10)
    _call618.BackgroundColor3 = Color3.fromRGB(24, 26, 34)
    _call618.BorderSizePixel = 0
    _call618.Parent = _call608

    local _call626 = Instance.new('Frame')

    _call626.Size = UDim2.new(1, -34, 1, 0)
    _call626.BackgroundTransparency = 1
    _call626.Parent = _call608

    local _call630 = Instance.new('TextButton')

    _call630.Size = UDim2.new(0, 28, 1, 0)
    _call630.Position = UDim2.new(1, -30, 0, 0)
    _call630.BackgroundTransparency = 1
    _call630.Text = '-'
    _call630.TextColor3 = Color3.fromRGB(185, 190, 205)
    _call630.Font = Enum.Font.GothamBold
    _call630.TextSize = 14
    _call630.Parent = _call608

    local _call640 = Instance.new('TextLabel')

    _call640.Size = UDim2.new(1, -44, 1, 0)
    _call640.Position = UDim2.new(0, 10, 0, 0)
    _call640.BackgroundTransparency = 1
    _call640.Text = 'TOF TARGET MODE'
    _call640.TextColor3 = Color3.fromRGB(210, 215, 230)
    _call640.Font = Enum.Font.GothamBold
    _call640.TextSize = 10
    _call640.TextXAlignment = Enum.TextXAlignment.Left
    _call640.Parent = _call608

    local _call652 = Instance.new('Frame')

    _call652.Size = UDim2.new(1, -16, 0, 86)
    _call652.Position = UDim2.new(0, 8, 0, 34)
    _call652.BackgroundTransparency = 1
    _call652.Parent = _call594

    error('internal 583: <25ms: infinitelooperror>')
end
genv.KYS_ToFClearLaser = function() end
genv.KYS_ToFSetTargetMode = function(_659, _659_2) end

local _ = _5.Toggles
local _ = _5.Options

_5.ForceCheckbox = false
_5.ShowToggleFrameInKeybinds = true

local _Scheme662 = _5.Scheme

_Scheme662.AccentColor = Color3.fromRGB(0, 255, 255)

local _Scheme665 = _5.Scheme

_Scheme665.BackgroundColor = Color3.fromRGB(8, 12, 20)

local _Scheme668 = _5.Scheme

_Scheme668.MainColor = Color3.fromRGB(14, 20, 35)

local _Scheme671 = _5.Scheme

_Scheme671.OutlineColor = Color3.fromRGB(0, 180, 255)

local _Scheme674 = _5.Scheme

_Scheme674.FontColor = Color3.fromRGB(180, 240, 255)

local _call682 = _5:CreateWindow({
    AutoShow = true,
    SidebarCompacted = true,
    NotifySide = 'Right',
    EnableCompacting = true,
    EnableSidebarResize = true,
    Title = 'Kanzyu_Script',
    Footer = 'TT kanzyu_script | YT kanzyu_script',
    IconSize = UDim2.fromOffset(50, 50),
    CornerRadius = 20,
    Icon = '136681914611819',
    Size = UDim2.fromOffset(450, 1000),
})
local _call684 = _call682:AddTab('Info', 'info', 'Information, Credit')
local _call686 = _call682:AddTab('ESP', 'eye', 'Esp player, object, stats')
local _call688 = _call682:AddTab('Player', 'user', 'Ability Survivor & Killer')
local _call690 = _call682:AddTab('Misc', 'sliders-horizontal', 'Movement, Emote, Fun')
local _call692 = _call682:AddTab('Visual', 'sparkles', 'Graphics, MorphAva, Time')
local _call694 = _call682:AddTab('UI Settings', 'settings-2', 'Config, Theme, UiSetting')
local _call696 = _call684:AddLeftGroupbox('Script Info', 'info')
local _call698 = _call684:AddRightGroupbox('Credits', 'user')
local _call700 = _call686:AddLeftGroupbox('ESP Cham', 'scan-eye')
local _call702 = _call686:AddRightGroupbox('ESP Status', 'scan-eye')
local _call704 = _call688:AddRightTabbox()
local _call706 = _call704:AddTab('Survivor', 'user')
local _call708 = _call704:AddTab('Killer', 'skull')
local _call710 = _call688:AddLeftGroupbox('AimBot', 'crosshair')
local _call712 = _call688:AddLeftGroupbox('Twist of Fate', 'target')
local _call714 = _call688:AddLeftGroupbox('Parry', 'swords')
local _call716 = _call688:AddLeftGroupbox('Crosshair', 'crosshair')
local _call718 = _call690:AddLeftGroupbox('Movement', 'move')
local _call720 = _call690:AddRightGroupbox('Fake Chat Tag', 'message-circle')
local _call722 = _call692:AddLeftGroupbox('Graphics', 'sun')
local _call724 = _call692:AddLeftGroupbox('Morph Avatar', 'user')
local _call726 = _call692:AddRightGroupbox('Clock & Ambient', 'alarm-clock-check')
local _call728 = _call692:AddRightGroupbox('Zoom Out', 'fullscreen')
local _call730 = _call694:AddLeftGroupbox('Menu', 'wrench')

_call21:FindFirstChild('Remotes'):FindFirstChild('Mechanics'):FindFirstChild('Fall'):IsA('RemoteEvent')

local _callgetrawmetatable739 = getrawmetatable(game)

setreadonly(_callgetrawmetatable739, false)

local __namecall741 = _callgetrawmetatable739.__namecall

newcclosure(function(_742, ...)
    checkcaller()

    local _call744 = __namecall741(_742, ...)

    return _call744
end)

_callgetrawmetatable739.__namecall = function(...)
    error('internal 583: <25ms: infinitelooperror>')
end

setreadonly(_callgetrawmetatable739, true)

for _750, _750_2 in ipairs(workspace:GetDescendants())do
    local _752 = string.lower(_750_2.Name)

    string.find(_752, 'scp')

    local _ = _750_2.Name
    local _ = _750_2.Name
    local _ = _750_2.Name
    local _ = _750_2.Name

    _750_2:IsA('Model')

    local _ = _750_2.Name
end

workspace.DescendantAdded:Connect(function(_764) end)
workspace.DescendantRemoving:Connect(function(_768) end)
hookmetamethod(game, '__namecall', function(_770, ...) end)
_call25.InputBegan:Connect(function(_774, _774_2) end)
_call25.InputEnded:Connect(function(_778) end)
game:GetService('UserInputService').InputBegan:Connect(function(_784, _784_2) end)
game:GetService('UserInputService').InputEnded:Connect(function(_790, _790_2) end)
game:GetService('RunService').RenderStepped:Connect(function() end)
task.spawn(function() end)

game:GetService('TextChatService').OnIncomingMessage = function(_802) end

_call23.ChildAdded:Connect(function(_806) end)

local _ = _call25.TouchEnabled

fenv.GB_GetAllGenerators = function() end
fenv.GB_GetPoints = function(_809) end
fenv.GB_WaitRepairing = function(_810, _810_2) end
fenv.GB_DoRepair = function(_811) end
fenv.GB_GetNearestPoint = function() end
fenv.GB_IsPromptVisible = function() end
fenv.GB_UpdateButton = function() end
fenv.GB_CreateButton = function() end

_LocalPlayer32.PlayerGui:FindFirstChild('BypassGenUI'):Destroy()

local _call822 = Instance.new('ScreenGui')

_call822.Name = 'BypassGenUI'
_call822.ResetOnSpawn = false
_call822.IgnoreGuiInset = true
_call822.Parent = _LocalPlayer32:WaitForChild('PlayerGui')

local _call826 = Instance.new('ImageButton')

_call826.Name = 'BypassGenButton'
_call826.Size = UDim2.new(0, 60, 0, 60)
_call826.Position = UDim2.new(0.88, 0, 0.55, 0)
_call826.AnchorPoint = Vector2.new(0.5, 0.5)
_call826.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
_call826.BackgroundTransparency = 0.15
_call826.AutoButtonColor = true
_call826.Visible = false
_call826.ZIndex = 10
_call826.Parent = _call822

local _call836 = Instance.new('UICorner', _call826)

_call836.CornerRadius = UDim.new(1, 0)

local _call840 = Instance.new('UIStroke', _call826)

_call840.Color = Color3.fromRGB(0, 255, 255)
_call840.Thickness = 2
_call840.Transparency = 0.2

local _call844 = Instance.new('TextLabel', _call826)

_call844.Size = UDim2.new(1, 0, 1, 0)
_call844.BackgroundTransparency = 1
_call844.Text = 'K'
_call844.TextColor3 = Color3.fromRGB(255, 255, 255)
_call844.TextScaled = true
_call844.Font = Enum.Font.GothamBlack
_call844.ZIndex = 11

_call826.MouseButton1Click:Connect(function() end)
_LocalPlayer32.CharacterAdded:Connect(function() end)
_call25.InputBegan:Connect(function(_862, _862_2) end)
_call25.InputBegan:Connect(function(_866, _866_2) end)
task.spawn(function() end)

local _CharacterAdded870 = _LocalPlayer32.CharacterAdded

fenv.setGenBypass = function(_871) end

_CharacterAdded870:Connect(function(_874) end)
_LocalPlayer32.CharacterAdded:Connect(function(_878) end)
_LocalPlayer32.CharacterAdded:Connect(function() end)
_LocalPlayer32.CharacterAdded:Connect(function(_886) end)
_call17.Heartbeat:Connect(function() end)
_call17.RenderStepped:Connect(function() end)
_call17.RenderStepped:Connect(function() end)

local _ = _LocalPlayer32.Character

_LocalPlayer32.Character:FindFirstChildOfClass('Humanoid'):FindFirstChildOfClass('Animator').AnimationPlayed:Connect(function(_908) end)
_call17.RenderStepped:Connect(function() end)
_call696:AddLabel('Script: kanzyu')
_call696:AddLabel('Version: 1.1.1')
_call696:AddLabel('Game: Violence District')
_call696:AddButton('Copy Saluran Link', function() end)
_call696:AddLabel('Join discord for more info')
_call696:AddLabel('Discord:')
_call696:AddButton('Copy Discord Link', function() end)
_call698:AddLabel('Developer:')
_call698:AddLabel('\u{2022} Kanzyu_script')
_call698:AddDivider()
_call698:AddLabel('Library:')
_call698:AddLabel('\u{2022} Obsidian UI')
_call698:AddDivider()
_call698:AddLabel('Support the dev:')
_call698:AddButton('Copy Support Link', function() end)

local _call947 = _call700:AddCheckbox('SurvivorESP', {
    Text = 'ESP Survivor',
    Default = false,
    Callback = function(_948) end,
})

_call947:AddColorPicker('SurvivorESPColor', {
    Callback = function(_951) end,
    Title = 'Survivor Color',
    Default = Color3.fromRGB(0, 0, 139),
})

local _call953 = _call700:AddCheckbox('KillerESP', {
    Text = 'ESP Killer',
    Default = false,
    Callback = function(_954) end,
})

_call953:AddColorPicker('KillerESPColor', {
    Callback = function(_957) end,
    Title = 'Killer Color',
    Default = Color3.fromRGB(255, 60, 60),
})

local _call959 = _call700:AddCheckbox('ESPGenerator', {
    Text = 'Generator',
    Default = false,
    Callback = function(_960) end,
})

_call959:AddColorPicker('GeneratorColor', {
    Callback = function(_963) end,
    Title = 'Generator Color',
    Default = Color3.fromRGB(255, 170, 0),
})

local _call965 = _call700:AddCheckbox('ESPHook', {
    Text = 'Hook',
    Default = false,
    Callback = function(_966) end,
})

_call965:AddColorPicker('HookColor', {
    Callback = function(_969) end,
    Title = 'Hook Color',
    Default = Color3.fromRGB(204, 204, 0),
})

local _call971 = _call700:AddCheckbox('ESPSCP', {
    Text = 'SCP',
    Default = false,
    Callback = function(_972) end,
})

_call971:AddColorPicker('SCPColor', {
    Callback = function(_975) end,
    Title = 'SCP Color',
    Default = Color3.fromRGB(255, 255, 102),
})

local _call977 = _call700:AddCheckbox('ESPPallet', {
    Text = 'Pallet',
    Default = false,
    Callback = function(_978) end,
})

_call977:AddColorPicker('PalletColor', {
    Callback = function(_981) end,
    Title = 'Pallet Color',
    Default = Color3.fromRGB(144, 238, 144),
})

local _call983 = _call700:AddCheckbox('ESPWindow', {
    Text = 'Window',
    Default = false,
    Callback = function(_984) end,
})

_call983:AddColorPicker('WindowColor', {
    Callback = function(_987) end,
    Title = 'Window Color',
    Default = Color3.fromRGB(74, 255, 181),
})
_call700:AddSlider('ESPDistance', {
    Min = 10,
    Default = 100,
    Max = 1000,
    Text = 'ESP Radius',
    Callback = function(_990) end,
    Rounding = 0,
})
_call702:AddCheckbox('EnableStatus', {
    Text = 'Enable Status ESP',
    Default = false,
    Callback = function(_993) end,
})
_call702:AddCheckbox('ShowName', {
    Text = 'Show Name',
    Default = true,
    Callback = function(_996) end,
})
_call702:AddCheckbox('ShowItemESP', {
    Text = 'Show Item',
    Default = true,
    Callback = function(_999) end,
})
_call702:AddCheckbox('ShowDistance', {
    Text = 'Show Distance',
    Default = true,
    Callback = function(_1002) end,
})
_call702:AddCheckbox('ShowHealth', {
    Text = 'Show Health',
    Default = false,
    Callback = function(_1005) end,
})
_call702:AddSlider('StatusRadius', {
    Min = 20,
    Default = 100,
    Max = 500,
    Text = 'Status Radius',
    Callback = function(_1008) end,
    Rounding = 0,
})

local _call1010 = _call716:AddCheckbox('CrosshairEnabled', {
    Text = 'Enable Crosshair',
    Default = false,
    Callback = function(_1011) end,
})

_call1010:AddColorPicker('CrosshairColor', {
    Callback = function(_1016) end,
    Transparency = 0,
    Title = 'Crosshair Color',
    Default = Color3.fromRGB(255, 255, 255),
})
_call716:AddDropdown('Style', {
    Values = {
        [1] = 'Plus',
        [2] = 'Dot',
        [3] = 'Circle',
    },
    Text = 'Style',
    Multi = false,
    Callback = function(_1019) end,
    Default = 1,
})
_call716:AddSlider('CrosshairPosX', {
    Min = -100,
    Default = 0,
    Max = 100,
    Text = 'Position X',
    Callback = function(_1022) end,
    Rounding = 0,
})
_call716:AddSlider('CrosshairPosY', {
    Min = -100,
    Default = 0,
    Max = 100,
    Text = 'Position Y',
    Callback = function(_1025) end,
    Rounding = 0,
})
_call706:AddCheckbox('Skill', {
    Text = 'Auto Skill Check',
    Default = false,
    Callback = function(_1028) end,
})
_call706:AddDropdown('SkillCheckModeDropdown', {
    Values = {
        [1] = 'Legit',
        [2] = 'Instant',
    },
    Text = 'Skill Check Mode',
    Multi = false,
    Callback = function(_1031) end,
    Default = 1,
})
_call706:AddCheckbox('GenBypassToggle', {
    Callback = function(_1034) end,
    Text = 'Genboost',
    Default = false,
    Tooltip = 'Otomatis repair semua titik generator di dekatmu.',
})
_call706:AddCheckbox('AutoPalletDrop', {
    Callback = function(_1037) end,
    Text = 'Auto Drop Pallet',
    Default = false,
    Tooltip = 'otomatis menjatuhkan pallet',
})
_call706:AddSlider('AutoPalletDist', {
    Min = 5,
    Default = 6,
    Max = 50,
    Text = 'Auto Pallet Distance',
    Callback = function(_1040) end,
    Rounding = 0,
})
_call706:AddCheckbox('AutoFleeKiller', {
    Callback = function(_1043) end,
    Text = 'Auto Flee Killer',
    Default = false,
    Tooltip = 'otomatis tp menjauh dari killer',
})
_call706:AddCheckbox('AntiFallDamage', {
    Callback = function(_1046) end,
    Text = 'Anti Fall Damage',
    Default = false,
    Tooltip = 'memblokir efek slow ketika jatuh',
})
_call706:AddCheckbox('GodMode', {
    Callback = function(_1049) end,
    Text = 'Anti KnockDown',
    Default = false,
    Tooltip = 'memaksa berdiri ketika KnockDown',
})
_call706:AddCheckbox('FastVault', {
    Callback = function(_1052) end,
    Text = 'Fast Vault',
    Default = false,
    Tooltip = 'percepat animasi lompat',
})
_call706:AddSlider('VaultSpeed', {
    Min = 1,
    Default = 1.2,
    Max = 5,
    Text = 'Animation Speed',
    Callback = function(_1055) end,
    Rounding = 1,
})
_call706:AddCheckbox('AntiVault', {
    Callback = function(_1058) end,
    Text = 'Disable Local Vault',
    Default = false,
    Tooltip = 'Mencegah karaktermu melakukan vault (berguna agar tidak salah tekan saat dikejar)',
})
_call706:AddDivider()
_call706:AddButton({
    Func = function() end,
    Text = 'instan escape',
})
_call708:AddLabel('Veil Spear Assist')
_call708:AddToggle('VeilEnabled', {
    Text = 'Enable Veil Assist',
    Default = false,
    Callback = function(_1068) end,
})
_call708:AddToggle('VeilShowFOV', {
    Text = 'Show FOV Circle',
    Default = true,
    Callback = function(_1071) end,
})
_call708:AddToggle('VeilShowLaser', {
    Text = 'Show Target Laser',
    Default = true,
    Callback = function(_1074) end,
})
_call708:AddToggle('VeilAutoPredict', {
    Text = 'Auto Predict',
    Default = false,
    Callback = function(_1077) end,
})
_call708:AddToggle('VeilInfLakeMist', {
    Text = 'Infinite LakeMist',
    Default = false,
    Callback = function(_1080) end,
})
_call708:AddToggle('VeilInfPursuit', {
    Text = 'Infinite Pursuit',
    Default = false,
    Callback = function(_1083) end,
})
_call708:AddSlider('VeilFOV', {
    Min = 10,
    Default = 150,
    Max = 500,
    Text = 'FOV',
    Callback = function(_1086) end,
    Rounding = 0,
})
_call708:AddSlider('VeilSpearSpeed', {
    Min = 20,
    Default = 165,
    Max = 300,
    Text = 'Spear Speed',
    Callback = function(_1089) end,
    Rounding = 0,
})
_call708:AddSlider('VeilGravity', {
    Min = 0,
    Default = 5,
    Max = 200,
    Text = 'Gravity',
    Callback = function(_1092) end,
    Rounding = 1,
})
_call708:AddSlider('VeilMaxDist', {
    Min = 10,
    Default = 200,
    Max = 500,
    Text = 'Max Distance',
    Callback = function(_1095) end,
    Rounding = 0,
})
_call708:AddSlider('VeilPredictFactor', {
    Min = 0,
    Default = 1,
    Max = 3,
    Text = 'Prediction Factor',
    Callback = function(_1098) end,
    Rounding = 2,
})
_call708:AddDropdown('VeilTargetPart', {
    Default = 1,
    Multi = false,
    Text = 'Target Part',
    Callback = function(_1101) end,
    Values = {
        [1] = 'Torso',
        [2] = 'Head',
        [3] = 'Root',
    },
})
_call708:AddDivider()
_call708:AddCheckbox('BlockAllVaults', {
    Callback = function(_1106) end,
    Text = 'Block All Vaults',
    Default = false,
    Tooltip = 'memicu Entity Blocker (Mencegah Survivor Vault)',
})
_call708:AddCheckbox('AntiBlindToggle', {
    Text = 'Anti Blind (Flashlight)',
    Default = false,
    Callback = function(_1109) end,
})
_call708:AddCheckbox('AutoStalk', {
    Text = 'Auto Stalk (myers)',
    Default = false,
    Callback = function(_1112) end,
})
_call708:AddCheckbox('BypassCooldown', {
    Text = 'Bypass Cooldown(Abyss)',
    Default = false,
    Callback = function(_1115) end,
})
_call708:AddCheckbox('BypassLeapCooldown', {
    Text = 'Bypass Cooldown(Hidden)',
    Default = false,
    Callback = function(_1118) end,
})
_call708:AddCheckbox('KillAll', {
    Text = 'Auto Kill All',
    Default = false,
    Callback = function(_1121) end,
})
_call708:AddCheckbox('AttackAim', {
    Text = 'AimLock Attack',
    Default = false,
    Callback = function(_1124) end,
})
_call708:AddDropdown('AttackAimMode', {
    Default = 1,
    Multi = false,
    Text = 'Aimlock Mode',
    Callback = function(_1127) end,
    Values = {
        [1] = 'Normal',
        [2] = 'Spear',
    },
})
_call708:AddSlider('SpearGravity', {
    Min = 10,
    Default = 50,
    Max = 200,
    Text = 'Spear Gravity',
    Callback = function(_1130) end,
    Rounding = 0,
})
_call708:AddSlider('SpearSpeed', {
    Min = 20,
    Default = 100,
    Max = 300,
    Text = 'Spear Speed',
    Callback = function(_1133) end,
    Rounding = 0,
})
_call708:AddDivider()
_call708:AddDropdown('MaskedPowerSelect', {
    Default = 1,
    Multi = false,
    Text = 'Select Power',
    Callback = function(_1138) end,
    Values = {
        [1] = 'Cobra',
        [2] = 'Richter',
        [3] = 'Brandon',
        [4] = 'Rabbit',
        [5] = 'Alex',
    },
})
_call708:AddButton('Activate Power', function() end)
_call708:AddButton('Deactivate Power', function() end)

local _call1146 = _call714:AddCheckbox('AutoParry', {
    Text = 'Auto Parry',
    Default = false,
    Callback = function(_1147) end,
})

_call1146:AddColorPicker('ParryRangeColor', {
    Callback = function(_1152) end,
    Transparency = 0,
    Default = Color3.fromRGB(255, 80, 80),
    Title = 'Parry Range Color',
})
_call714:AddCheckbox('ShowParryRange', {
    Text = 'Show Parry Range',
    Default = true,
    Callback = function(_1155) end,
})
_call714:AddSlider('ParryDistance', {
    Min = 5,
    Default = 8,
    Max = 20,
    Text = 'Distance',
    Callback = function(_1158) end,
    Rounding = 0,
})
_call714:AddCheckbox('AggressiveMode', {
    Callback = function(_1161) end,
    Text = 'Aggressive Mode',
    Default = false,
    Tooltip = 'Parry lebih agresif: menunggu mendekat jika dalam jarak deteksi',
})
_call714:AddSlider('FaceSensitivity', {
    Min = -1,
    Default = 0.3,
    Max = 1,
    Text = 'Face Sensitivity Killer',
    Callback = function(_1164) end,
    Rounding = 2,
})
_call710:AddToggle('GunAimEnabled', {
    Text = 'Aim Lock',
    Default = false,
    Callback = function(_1167) end,
})
_call710:AddDropdown('GunAimTarget', {
    Callback = function(_1170) end,
    Text = 'Target',
    Default = 1,
    Values = {
        [1] = 'Killer',
        [2] = 'Survivor',
        [3] = 'SCP',
    },
})
_call710:AddDropdown('GunAimPart', {
    Callback = function(_1173) end,
    Text = 'Aim Part',
    Values = {
        [1] = 'Head',
        [2] = 'HumanoidRootPart',
        [3] = 'Torso',
    },
    Default = 2,
})
_call710:AddSlider('GunAimFOV', {
    Min = 50,
    Default = 250,
    Max = 1000,
    Text = 'FOV',
    Callback = function(_1176) end,
    Rounding = 0,
})
_call710:AddSlider('GunAimPredict', {
    Min = 0,
    Default = 0.12,
    Max = 1,
    Text = 'Prediction',
    Callback = function(_1179) end,
    Rounding = 2,
})
_call712:AddToggle('ToFAimToggle', {
    Text = 'Silent Aim Twist of Fate',
    Default = false,
    Callback = function(_1182) end,
})
_call712:AddDropdown('ToFAimTarget', {
    Callback = function(_1185) end,
    Text = 'Target Mode',
    Default = 1,
    Values = {
        [1] = 'Killer',
        [2] = 'Survivors',
        [3] = 'Zombie',
    },
})
_call712:AddToggle('ToFAimPredict', {
    Text = 'Aim Prediction',
    Default = true,
    Callback = function(_1188) end,
})
_call712:AddToggle('ToFAimLaser', {
    Text = 'Show Laser',
    Default = true,
    Callback = function(_1191) end,
})
_call712:AddToggle('ToFAimWallCheck', {
    Text = 'Wall Check',
    Default = false,
    Callback = function(_1194) end,
})
_call712:AddToggle('ToFAimBlockKnocked', {
    Text = 'Block When Knocked',
    Default = true,
    Callback = function(_1197) end,
})
_call712:AddSlider('ToFPredictSpeed', {
    Min = 100,
    Default = 400,
    Max = 1500,
    Text = 'Predict Bullet Speed',
    Callback = function(_1200) end,
    Rounding = 0,
})
_call712:AddSlider('ToFVerticalDot', {
    Min = -1,
    Default = 0.5,
    Max = 1,
    Text = 'Vertical Dot (Survivor/Zombie)',
    Callback = function(_1203) end,
    Rounding = 2,
})
_call712:AddDropdown('ToFKeybind', {
    Callback = function(_1206) end,
    Text = 'Toggle Key',
    Default = 1,
    Values = {
        [1] = 'None',
        [2] = 'Q',
        [3] = 'E',
        [4] = 'R',
        [5] = 'T',
        [6] = 'F',
        [7] = 'G',
        [8] = 'H',
        [9] = 'J',
        [10] = 'K',
        [11] = 'L',
        [12] = 'X',
        [13] = 'Z',
    },
})
_call718:AddCheckbox('WalkSpeedToggle', {
    Text = 'Walk Speed',
    Default = false,
    Callback = function(_1209) end,
})
_call718:AddButton({
    Func = function() end,
    Text = 'Fly GUI',
})
_call718:AddSlider('WalkSpeedSlider', {
    Min = 16,
    Default = 1000,
    Max = 1000,
    Text = 'Walk Speed Value',
    Callback = function(_1215) end,
    Rounding = 1,
})
_call718:AddCheckbox('NoClipToggle', {
    Text = 'No Clip',
    Default = false,
    Callback = function(_1218) end,
})
_call718:AddCheckbox('JumpPowerToggle', {
    Text = 'Custom Jump Power',
    Default = false,
    Callback = function(_1221) end,
})
_call718:AddSlider('JumpPowerSlider', {
    Min = 0,
    Default = 50,
    Max = 300,
    Text = 'Jump Power Value',
    Callback = function(_1224) end,
    Rounding = 0,
})
_call720:AddToggle('FakeTagEnabled', {
    Text = 'Enable Fake Tag',
    Default = false,
    Callback = function(_1227) end,
})
_call720:AddInput('FakeTagText', {
    Finished = true,
    Default = '[Kanzyu_script]',
    Numeric = false,
    Text = 'Chat Tag',
    Callback = function(_1230) end,
    Placeholder = '[Kanzyu_script]',
})
_call724:AddButton({
    Callback = function() end,
    Text = 'Apply Korless',
})
_call722:AddToggle('HideName', {
    Text = 'Streamer Mode',
    Default = false,
    Callback = function(_1236) end,
})
_call722:AddCheckbox('Fullbright', {
    Text = 'Fullbright',
    Default = false,
    Callback = function(_1239) end,
})
_call722:AddCheckbox('NoShadow', {
    Text = 'No Shadow',
    Default = false,
    Callback = function(_1242) end,
})
_call722:AddCheckbox('LowGraphics', {
    Text = 'Low Graphics',
    Default = false,
    Callback = function(_1245) end,
})
_call722:AddCheckbox('NoScreenEffects', {
    Text = 'No Screen Effects',
    Default = false,
    Callback = function(_1248) end,
})
_call722:AddCheckbox('CleanSky', {
    Text = 'Clean Sky',
    Default = false,
    Callback = function(_1251) end,
})
_call728:AddCheckbox('ThirdPersonToggle', {
    Text = 'Third Person View',
    Default = false,
    Callback = function(_1254) end,
})
_call728:AddToggle('UnlimitedZoom', {
    Text = 'Unlimited Zoom Out',
    Default = false,
    Callback = function(_1257) end,
})
_call728:AddSlider('MaxZoomDistance', {
    Min = 100,
    Default = 1000,
    Max = 5000,
    Text = 'Max Zoom Distance',
    Callback = function(_1260) end,
    Rounding = 0,
})
_call728:AddToggle('CustomFOV', {
    Text = 'Custom FOV',
    Default = false,
    Callback = function(_1263) end,
})
_call728:AddSlider('CameraFOV', {
    Min = 40,
    Default = 70,
    Max = 120,
    Text = 'Camera FOV',
    Callback = function(_1266) end,
    Rounding = 0,
})
_call726:AddSlider('ClockTime', {
    Min = 0,
    Default = 14,
    Max = 24,
    Text = 'Clock Time',
    Callback = function(_1269) end,
    Rounding = 0,
})
_call726:AddSlider('Brightness', {
    Min = 0,
    Default = 2,
    Max = 5,
    Text = 'Brightness',
    Callback = function(_1272) end,
    Rounding = 1,
})
_call730:AddToggle('ShowCustomCursor', {
    Text = 'Custom Cursor',
    Default = true,
    Callback = function(_1275) end,
})
_call730:AddDropdown('NotificationSide', {
    Callback = function(_1278) end,
    Text = 'Notification Side',
    Default = 'Right',
    Values = {
        [1] = 'Left',
        [2] = 'Right',
    },
})
_call730:AddDropdown('DPIDropdown', {
    Callback = function(_1281) end,
    Text = 'DPI Scale',
    Default = '85%%',
    Values = {
        [1] = '50%',
        [2] = '75%',
        [3] = '85%',
        [4] = '100%',
        [5] = '125%',
        [6] = '150%',
    },
})
_call730:AddToggle('HeaderGlowToggle', {
    Text = 'Glow AccentBar',
    Default = true,
    Callback = function(_1284) end,
})
_call730:AddToggle('ShowProfile', {
    Text = 'Show Profile',
    Default = true,
    Callback = function(_1287) end,
})
_call730:AddDivider()
_call730:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', {
    NoUI = true,
    Default = 'RightShift',
    Text = 'Menu keybind',
})
_call730:AddButton('Unload script', function() end)
_9:SetLibrary(_5)
_13:SetLibrary(_5)
_13:IgnoreThemeSettings()
_13:SetIgnoreIndexes({})
_9:SetFolder('Kanzyu_script')
_13:SetFolder('Kanzyu_script/configs')
_13:BuildConfigSection(_call694)
_9:ApplyToTab(_call694)
_13:LoadAutoloadConfig()
