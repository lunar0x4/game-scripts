local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

local Window = Library.CreateLib("Field Trip Z Hub | github.com/lunar0x4 | V1.0", "GrapeTheme")

local ItemsTab = Window:NewTab("Items")
local ItemsSection = ItemsTab:NewSection("Item Spawning")

local selectedItem = "Donut"

local ItemDropdown = ItemsSection:NewDropdown("Select Item", "Choose which item to give", {"Donut", "Bandage", "Rocket", "BlueKey", "YellowKey", "GoldenDonut", "Homework", "MedKit"}, function(selected)
    selectedItem = selected
end)

ItemsSection:NewButton("Give Selected Item", "Spawns the selected item", function()
    local args = {
        "PICKUP_ITEM",
        selectedItem
    }
    game:GetService("ReplicatedStorage"):WaitForChild("NetworkEvents"):WaitForChild("RemoteFunction"):InvokeServer(unpack(args))
end)

local CombatTab = Window:NewTab("Combat")
local CombatSection = CombatTab:NewSection("Zombie Options")

CombatSection:NewButton("Break Free From Dave", "Breaks free from zombie grab", function()
    local args = {
        "DAVE_BROKE_FREE"
    }
    game:GetService("ReplicatedStorage"):WaitForChild("NetworkEvents"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
end)

CombatSection:NewButton("Kill All Zombies", "Kills every zombie in the game", function()
    local replicatedStorage = game:GetService("ReplicatedStorage")
    local networkEvents = replicatedStorage:WaitForChild("NetworkEvents")
    local remote = networkEvents:WaitForChild("RemoteFunction")
    for _, instance in ipairs(workspace:GetDescendants()) do
        if instance.Name:match("^Zombie") then
            local humanoid = instance:FindFirstChild("Humanoid")
            if humanoid then
                for i = 1, 50 do
                    local args = {
                        "DO_DAMAGE",
                        humanoid,
                        10
                    }
                    remote:InvokeServer(unpack(args))
                    task.wait()
                end
            end
        end
    end
end)

local HealthTab = Window:NewTab("Health")
local HealthSection = HealthTab:NewSection("Healing Options")

local autoHeal = false
local autoHealLoop

HealthSection:NewToggle("Infinite Health", "Continuously heals yourself", function(state)
    autoHeal = state
    if autoHeal then
        autoHealLoop = game:GetService("RunService").Heartbeat:Connect(function()
            local args = {
                "HEAL_PLAYER",
                game:GetService("Players").LocalPlayer,
                50
            }
            game:GetService("ReplicatedStorage"):WaitForChild("NetworkEvents"):WaitForChild("RemoteFunction"):InvokeServer(unpack(args))
        end)
    else
        if autoHealLoop then autoHealLoop:Disconnect() end
    end
end)

HealthSection:NewButton("Heal All Players", "Heals every player in the game", function()
    for _,player in pairs (game:GetService("Players"):GetPlayers()) do
        local args = {
            "HEAL_PLAYER",
            player,
            50
        }
        game:GetService("ReplicatedStorage"):WaitForChild("NetworkEvents"):WaitForChild("RemoteFunction"):InvokeServer(unpack(args))
    end
end)

local loopHealAll = false
local loopHealAllLoop

HealthSection:NewToggle("Loop Heal All Players", "Continuously heals all players", function(state)
    loopHealAll = state
    if loopHealAll then
        loopHealAllLoop = game:GetService("RunService").Heartbeat:Connect(function()
            for _,player in pairs (game:GetService("Players"):GetPlayers()) do
                local args = {
                    "HEAL_PLAYER",
                    player,
                    50
                }
                game:GetService("ReplicatedStorage"):WaitForChild("NetworkEvents"):WaitForChild("RemoteFunction"):InvokeServer(unpack(args))
            end
        end)
    else
        if loopHealAllLoop then loopHealAllLoop:Disconnect() end
    end
end)

local BuildingTab = Window:NewTab("Building")
local BuildingSection = BuildingTab:NewSection("Window Options")

BuildingSection:NewButton("Board Up All Windows", "Planks every window in the map", function()
    local windows = workspace:WaitForChild("Interactions"):WaitForChild("Windows")
    local remote = game:GetService("ReplicatedStorage"):WaitForChild("NetworkEvents"):WaitForChild("RemoteFunction")
    for i = 1,250 do
        for _, window in ipairs(windows:GetChildren()) do
            local args = {
                "PLACE_PLANK",
                window
            }
            remote:InvokeServer(unpack(args))
        end
        task.wait()
    end
end)

local MiscTab = Window:NewTab("Misc")
local MiscSection = MiscTab:NewSection("Console Options")

local autoConsole = false
local autoConsoleLoop

MiscSection:NewToggle("Auto Hit Console (Boss Fight)", "Continuously hits the console", function(state)
    autoConsole = state
    if autoConsole then
        autoConsoleLoop = game:GetService("RunService").Heartbeat:Connect(function()
            local args = {
                "HitConsole"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("NetworkEvents"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
        end)
    else
        if autoConsoleLoop then autoConsoleLoop:Disconnect() end
    end
end)

MiscSection:NewButton("Hit Console (20x) (Boss Fight)", "Hits the console 20 times", function()
    for i = 1,20 do
        local args = {
            "HitConsole"
        }
        game:GetService("ReplicatedStorage"):WaitForChild("NetworkEvents"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
    end
end)
