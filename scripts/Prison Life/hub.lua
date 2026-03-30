local ok = loadstring(game:HttpGet("https://raw.githubusercontent.com/lunar0x4/game-scripts/refs/heads/main/scripts/exec_check.lua"))()
if not ok then return end

local players = game:GetService("Players")
local player = players.LocalPlayer
if workspace[player.Name]:FindFirstChild("AntiJump") then workspace[player.Name].AntiJump:Destroy() print("Antijump Destroyed") end
if workspace:FindFirstChild("BOUNDARY") then workspace.BOUNDARY:Destroy() print("Boundaries destroyed.") end

local arrestLoop = nil

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Prison Life Mini Hub", "GrapeTheme")

local Tab1 = Window:NewTab("Weapons")
local Tab2 = Window:NewTab("Teams")
local Tab3 = Window:NewTab("Fun")
local Tab = Window:NewTab("Scripts")
local Section1 = Tab1:NewSection("Guns")
local Section2 = Tab2:NewSection("Change Teams")
local Section3 = Tab3:NewSection("Auras")
local Section4 = Tab3:NewSection("Auto")
local Section = Tab:NewSection("Cool Scripts")

Section1:NewButton("Get MP5", "free gun.", function()
    local hrp = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
    local ohrp = hrp.CFrame
    hrp.CFrame = workspace.Prison_ITEMS.giver.MP5["Meshes/MP5 (2)"].CFrame
    task.wait(0.2)
    local args = {
        workspace:WaitForChild("Prison_ITEMS"):WaitForChild("giver"):WaitForChild("MP5"):WaitForChild("Meshes/MP5 (2)")
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("InteractWithItem"):InvokeServer(unpack(args))
    task.wait(0.2)
    hrp.CFrame = ohrp
end)

Section1:NewButton("Get AK-47", "free gun.", function()
    local hrp = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
    local ohrp = hrp.CFrame
    hrp.CFrame = workspace.Prison_ITEMS.giver["AK-47"]["Meshes/AK47_7"].CFrame
    task.wait(0.2)
    local args = {
        workspace.Prison_ITEMS.giver["AK-47"]["Meshes/AK47_7"]
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("InteractWithItem"):InvokeServer(unpack(args))
    task.wait(0.2)
    hrp.CFrame = ohrp
end)

Section1:NewButton("Get Remington 870 (shotgun)", "free gun.", function()
    local hrp = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
    local ohrp = hrp.CFrame
    hrp.CFrame = workspace.Prison_ITEMS.giver:GetChildren()[4]["Meshes/r870_2"].CFrame
    task.wait(0.2)
    local args = {
        workspace.Prison_ITEMS.giver:GetChildren()[4]["Meshes/r870_2"]
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("InteractWithItem"):InvokeServer(unpack(args))
    task.wait(0.2)
    hrp.CFrame = ohrp
end)

Section2:NewButton("Become Criminal", "Makes you a criminal", function()
    local hrp = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
    local ohrp = hrp.CFrame
    hrp.CFrame = workspace["Criminals Spawn"].SpawnLocation.CFrame
    task.wait(2)
    hrp.CFrame = ohrp
end)

Section3:NewToggle("Arrest Aura", "Arrests everyone in your path.", function(state)
    if state then
        arrestLoop = game:GetService("RunService").Heartbeat:Connect(function()
            local player = game.Players.LocalPlayer
            local character = player.Character
            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
            
            if humanoidRootPart then
                for _, otherPlayer in pairs(game.Players:GetPlayers()) do
                    if otherPlayer ~= player then
                        local otherCharacter = otherPlayer.Character
                        local otherRootPart = otherCharacter and otherCharacter:FindFirstChild("HumanoidRootPart")
                        
                        if otherRootPart then
                            local distance = (humanoidRootPart.Position - otherRootPart.Position).Magnitude
                            
                            if distance <= 30 then
                                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ArrestPlayer"):InvokeServer(otherPlayer, 1)
                                task.wait() -- prevent overwhelming the server lol
                            end
                        end
                    end
                end
            end
        end)
    else
        if arrestLoop then
            arrestLoop:Disconnect()
            arrestLoop = nil
        end
    end
end)

Section4:NewLabel("WARNING: Auto arrest may be detected by the prison")
Section4:NewLabel("life anti cheat - use at your own risk. The script")
Section4:NewLabel("itself is very slow to try and prevent you being kicked.")
Section4:NewLabel("Equip your handcuffs before running the script.")

Section4:NewButton("Arrest All Criminals", "Teleports behind criminals for 3 seconds and arrests them", function()
    local player = game.Players.LocalPlayer
    
    local function CheckIfDead()
        local character = player.Character
        local humanoid = character and character:FindFirstChild("Humanoid")
        if not character or not humanoid or humanoid.Health <= 0 then
            return true
        end
        return false
    end
    
    local character = player.Character
    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
    
    if not humanoidRootPart then
        return
    end
    
    local criminals = {}
    for _, targetPlayer in pairs(game.Players:GetPlayers()) do
        if targetPlayer ~= player and targetPlayer.Team == game:GetService("Teams").Criminals then
            table.insert(criminals, targetPlayer)
        end
    end
    
    for _, criminal in pairs(criminals) do
        if CheckIfDead() then
            print("Player died, stopping script")
            break
        end
        
        local criminalChar = criminal.Character
        local criminalRoot = criminalChar and criminalChar:FindFirstChild("HumanoidRootPart")
        
        if criminalRoot then
            local startTime = tick()
            local arrested = false
            
            while tick() - startTime < 3 and not arrested do
                if CheckIfDead() then
                    print("Player died, stopping script")
                    return
                end
                
                local lookVector = criminalRoot.CFrame.LookVector
                local behindPosition = criminalRoot.Position - (lookVector * 3)
                humanoidRootPart.CFrame = CFrame.new(behindPosition, criminalRoot.Position)
                
                pcall(function()
                    local result = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ArrestPlayer"):InvokeServer(criminal, 1)
                    if result ~= nil then
                        arrested = true
                    end
                end)
                
                if criminal.Team ~= game:GetService("Teams").Criminals then
                    arrested = true
                end
                
                task.wait()
            end
            
            if arrested then
                print("Successfully arrested: " .. criminal.Name)
            else
                warn("Failed to arrest: " .. criminal.Name)
            end
            
            if CheckIfDead() then
                print("Player died, stopping script")
                return
            end
            
            humanoidRootPart.CFrame = CFrame.new(872, 40, 2344)
            task.wait(20)
        end
    end
    
    print("Finished auto arrest")
end)

Section:NewButton("Aimbot", "Not working on Xeno or Solara.", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/AirHub/main/AirHub.lua"))()
end)

Section:NewButton("Infinite Yield", "A universal script. Works on every game!", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/edgeiy/infiniteyield/master/source"))()
end)
