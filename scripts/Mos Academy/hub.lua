local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = "Mo's Academy Hub by lunar0x4",
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local Tabs = {
    Main = Window:AddTab('Main'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

local Giver = Tabs.Main:AddLeftGroupbox('Giver')
local Other = Tabs.Main:AddRightGroupbox('Misc/Other')
local selectedItem = 'Chicken'

Giver:AddDropdown('GiveItem', {
    Values = { 'Chicken', 'Banana', 'Cheese', 'Coffee', 'Apple', 'Hammer', 'Medkit', 'Bat', 'Slingshot', 'Notebook' },
    Default = 1,
    Multi = false,
    Text = 'Give Item',
    Tooltip = 'Select an item to give..',
    Callback = function(Value)
        selectedItem = Value
    end
})

Giver:AddButton({
    Text = 'Give Selected Item',
    Func = function()
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("TakeItem"):FireServer(selectedItem)
    end
})

Giver:AddButton({
    Text = 'Get Money (Method 1)',
    Func = function()
        for i = 1,100 do
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("TakeItem"):FireServer("Money")
            task.wait()
        end
    end,
    DoubleClick = false,
    Tooltip = 'Gives you a TON of money.'
})

Giver:AddButton({
    Text = 'Get Money (Method 2)',
    Func = function()
        for i = 1,100 do
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CCo"):FireServer()
            task.wait()
        end
    end,
    DoubleClick = false,
    Tooltip = 'Gives you a TON of money.'
})


Other:AddButton({
    Text = 'Heal Yourself (Method 1)',
    Func = function()
        for i = 1,10 do
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("TakeItem"):FireServer("Chicken")
            task.wait(1)
            local args = {game:GetService("ReplicatedStorage"):WaitForChild("PlayerData"):WaitForChild(game:GetService("Players").LocalPlayer.Name):WaitForChild("Items"):WaitForChild("Chicken")}
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("UseItem"):FireServer(unpack(args))
            task.wait()
        end
    end,
    DoubleClick = false,
    Tooltip = 'Heals yourself (aka give you mental health)'
})

Other:AddButton({
    Text = 'Heal Yourself (Method 2)',
    Func = function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Remotes = ReplicatedStorage:WaitForChild("Remotes")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local PlayerData = ReplicatedStorage:WaitForChild("PlayerData")
        local PlayerFolder = PlayerData:WaitForChild(LocalPlayer.Name)
        local Items = PlayerFolder:WaitForChild("Items")
        local Notebook = Items:FindFirstChild("Notebook")
        if not Notebook then
            Remotes:WaitForChild("TakeItem"):FireServer("Notebook")
            task.wait(0.5)
            Notebook = Items:FindFirstChild("Notebook")
        end
        
        if Notebook then
            for i = 1, 50 do
                local args = {Notebook}
                Remotes:WaitForChild("UseItem"):FireServer(unpack(args))
                task.wait(0.1)
            end
            print("Used Notebook 50 times!")
        else
            warn("Failed to get Notebook!")
        end
    end,
    DoubleClick = false,
    Tooltip = 'Heals yourself using Notebook (50 times)'
})

Other:AddButton({
    Text = 'Pay Bully',
    Func = function()
        for i = 1,10 do
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("TakeItem"):FireServer("Money")
            task.wait()
        end
        game:GetService("ReplicatedStorage").Remotes.PayBully:FireServer()
    end,
    DoubleClick = false,
    Tooltip = 'Allows you to go into the gym'
})

Other:AddButton({
    Text = 'Get All Keys',
    Func = function()
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Key"):FireServer("GreenKey")
        task.wait()
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Key"):FireServer("BlueKey")
        task.wait()
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Key"):FireServer("RedKey")
        task.wait()
    end,
    DoubleClick = false,
    Tooltip = 'Used on the first day of detention'
})

Other:AddButton({
    Text = 'Loot All Items',
    Tooltip = "Loots all items from the lockers.",
    Func = function()
        local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
        local TakeItem = Remotes:WaitForChild("TakeItem")
        
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:FindFirstChild("ItemInside") and obj.ItemInside.Value ~= "" then
                local item = obj.ItemInside.Value
                TakeItem:FireServer(item)
                obj.ItemInside.Value = ""
                task.wait(0.1)
            end
        end
        print("All items looted!")
    end
})

Other:AddButton({
    Text = 'Get Hamster',
    Func = function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Remotes = ReplicatedStorage:WaitForChild("Remotes")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        Remotes:WaitForChild("TakeItem"):FireServer("Cheese")
        task.wait(0.3)
        local PlayerData = ReplicatedStorage:WaitForChild("PlayerData")
        local PlayerFolder = PlayerData:WaitForChild(LocalPlayer.Name)
        local Items = PlayerFolder:WaitForChild("Items")
        local Cheese = Items:FindFirstChild("Cheese")
        if Cheese then
            Remotes:WaitForChild("EquipItem"):FireServer(true, Cheese)
            task.wait(0.5)
            Remotes:WaitForChild("Hamster"):FireServer()
        else
            warn("Failed to get cheese!")
        end
    end,
    Tooltip = 'Gets cheese, equips it, then gets the hamster'
})

Other:AddButton({
    Text = 'Kill Enemies',
    Func = function()
        local success, err = pcall(function()
            local Players = game:GetService("Players")
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local LocalPlayer = Players.LocalPlayer
            local PlayerData = ReplicatedStorage:WaitForChild("PlayerData", 5)
            local PlayerFolder = PlayerData:WaitForChild(LocalPlayer.Name, 5)
            local Items = PlayerFolder:WaitForChild("Items", 5)
            local Remotes = ReplicatedStorage:WaitForChild("Remotes", 5)
            local Straw = Items:FindFirstChild("Straw")
            if not Straw then
                Remotes:WaitForChild("TakeItem"):FireServer("Straw")
                task.wait(0.5)
                Straw = Items:FindFirstChild("Straw")
                if not Straw then
                    warn("Failed to get Straw!")
                    return
                end
            end
            Remotes:WaitForChild("EquipItem"):FireServer(true, Straw)
            task.wait(1)
            local Enemies = workspace:FindFirstChild("Enemies")
            local StrawModel = workspace:FindFirstChild("Straw")
            if Enemies and StrawModel then
                for i = 1, 100 do
                    for _, enemy in pairs(Enemies:GetChildren()) do
                        if enemy and enemy.Parent then
                            Remotes:WaitForChild("SendD"):FireServer(enemy, StrawModel)
                        end
                    end
                    task.wait()
                end
            end
            Remotes:WaitForChild("EquipItem"):FireServer(false, Straw)
        end)
        if not success then
            warn("Error in Kill Enemies: ", err)
        end
    end,
    DoubleClick = false,
    Tooltip = 'Kills the enemies for you!'
})

Other:AddButton({
    Text = 'Escape From Mo',
    Tooltip = 'Used when you are trying to escape Mo.',
    Func = function()
        local hrp = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
        hrp.CFrame = CFrame.new(0,2,969)
    end
})

local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')
MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })

Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
ThemeManager:SetFolder('MyScriptHub')
SaveManager:SetFolder('MyScriptHub/specific-game')
SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])
SaveManager:LoadAutoloadConfig()
