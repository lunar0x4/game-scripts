local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

local colors = {
    SchemeColor = Color3.fromRGB(74, 99, 135),
    Background = Color3.fromRGB(36, 37, 43),
    Header = Color3.fromRGB(28, 29, 34),
    TextColor = Color3.fromRGB(255, 255, 255),
    ElementColor = Color3.fromRGB(32, 32, 38)
}

local Window = Library.CreateLib("Funky Friday Hub by lunar0x4", colors)
local Tab = Window:NewTab("Auto Play")
local Section = Tab:NewSection("Main")

local VIM = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local player = game:GetService("Players").LocalPlayer

local keys = {Lane1 = "A", Lane2 = "S", Lane3 = "W", Lane4 = "D"}
local connections = {}
local holding = {}
local currentSide = "Right"

local accuracyPercent = 100

local BASE_WINDOW = 25

local function getMissChance()
    return (100 - accuracyPercent) * 0.6 / 100
end

local function getOffsetPixels()
    local maxOffset = 100
    local factor = (100 - accuracyPercent) / 100
    return math.random(-maxOffset * factor, maxOffset * factor)
end

local function getCenterY(frame)
    return frame.AbsolutePosition.Y + (frame.AbsoluteSize.Y / 2)
end

local function getLanes()
    local pg = player:FindFirstChild("PlayerGui")
    if not pg then return end
    local win = pg:FindFirstChild("Window")
    if not win then return end
    local gameField = win:FindFirstChild("Game")
    if not gameField then return end
    local fields = gameField:FindFirstChild("Fields")
    if not fields then return end
    local side = fields:FindFirstChild(currentSide)
    if not side then return end
    return side:FindFirstChild("Inner")
end

local function stopAutoPlay()
    for note in pairs(holding) do
        local laneNum = string.match(note.Parent.Parent.Name, "Lane(%d+)")
        if laneNum then
            VIM:SendKeyEvent(false, keys["Lane"..laneNum], false, game)
        end
    end

    table.clear(holding)

    for i = 1, 4 do
        if connections[i] then
            connections[i]:Disconnect()
            connections[i] = nil
        end
    end
end

local function startAutoPlay()
    stopAutoPlay()
    local lanes = getLanes()
    if not lanes then return end

    for i = 1, 4 do
        local lane = lanes:FindFirstChild("Lane"..i)
        if not lane then continue end

        local notes = lane:FindFirstChild("Notes")
        local splash = lane:FindFirstChild("Splash")
        if not notes or not splash then continue end

        local splashCenterY = getCenterY(splash)
        local key = keys["Lane"..i]

        connections[i] = RunService.RenderStepped:Connect(function()
            local closestNote = nil
            local closestDist = math.huge

            for _, note in ipairs(notes:GetChildren()) do
                if note:IsA("Frame") and not holding[note] then
                    local dist = math.abs(getCenterY(note) - splashCenterY)
                    if dist < closestDist then
                        closestDist = dist
                        closestNote = note
                    end
                end
            end

            if closestNote and closestDist <= BASE_WINDOW then
                if math.random() < getMissChance() then
                    holding[closestNote] = "ignored"
                    return
                end

                holding[closestNote] = "holding"

                local delayMs = 0
                if accuracyPercent < 100 then
                    delayMs = math.random(0, (100 - accuracyPercent) * 0.8)
                end

                task.delay(delayMs / 1000, function()
                    local offsetY = getOffsetPixels()
                    local adjustedCenter = getCenterY(closestNote) + offsetY

                    if math.abs(adjustedCenter - splashCenterY) <= BASE_WINDOW * 1.5 then
                        VIM:SendKeyEvent(true, key, false, game)
                    end
                end)

                task.spawn(function()
                    while closestNote.Parent and holding[closestNote] == "holding" do
                        local bottomY = closestNote.AbsolutePosition.Y + closestNote.AbsoluteSize.Y
                        if bottomY < splashCenterY then
                            break
                        end
                        RunService.RenderStepped:Wait()
                    end

                    VIM:SendKeyEvent(false, key, false, game)
                    holding[closestNote] = nil
                end)
            end
        end)
    end
end

Section:NewDropdown("Side", "Select your side", {"Right", "Left"}, function(v)
    currentSide = v
end)

Section:NewSlider("Accuracy %", "0% = Trash, 100% = Perfect", 100, 0, function(v)
    accuracyPercent = v
end)

Section:NewToggle("Auto Play", "Enable autoplay", function(state)
    if state then startAutoPlay() else stopAutoPlay() end
end)
