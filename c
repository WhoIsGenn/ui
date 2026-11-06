-- ----------------------------------------------------
-- Тһіѕ Ѕcrіpt Ԝаѕ Dеobfuѕсаtеԁ Ву LеaκD
-- https://leakd.fr
-- ----------------------------------------------------

local coreGui = game:GetService("CoreGui")
local userInputService = game:GetService("UserInputService")
local httpService = game:GetService("HttpService")
local workspaceService = game:GetService("Workspace")
local proximityPromptService = game:GetService("ProximityPromptService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")

if not game:IsLoaded() then
  game.Loaded:Wait()
end

local localPlayer = players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local v1 = isfolder and not isfolder("OpahX")
local v2 = {}

pcall(function()
  if isfile and readfile and isfile("OpahX/OpahHelper.json") then
    local jsonDecode = httpService:JSONDecode(readfile("OpahX/OpahHelper.json"))

    if type(jsonDecode) == "table" then
      v2 = jsonDecode
    end
  end
end)

local function f1()
  pcall(function()
    if writefile then
      writefile("OpahX/OpahHelper.json", httpService:JSONEncode(v2))
    end
  end)
end

local color = Color3.fromRGB(60, 255, 60)
local color2 = Color3.fromRGB(245, 245, 245)
local color3 = Color3.fromRGB(0, 0, 0)

local v3 = {
  State = {
    GhostESP = false,
    ItemESP = false,
    EvidenceESP = false,
    Fullbright = false,
    SunBrightFullbright = false,
    UpdateDelay = 1,
  },
}

local flag = true
local list = {}

local function getConnect(connect)
  list[#list + 1] = connect
  return connect
end

local function addCorner(parent, p1)
  local uiCorner = Instance.new("UICorner")
  uiCorner.CornerRadius = UDim.new(0, p1 or 4)
  uiCorner.Parent = parent
end

local function addPadding(parent2, p2)
  local uiPadding = Instance.new("UIPadding")
  local udim = UDim.new(0, p2)

  uiPadding.PaddingBottom = UDim.new(0, p2)
  uiPadding.PaddingTop = udim

  local udim2 = UDim.new(0, p2)

  uiPadding.PaddingRight = UDim.new(0, p2)
  uiPadding.PaddingLeft = udim2
  uiPadding.Parent = parent2
end

local function getGsub(p3)
  return (tostring(p3):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

local function f2(input)
  return input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch
end

local function f3(input2)
  return input2.UserInputType == Enum.UserInputType.MouseMovement
    or input2.UserInputType == Enum.UserInputType.Touch
end

local opahX = Instance.new("ScreenGui")
opahX.Name = "OpahX"
opahX.ResetOnSpawn = false
opahX.IgnoreGuiInset = true
opahX.DisplayOrder = 999
opahX.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if not pcall(function() opahX.Parent = gethui and gethui() or coreGui end) then
  opahX.Parent = playerGui
end

v3.gui = opahX

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(400, 540)
main.Position = UDim2.new(1, -424, 0, 60)
main.BackgroundColor3 = color3
main.BackgroundTransparency = 0.25
main.BorderSizePixel = 0
main.ClipsDescendants = true

addCorner(main, 14)
main.Parent = opahX

local frame = Instance.new("Frame")
frame.Size = UDim2.new(1, 0, 0, 46)
frame.BackgroundColor3 = color3
frame.BorderSizePixel = 0

addCorner(frame, 14)
frame.Parent = main

local frame2 = Instance.new("Frame")
frame2.Size = UDim2.new(1, 0, 0, 14)
frame2.Position = UDim2.new(0, 0, 1, -14)
frame2.BackgroundColor3 = color3
frame2.BorderSizePixel = 0
frame2.Parent = frame

local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, 0, 0, 30)
textLabel.BackgroundTransparency = 1
textLabel.Font = Enum.Font.GothamBold
textLabel.TextSize = 18
textLabel.TextColor3 = color
textLabel.Text = "Malam Sama Opah"
textLabel.Parent = frame

local textLabel2 = Instance.new("TextLabel")
textLabel2.Size = UDim2.new(1, 0, 0, 14)
textLabel2.Position = UDim2.new(0, 0, 0, 28)
textLabel2.BackgroundTransparency = 1
textLabel2.Font = Enum.Font.GothamMedium
textLabel2.TextSize = 12
textLabel2.TextColor3 = color2
textLabel2.Text = "Made by YourBae"
textLabel2.Parent = frame

local textButton = Instance.new("TextButton")
textButton.Size = UDim2.new(0, 26, 0, 22)
textButton.Position = UDim2.new(1, -62, 0, 6)
textButton.BackgroundColor3 = color
textButton.BorderSizePixel = 0
textButton.Font = Enum.Font.GothamBold
textButton.TextSize = 16
textButton.TextColor3 = color3
textButton.Text = "_"

addCorner(textButton, 6)
textButton.Parent = frame

local textButton2 = Instance.new("TextButton")
textButton2.Size = UDim2.new(0, 26, 0, 22)
textButton2.Position = UDim2.new(1, -32, 0, 6)
textButton2.BackgroundColor3 = color
textButton2.BorderSizePixel = 0
textButton2.Font = Enum.Font.GothamBold
textButton2.TextSize = 14
textButton2.TextColor3 = color3
textButton2.Text = "X"

addCorner(textButton2, 6)
textButton2.Parent = frame

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Position = UDim2.new(0, 0, 0, 46)
scrollingFrame.Size = UDim2.new(1, 0, 1, -46)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.BorderSizePixel = 0
scrollingFrame.ScrollBarThickness = 4
scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
scrollingFrame.CanvasSize = UDim2.new()
scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollingFrame.Parent = main

addPadding(scrollingFrame, 8)

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Padding = UDim.new(0, 6)
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Parent = scrollingFrame

local count = 0

local function getCount()
  count = count + 1
  return count
end

v3.nextOrder = getCount

function v3.paragraph(title, content)
  local textLabel3 = Instance.new("TextLabel")
  textLabel3.Size = UDim2.new(1, 0, 0, 0)
  textLabel3.AutomaticSize = Enum.AutomaticSize.Y
  textLabel3.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
  textLabel3.BackgroundTransparency = 0.4
  textLabel3.BorderSizePixel = 0
  textLabel3.Font = Enum.Font.GothamMedium
  textLabel3.TextSize = 13
  textLabel3.TextColor3 = color2
  textLabel3.TextXAlignment = Enum.TextXAlignment.Left
  textLabel3.TextYAlignment = Enum.TextYAlignment.Top
  textLabel3.TextWrapped = true
  textLabel3.RichText = true
  textLabel3.LayoutOrder = getCount()

  addPadding(textLabel3, 8)
  addCorner(textLabel3, 8)
  textLabel3.Parent = scrollingFrame
  local v4 = {}
  local v5

  function v4:Set(p4)
    local title2 = p4.Title or ""
    local find = title2:find("Hunting", 1, true) and "#FF4040" or "#3CFF3C"

    local v6 = '<font color="' .. find .. '"><b>' .. getGsub(title2) .. [[
</b></font>
]] .. getGsub(p4.Content or "")

    if v6 ~= v5 then
      v5 = v6
      textLabel3.Text = v6
    end
  end

  v4:Set({ Title = title, Content = content })

  return v4
end

function v3.group()
  local frame3 = Instance.new("Frame")
  frame3.Size = UDim2.new(1, 0, 0, 0)
  frame3.AutomaticSize = Enum.AutomaticSize.Y
  frame3.BackgroundTransparency = 1
  frame3.LayoutOrder = getCount()
  frame3.Parent = scrollingFrame

  local uiGridLayout = Instance.new("UIGridLayout")
  uiGridLayout.CellSize = UDim2.new(0.5, -3, 0, 28)
  uiGridLayout.CellPadding = UDim2.fromOffset(6, 6)
  uiGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
  uiGridLayout.Parent = frame3

  return frame3
end

local function makeTextButton(parent3, text)
  local textButton3 = Instance.new("TextButton")
  textButton3.BackgroundColor3 = color2
  textButton3.BorderSizePixel = 0
  textButton3.AutoButtonColor = false
  textButton3.Font = Enum.Font.GothamBold
  textButton3.TextSize = 13
  textButton3.TextColor3 = color3
  textButton3.TextWrapped = true
  textButton3.Text = text
  textButton3.LayoutOrder = getCount()

  if parent3 == scrollingFrame then
    textButton3.Size = UDim2.new(1, 0, 0, 28)
  end

  addCorner(textButton3, 8)
  textButton3.Parent = parent3
  return textButton3
end

function v3.button(p5, p6, layoutOrder, p7)
  local textButton4 = makeTextButton(p5, p6)
  textButton4.LayoutOrder = layoutOrder
  textButton4.MouseButton1Click:Connect(function() end)

  return textButton4
end

function v3.toggle(p8, p9, key, p10, p11)
  local v7 = v2[key] == true
  local textButton5 = makeTextButton(p8, p9)

  local function f4()
    textButton5.BackgroundColor3 = v7 and (p11 or color) or color2
  end

  textButton5.MouseButton1Click:Connect(function()
    v7 = not v7
    v2[key] = v7
    f1()
    f4()
    pcall(p10, v7)
  end)

  f4()
  pcall(p10, v7)
  return textButton5
end

function v3.slider(text2, key2, p12, p13, text3, p14, text4, p15)
  local clamped = math.clamp(tonumber(v2[key2]) or p14, p12, p13)

  local frame4 = Instance.new("Frame")
  frame4.Size = UDim2.new(1, 0, 0, 40)
  frame4.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
  frame4.BackgroundTransparency = 0.4
  frame4.BorderSizePixel = 0
  frame4.LayoutOrder = getCount()
  frame4.Parent = scrollingFrame

  addCorner(frame4, 8)

  local textLabel4 = Instance.new("TextLabel")
  textLabel4.Size = UDim2.new(1, -16, 0, 18)
  textLabel4.Position = UDim2.new(0, 8, 0, 3)
  textLabel4.BackgroundTransparency = 1
  textLabel4.Font = Enum.Font.GothamMedium
  textLabel4.TextSize = 13
  textLabel4.TextColor3 = color2
  textLabel4.TextXAlignment = Enum.TextXAlignment.Left
  textLabel4.Parent = frame4

  local frame5 = Instance.new("Frame")
  frame5.Size = UDim2.new(1, -16, 0, 10)
  frame5.Position = UDim2.new(0, 8, 0, 25)
  frame5.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
  frame5.BorderSizePixel = 0
  frame5.Parent = frame4

  local frame6 = Instance.new("Frame")
  frame6.BackgroundColor3 = color
  frame6.BorderSizePixel = 0
  frame6.Size = UDim2.new(0, 0, 1, 0)
  frame6.Parent = frame5

  addCorner(frame5, 6)
  addCorner(frame6, 6)

  local function f5()
    textLabel4.Text = text2 .. ": "
      .. (text3 < 1 and string.format("%.1f", clamped) or tostring(clamped)) .. " " .. text4

    frame6.Size = UDim2.new((clamped - p12) / (p13 - p12), 0, 1, 0)
  end

  local function f6(x)
    local clamped2 = math.clamp((x - frame5.AbsolutePosition.X)
      / math.max(frame5.AbsoluteSize.X, 1), 0, 1)

    local rounded = math.floor((p12 + (p13 - p12) * clamped2) / text3 + 0.5)
    local clamped3 = math.clamp(rounded * text3, p12, p13)

    if clamped3 ~= clamped then
      clamped = clamped3
      v2[key2] = clamped3
      f5()
      pcall(p15, clamped3)
    end
  end

  local flag2 = false

  frame5.InputBegan:Connect(function(input3)
    if f2(input3) then
      flag2 = true
      f6(input3.Position.X)
    end
  end)

  getConnect(userInputService.InputChanged:Connect(function(input4)
    if flag2 and f3(input4) then
      f6(input4.Position.X)
    end
  end))

  getConnect(userInputService.InputEnded:Connect(function(input5)
    if flag2 and f2(input5) then
      flag2 = false
      f1()
    end
  end))

  f5()
  pcall(p15, clamped)
end

local map = {
  PuzzleItems = true,
  FrontDoor = true,
  HidingWardrobes = true,
  FlipFlops = true,
  PuzzleChests = true,
}

local v8 = {}

for key3 in pairs(map) do
  v8[key3] = {}
end

local seen = {}
local v9 = {}

local function getName(p16)
  local parent4 = p16

  while parent4 and parent4.Parent ~= workspaceService do
    parent4 = parent4.Parent
  end

  return parent4 and map[parent4.Name] and parent4.Name or nil
end

local f7

local function f8(descendant)
  seen[descendant] = true
  local name = getName(descendant)

  if name then
    v8[name][descendant] = true
    v9[descendant] = name
  end

  if f7 then
    f7(descendant)
  end
end

local function f9(descendant2)
  seen[descendant2] = nil
  local v10 = v9[descendant2]

  if v10 then
    v8[v10][descendant2] = nil
    v9[descendant2] = nil
  end
end

task.spawn(function()
  for _, value in ipairs(workspaceService:GetDescendants()) do
    if value:IsA("ProximityPrompt") then
      f8(value)
    end
  end
end)

getConnect(workspaceService.DescendantAdded:Connect(function(descendant3)
  if descendant3:IsA("ProximityPrompt") then
    f8(descendant3)
  end
end))

getConnect(workspaceService.DescendantRemoving:Connect(function(descendant4)
  if descendant4:IsA("ProximityPrompt") then
    f9(descendant4)
  end
end))

local v11 = {
  keys = {},
  note = nil,
  locks = {},
  keypad = nil,
  wards = {},
  ff = {},
  chests = {},
}

-- https://leakd.fr
local v12 = 0

local function getParent(note)
  local parent5 = note.Parent

  if parent5 and parent5:IsA("Attachment") then
    return parent5.Parent
  end

  return parent5
end

local function f10(instance)
  local parent6 = instance.Parent

  if parent6 and parent6:IsA("Attachment") then
    return parent6.WorldPosition
  end

  if parent6 and parent6:IsA("BasePart") then
    return parent6.Position
  end

  local basePart = instance:FindFirstAncestorWhichIsA("BasePart")
  return basePart and basePart.Position
end

local function getEnabled(note2)
  return note2 and note2.Parent ~= nil and note2.Enabled
end

local function f11(p17)
  local now = os.clock()

  if not p17 and now - v12 < 0.4 then
    return
  end

  v12 = now
  local locks = {}
  local keys = {}
  local wards = {}
  local ff = {}
  local keypad
  local note3
  local chests = {}

  for key4 in pairs(v8.PuzzleItems) do
    local objectText = key4.ObjectText

    if objectText == "Passcode Note" then
      note3 = key4
    elseif objectText:find(" Key$") then
      keys[#keys + 1] = key4
    end
  end

  for key5 in pairs(v8.FrontDoor) do
    local objectText2 = key5.ObjectText

    if objectText2:find("Padlock") then
      locks[#locks + 1] = key5
    elseif objectText2 == "Keypad" then
      keypad = key5
    end
  end

  for key6 in pairs(v8.HidingWardrobes) do
    wards[#wards + 1] = key6
  end

  for key7 in pairs(v8.FlipFlops) do
    ff[#ff + 1] = key7
  end

  for key8 in pairs(v8.PuzzleChests) do
    chests[#chests + 1] = key8
  end

  v11.chests = chests
  v11.ff = ff
  v11.wards = wards
  v11.keypad = keypad
  v11.locks = locks
  v11.note = note3
  v11.keys = keys
end

local function getOpah()
  local opah = workspaceService:FindFirstChild("Opah")
  return opah, opah and opah:FindFirstChild("HumanoidRootPart")
end

local function getHumanoidRootPart()
  return localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
end

local map2 = setmetatable({}, { __mode = "k" })
local list2 = {}

function f7(p18)
end

local function f12(p19)
  for _, value2 in ipairs(list2) do
    pcall(function() value2:Disconnect() end)
  end

  list2 = {}

  if p19 then
    for _ in pairs(seen) do
    end

    list2[1] = proximityPromptService.PromptShown:Connect(function(p20) end)
    list2[2] = proximityPromptService.PromptButtonHoldBegan:Connect(function(player) end)
  else
    for key9, value3 in pairs(map2) do
      if key9.Parent then
        pcall(function() key9.HoldDuration = value3 end)
      end
    end

    map2 = setmetatable({}, { __mode = "k" })
  end
end

local opahXESP = Instance.new("ScreenGui")
opahXESP.Name = "OpahX_ESP"
opahXESP.ResetOnSpawn = false
opahXESP.IgnoreGuiInset = true
opahXESP.DisplayOrder = 998

if not pcall(function() opahXESP.Parent = gethui and gethui() or coreGui end) then
  opahXESP.Parent = playerGui
end

local v13 = {
  Red = Color3.fromRGB(255, 70, 70),
  Blue = Color3.fromRGB(70, 140, 255),
  Green = Color3.fromRGB(70, 255, 90),
  Yellow = Color3.fromRGB(255, 235, 70),
  Purple = Color3.fromRGB(190, 100, 255),
}

local map3 = {}

local function f13(p21)
  p21.bb:Destroy()

  if p21.hl then
    p21.hl:Destroy()
  end
end

local function f14()
  for key10, value4 in pairs(map3) do
    f13(value4)
    map3[key10] = nil
  end
end

local function f15()
  local list3 = {}

  for _, value5 in ipairs(v11.chests) do
    if value5.Parent and value5.ActionText == "Open" then
      local v14 = f10(value5)

      if v14 then
        list3[#list3 + 1] = v14
      end
    end
  end

  return list3
end

local function f16(p22, p23)
  for i = 1, #p22 do
    if (p22[i] - p23).Magnitude <= 4 then
      return true
    end
  end

  return false
end

task.spawn(function()
  local v15 = 0

  while flag do
    local state = v3.State
    local espKey = state.EspKey
    local v16 = espKey

    if not espKey then
      local espNote = state.EspNote or state.EspKeypad or state.EspPadlock or state.EspOpah
        or state.EspFlipFlop or state.EspWardNear

      v16 = espNote
    end

    if v16 then
      local now2 = os.clock()

      if now2 - v15 >= state.UpdateDelay then
        f11(true)
        v15 = now2
      end

      task.wait(0.25)
    else
      if next(map3) then
        f14()
      end

      task.wait(0.5)
    end
  end
end)

local function getGetAttribute(p24)
  local getAttribute = localPlayer:GetAttribute(p24)

  if getAttribute == nil and localPlayer.Character then
    getAttribute = localPlayer.Character:GetAttribute(p24)
  end

  return getAttribute
end

local v17

task.spawn(function()
  local waitForChild = replicatedStorage

  for _, value6 in ipairs({ "PuzzleShared", "Remotes", "PuzzleRemote" }) do
    waitForChild = waitForChild and waitForChild:WaitForChild(value6, 10)
  end

  if waitForChild then
    getConnect(waitForChild.OnClientEvent:Connect(function(p25, p26, p27)
      if p25 == "Held" and p26 == "Passcode" and type(p27) == "string" then
        v17 = p27
      end
    end))
  end
end)

local function f17()
  local note4 = v11.note
  local model = note4 and (note4:FindFirstAncestorOfClass("Model") or getParent(note4))

  if not model then
    return nil
  end

  for _, value7 in ipairs(model:GetDescendants()) do
    if (value7:IsA("TextLabel") or value7:IsA("TextBox"))
      and value7.Text:match("^%s*%d%d%d+%s*$") then
      return value7.Text:match("%d+")
    end
  end
end

v3.ItemsP = v3.paragraph("Objects", "Scanning...")

v3.CodeP = v3.paragraph(
  "Passcode Note", "Not recorded yet. Pick up the note to record the code."
)

v3.toggles = v3.group()

local function f18(p28, key11, p29, p30)
  v3.toggle(v3.toggles, p28, key11, function(p31)
    v3.State[key11] = p31

    if p30 then
      p30(p31)
    end
  end, p29)
end

f18("ESP Key", "EspKey")
f18("ESP Keypad", "EspKeypad")
f18("ESP Passcode Note", "EspNote")
f18("ESP Padlock", "EspPadlock")
f18("ESP Flip Flop (Nearest 3)", "EspFlipFlop")
f18("ESP Wardrobe (Nearest)", "EspWardNear")
f18("ESP Opah", "EspOpah")
f18("Instant Prompt", "InstantPrompt", nil, f12)

v3.slider("Update Delay", "UpdateDelay", 0.5, 5, 0.5, 1, "sec", function(updateDelay)
  v3.State.UpdateDelay = updateDelay
end)

function v3.onClose()
  pcall(f12, false)
  pcall(f14)
  pcall(function() opahXESP:Destroy() end)
end

local flag3 = false
local v18

task.spawn(function()
  local now3 = 0

  while flag do
    if main.Visible and not flag3 then
      if os.clock() - v12 >= 1 then
        pcall(f11, true)
      end

      local count2 = 0
      local count3 = 0

      for _, value8 in ipairs(v11.keys) do
        if getEnabled(value8) then
          count2 = count2 + 1
        end
      end

      local v19 = f15()

      for _, value9 in ipairs(v11.ff) do
        local v20 = getEnabled(value9) and f10(value9)

        if v20 and not f16(v19, v20) then
          count3 = count3 + 1
        end
      end

      local humanoidRootPart = getHumanoidRootPart()
      local v21

      if humanoidRootPart then
        local position = humanoidRootPart.Position

        for _, value10 in ipairs(v11.wards) do
          local v22 = getEnabled(value10) and f10(value10)

          if v22 then
            local magnitude = (v22 - position).Magnitude

            if not v21 or magnitude < v21 then
              v21 = magnitude
            end
          end
        end
      end

      local _, humanoidRootPart2 = getOpah()

      local rounded2 = humanoidRootPart2 and humanoidRootPart
          and math.floor((humanoidRootPart2.Position - humanoidRootPart.Position).Magnitude)
        or nil

      local itemsP = v3.ItemsP
      local v23 = "Title"
      local v24 = "Objects"

      itemsP:Set({
        [v23] = v24,
        Content = "Active keys: " .. count2 .. " | Note: "
          .. (v11.note and getEnabled(v11.note) and "found" or "-") .. " | Flip Flops: "
          .. count3 .. " | Wardrobes: " .. #v11.wards .. "\nNearest wardrobe: "
          .. (v21 and math.floor(v21) .. " studs" or "-") .. "\nOpah: "
          .. (rounded2 and rounded2 .. " studs" or "-"),
      })
    end

    if not v18 then
      local puzzleHeldCode = getGetAttribute("PuzzleHeldCode") or v17

      if not puzzleHeldCode and os.clock() - now3 >= 3 then
        now3 = os.clock()
        puzzleHeldCode = f17()
      end

      if puzzleHeldCode then
        v18 = tostring(puzzleHeldCode)
      end
    else
      local puzzleHeldCode2 = getGetAttribute("PuzzleHeldCode") or v17

      if puzzleHeldCode2 and tostring(puzzleHeldCode2) ~= v18 then
        v18 = tostring(puzzleHeldCode2)
      end
    end

    if main.Visible and not flag3 then
      local codeP = v3.CodeP
      local v25 = "Title"
      local v26 = "Passcode Note"
      local v27 = "Content"

      codeP:Set({
        [v25] = v26,
        [v27] = v18 and "Code: " .. v18
          or "Not recorded yet. Pick up the note to record the code.",
      })
    end

    task.wait(1)
  end
end)

textButton.MouseButton1Click:Connect(function()
  flag3 = not flag3
  scrollingFrame.Visible = not flag3
  frame2.Visible = not flag3
  main.Size = flag3 and UDim2.fromOffset(400, 46) or UDim2.fromOffset(400, 540)
end)

getConnect(userInputService.InputBegan:Connect(function(input6)
  if input6.KeyCode == Enum.KeyCode.LeftAlt then
    main.Visible = not main.Visible
  end
end))

local inputBegan = frame.InputBegan
local v28, position2

inputBegan:Connect(function(p32)
  if f2(p32) then
    local position3 = p32.Position
    position2 = main.Position
    v28 = position3
  end
end)

getConnect(userInputService.InputChanged:Connect(function(input7)
  if v28 and f3(input7) then
    local v29 = input7.Position - v28

    main.Position = UDim2.new(
      position2.X.Scale, position2.X.Offset + v29.X, position2.Y.Scale,
      position2.Y.Offset + v29.Y
    )
  end
end))

getConnect(userInputService.InputEnded:Connect(function(input8)
  if f2(input8) then
    v28 = nil
  end
end))

function v3.destroy()
  pcall(function() opahX:Destroy() end)
end

textButton2.MouseButton1Click:Connect(function()
  flag = false

  for _, value11 in ipairs(list) do
    pcall(function() value11:Disconnect() end)
  end

  if v3.onClose then
    pcall(v3.onClose)
  end

  v3.destroy()
end)

function v3.isAlive()
  return flag
end

return v3

-- https://leakd.fr
