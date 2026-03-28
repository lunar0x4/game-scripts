local ok = loadstring(game:HttpGet("https://raw.githubusercontent.com/lunar0x4/game-scripts/refs/heads/main/scripts/exec_check.lua"))()
if not ok then return end

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Innovation INC Spaceship Engine Control by lunar0x4", "GrapeTheme")
local Tab = Window:NewTab("Engines")
local TempTab = Window:NewTab("Temperatures")
local Section = Tab:NewSection("Automation")
local TempSection = TempTab:NewSection("Live Engine Stats")

local frame = workspace:WaitForChild("Engies"):FindFirstChild("SurfaceGui"):FindFirstChild("Frame")

local autoOn = false
local autoOff = false

Section:NewToggle("Auto Turn ON Engines", "Helps heat up the core and heat up the engines.", function(state)
    autoOn = state

    task.spawn(function()
        while autoOn do
            for _, obj in ipairs(frame:GetChildren()) do
                if obj:IsA("TextButton") then
                    if obj.BackgroundColor3 == Color3.fromRGB(255,0,0) then
                        local num = tonumber(obj.Name:match("%d+"))
                        if num then
                            local engineName = "Engine" .. num .. num
                            local engine = workspace.Engies:FindFirstChild(engineName)

                            if engine and engine:FindFirstChild("ClickDetector") then
                                fireclickdetector(engine.ClickDetector)
                            end
                        end
                    end
                end
            end

            task.wait(0.3)
        end
    end)
end)

Section:NewToggle("Auto Turn OFF Engines", "Cools down the engines.", function(state)
    autoOff = state

    task.spawn(function()
        while autoOff do
            for _, obj in ipairs(frame:GetChildren()) do
                if obj:IsA("TextButton") then
                    if obj.BackgroundColor3 == Color3.fromRGB(79,159,0) then
                        local num = tonumber(obj.Name:match("%d+"))
                        if num then
                            local engineName = "Engine" .. num .. num
                            local engine = workspace.Engies:FindFirstChild(engineName)

                            if engine and engine:FindFirstChild("ClickDetector") then
                                fireclickdetector(engine.ClickDetector)
                            end
                        end
                    end
                end
            end

            task.wait(0.3)
        end
    end)
end)

Section:NewButton("Repair Engines", "Repairs the engines.", function()
    for i = 1,20 do
		for _,engine in pairs(workspace:GetDescendants()) do
    		if engine:IsA("ClickDetector") and engine.Parent.Parent.Name == "RepairButton" then
        		fireclickdetector(engine)
        		task.wait(0.1)
    		end
		end
	end
end)

local tempLabels = {}

for i = 1, 7 do
    tempLabels[i] = TempSection:NewLabel("Engine " .. i .. ": Loading...")
end

task.spawn(function()
    while true do
        for i = 1, 7 do
            local tempFolder = workspace.CollisionDanger.SurfaceGui.ImageLabel:FindFirstChild("Temp" .. i)

            if tempFolder then
                local tempObj = tempFolder:FindFirstChild("Value")

                if tempObj and tempObj:IsA("DoubleConstrainedValue") then
                    local rawTemp = tempObj.Value
                    local rounded = math.floor(rawTemp + 0.5)

                    tempLabels[i]:UpdateLabel("Engine " .. i .. ": " .. rounded .. "°C")
                else
                    tempLabels[i]:UpdateLabel("Engine " .. i .. ": N/A")
                end
            else
                tempLabels[i]:UpdateLabel("Engine " .. i .. ": N/A")
            end
        end

        task.wait(3)
    end
end)
