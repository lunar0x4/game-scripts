-- yes, you can get credits for auto stabilizing the core
local ok = loadstring(game:HttpGet("https://raw.githubusercontent.com/lunar0x4/game-scripts/refs/heads/main/scripts/exec_check.lua"))()
if not ok then return end

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Liquid Submarine Core Stabilizer by lunar0x4", "BloodTheme")

local CoreTab = Window:NewTab("Core")
local CoreSection = CoreTab:NewSection("Core Safety")

local antiMeltdown = false
local antiFreezedown = false
local autoStabilize = false

function StartMeltdown()
    if antiMeltdown then return end
    antiMeltdown = true

    task.spawn(function()
        while antiMeltdown do
            local heatBtn = workspace.Submarine.Heatliquid.Button.Button
            local flameBtn = workspace.Submarine.Flame.Button.Button

            if heatBtn.Color == Color3.fromRGB(170,85,0) or heatBtn.Color == Color3.fromRGB(204,255,94) then
                fireclickdetector(heatBtn.ClickDetector)
            end

            if flameBtn.Color == Color3.fromRGB(170,85,0) then
                fireclickdetector(flameBtn.ClickDetector)
            end

            local iceBtn = workspace.Submarine.IceSpray.Button.Button
            if iceBtn.Color ~= Color3.fromRGB(0,255,0) then
                fireclickdetector(iceBtn.ClickDetector)
            end
            
            local coolantBtn = workspace.Submarine.Coolant.Button.Button
            local waterBtn = workspace.Submarine.Water.Button.Button
            if coolantBtn.Color == Color3.fromRGB(255, 0, 0) then
                fireclickdetector(coolantBtn.ClickDetector)
            end
            
            if waterBtn.Color == Color3.fromRGB(255, 0, 0) then
                fireclickdetector(waterBtn.ClickDetector)
            end

            for i = 1, 4 do
                local fanBtn = workspace.Submarine["Fan"..i.."Switch"].Button.Button
                local c = fanBtn.Color

                if c == Color3.fromRGB(255,0,0) then
                    fireclickdetector(fanBtn.ClickDetector)
                end
            end

            task.wait(0.3)
        end
    end)
end

function StopMeltdown()
    antiMeltdown = false
end

function StartFreezedown()
    if antiFreezedown then return end
    antiFreezedown = true

    task.spawn(function()
        while antiFreezedown do
            local heatBtn = workspace.Submarine.Heatliquid.Button.Button
            local flameBtn = workspace.Submarine.Flame.Button.Button

            if heatBtn.Color == Color3.fromRGB(27,42,53) then
                fireclickdetector(heatBtn.ClickDetector)
            end

            if flameBtn.Color == Color3.fromRGB(27,42,53) then
                fireclickdetector(flameBtn.ClickDetector)
            end

            local iceBtn = workspace.Submarine.IceSpray.Button.Button
            if iceBtn.Color == Color3.fromRGB(0,255,0) then
                fireclickdetector(iceBtn.ClickDetector)
            end
            
            local coolantBtn = workspace.Submarine.Coolant.Button.Button
            local waterBtn = workspace.Submarine.Water.Button.Button
            if coolantBtn.Color == Color3.fromRGB(0, 255, 0) then
                fireclickdetector(coolantBtn.ClickDetector)
            end
            
            if waterBtn.Color == Color3.fromRGB(0, 255, 0) then
                fireclickdetector(waterBtn.ClickDetector)
            end

            for i = 1, 4 do
                local fanBtn = workspace.Submarine["Fan"..i.."Switch"].Button.Button
                local c = fanBtn.Color

                if c == Color3.fromRGB(0,255,0) then
                    fireclickdetector(fanBtn.ClickDetector)
                end
            end

            task.wait(0.3)
        end
    end)
end

function StopFreezedown()
    antiFreezedown = false
end
local label = CoreSection:NewLabel("Status: Turn on toggle...")
local label2 = CoreSection:NewLabel("Core Temperature: Turn on toggle...")
CoreSection:NewToggle("Auto-Stabilize", "Automatically stabilizes the core.", function(state)
    autoStabilize = state

    task.spawn(function()
        while autoStabilize do
            local tempNumber = workspace.CoreTemp.Value

            if tempNumber then
                label2:UpdateLabel("Core Temperature: " .. tempNumber .. "*C")
                if tempNumber < -500 then
                    StopMeltdown()
                    StartFreezedown()
                    label:UpdateLabel("Status: Anti-Freezedown")
                elseif tempNumber > 1500 then
                    StopFreezedown()
                    StartMeltdown()
                    label:UpdateLabel("Status: Anti-Meltdown")
                elseif tempNumber >= -500 and tempNumber <= 1500 then
                    StopMeltdown()
                    StopFreezedown()
                    label:UpdateLabel("Status: Stable/Warning Range")
                end
            end

            task.wait(1)
        end

        StopMeltdown()
        StopFreezedown()
    end)
end)
