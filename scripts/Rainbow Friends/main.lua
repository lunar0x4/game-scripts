local Library = loadstring(Game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wizard"))()
local C1 = Library:NewWindow("Chapter 1")
local C2 = Library:NewWindow("Chapter 2")
local C1Tab = C1:NewSection("github.com/lunar0x4")
local C2Tab = C2:NewSection("github.com/lunar0x4")

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local function get(chapter, option)
    local collectionDelay = 0.05
    local batchSize = 10
    local maxRetries = 3
    local validationTimeout = 2
    
    local function validateChapterAndOption(chapter, option)
        local validCombinations = {
            [1] = { "BlockTower", "Food", "Fuse", "Battery" },
            [2] = { "LightBulb", "GasCanister", "CakeMix", "Looky" }
        }
        
        if not validCombinations[chapter] then
            return false
        end
        
        local isValid = false
        for _, validOption in ipairs(validCombinations[chapter]) do
            if validOption == option then
                isValid = true
                break
            end
        end
        
        return isValid
    end
    
    local function findObjectsByPattern(pattern, requiredPart)
        local objects = {}
        for _, obj in pairs(workspace:GetChildren()) do
            if obj:IsA("Model") and obj.Name:match(pattern) then
                if not requiredPart or obj:FindFirstChild(requiredPart) then
                    table.insert(objects, obj)
                end
            end
        end
        return objects
    end
    
    local function sortObjectsByName(objects)
        table.sort(objects, function(a, b)
            local numA = tonumber(a.Name:match("%d+")) or 0
            local numB = tonumber(b.Name:match("%d+")) or 0
            return numA < numB
        end)
        return objects
    end
    
    local function fireTouchSequence(part1, part2)
        if part1 and part2 then
            firetouchinterest(part1, part2, 0)
            firetouchinterest(part1, part2, 1)
        end
    end
    
    local function processBatchCollection(objects, triggerPart, partName, collectionCallback)
        local collected = 0
        local batchCounter = 0
        
        for _, object in ipairs(objects) do
            local touchPart = object:FindFirstChild(partName or "TouchTrigger")
            if touchPart then
                if collectionCallback then
                    collectionCallback(object, touchPart, collected)
                else
                    fireTouchSequence(hrp, touchPart)
                end
                
                collected = collected + 1
                batchCounter = batchCounter + 1
                
                if batchCounter >= batchSize and triggerPart then
                    fireTouchSequence(hrp, triggerPart)
                    batchCounter = 0
                    task.wait(collectionDelay * 2)
                end
                
                task.wait(collectionDelay)
            end
        end
        
        if batchCounter > 0 and triggerPart then
            fireTouchSequence(hrp, triggerPart)
        end
        
        return collected
    end
    
    local function retryOperation(operation, maxAttempts)
        local attempts = 0
        local result = nil
        
        while attempts < maxAttempts do
            result = operation()
            if result and #result > 0 then
                break
            end
            attempts = attempts + 1
            task.wait(validationTimeout / maxAttempts)
        end
        
        return result
    end
    
    if not validateChapterAndOption(chapter, option) then
        return
    end
    
    if chapter == 1 then
        if option == "BlockTower" then
            local buildTrigger = workspace.GroupBuildStructures.BlockTower.Trigger
            local remainingBlocks = {}
            
            local function scanForBlocks()
                local blocks = {}
                for _, obj in pairs(workspace:GetChildren()) do
                    if obj:IsA("Model") and obj.Name:match("^Block%d+$") and obj:FindFirstChild("TouchTrigger") then
                        table.insert(blocks, obj)
                    end
                end
                return sortObjectsByName(blocks)
            end
            
            local function processBlockCollection()
                local blocks = scanForBlocks()
                if #blocks == 0 then
                    fireTouchSequence(hrp, buildTrigger)
                    return true
                end
                
                for _, block in ipairs(blocks) do
                    local touchPart = block.TouchTrigger
                    fireTouchSequence(hrp, touchPart)
                    task.wait(collectionDelay)
                end
                
                return false
            end
            
            local completed = false
            local retryCount = 0
            
            while not completed and retryCount < maxRetries do
                completed = processBlockCollection()
                if not completed then
                    retryCount = retryCount + 1
                    task.wait(collectionDelay * retryCount)
                end
            end
            
            if not completed then
                fireTouchSequence(hrp, buildTrigger)
            end
        end
        
        if option == "Food" then
            local buildTrigger = workspace.GroupBuildStructures.FoodCounter.Trigger
            local foodItems = findObjectsByPattern("^Food(Green|Pink|Orange)$", "TouchTrigger")
            
            if #foodItems > 0 then
                processBatchCollection(foodItems, buildTrigger, "TouchTrigger")
            end
        end
        
        if option == "Fuse" then
            local buildTrigger = workspace.GroupBuildStructures.FuseBoard.Trigger
            local fuses = {}
            
            for i = 1, 14 do
                local fuse = workspace:FindFirstChild("Fuse" .. i)
                if fuse and fuse:FindFirstChild("TouchTrigger") then
                    table.insert(fuses, fuse)
                end
            end
            
            if #fuses > 0 then
                processBatchCollection(fuses, buildTrigger, "TouchTrigger")
            end
        end
        
        if option == "Battery" then
            local buildTrigger = workspace.GroupBuildStructures.BatteryBox.Trigger
            local batteries = findObjectsByPattern("^Battery$", "TouchTrigger")
            
            if #batteries > 0 then
                processBatchCollection(batteries, buildTrigger, "TouchTrigger")
            end
        end
    end
    
    if chapter == 2 then
        local triggerMapping = {
            LightBulb = "EmergencyLight",
            GasCanister = "RamAir",
            CakeMix = "CakeStructure",
            Looky = nil
        }
        
        local structureName = triggerMapping[option]
        local buildTrigger = structureName and workspace.GroupBuildStructures:FindFirstChild(structureName)
        buildTrigger = buildTrigger and buildTrigger:FindFirstChild("Trigger")
        
        if option == "LightBulb" or option == "GasCanister" or option == "CakeMix" then
            local targetModels = {}
            
            for _, model in pairs(workspace:GetChildren()) do
                if model:IsA("Model") and model:FindFirstChild("TouchTrigger") then
                    if option == "LightBulb" and model.Name:match("LightBulb") then
                        table.insert(targetModels, model)
                    elseif option == "GasCanister" and model.Name:match("GasCanister") then
                        table.insert(targetModels, model)
                    elseif option == "CakeMix" and (model.Name:match("CakeMix") or model.Name:match("Bowl")) then
                        table.insert(targetModels, model)
                    elseif option ~= "LightBulb" and option ~= "GasCanister" and option ~= "CakeMix" then
                        table.insert(targetModels, model)
                    end
                end
            end
            
            if #targetModels == 0 then
                targetModels = findObjectsByPattern(".", "TouchTrigger")
            end
            
            if #targetModels > 0 and buildTrigger then
                local collected = 0
                local batchCounter = 0
                
                for _, model in ipairs(targetModels) do
                    local touchPart = model.TouchTrigger
                    if touchPart then
                        fireTouchSequence(hrp, touchPart)
                        
                        collected = collected + 1
                        batchCounter = batchCounter + 1
                        
                        if batchCounter >= batchSize then
                            fireTouchSequence(hrp, buildTrigger)
                            batchCounter = 0
                            task.wait(collectionDelay * 2)
                        end
                        
                        task.wait(collectionDelay)
                        
                        if collected % 3 == 0 then
                            local alternateModels = findObjectsByPattern("^[A-Z]", "TouchTrigger")
                            if #alternateModels > 0 then
                                local altPart = alternateModels[1].TouchTrigger
                                fireTouchSequence(hrp, altPart)
                            end
                        end
                    end
                end
                
                if batchCounter > 0 then
                    fireTouchSequence(hrp, buildTrigger)
                end
            elseif buildTrigger then
                fireTouchSequence(hrp, buildTrigger)
            end
        end
        
        if option == "Looky" then
            local lookyCollection = {}
            local ignoreFolder = workspace:FindFirstChild("ignore")
       
            if ignoreFolder then
                for _, looky in pairs(ignoreFolder:GetChildren()) do
                    if looky:IsA("Model") and looky.Name == "Looky" then
                        table.insert(lookyCollection, looky)
                    end
                end
            end
            
            for _, looky in pairs(workspace:GetChildren()) do
                if looky:IsA("Model") and looky.Name == "Looky" then
                    table.insert(lookyCollection, looky)
                end
            end
            
            for _, looky in ipairs(lookyCollection) do
                hrp.CFrame = CFrame.new(52, 137, -7)
                task.wait(0.3)
                
                local collision = looky:FindFirstChild("collision") or looky:FindFirstChild("TouchTrigger") or looky:FindFirstChildWhichIsA("Part")
                if collision then
                    fireTouchSequence(hrp, collision)
                    
                    for i = 1, 3 do
                        fireTouchSequence(hrp, collision)
                        task.wait(0.1)
                    end
                end
                
                task.wait(0.2)
            end
            
            if #lookyCollection == 0 then
                hrp.CFrame = CFrame.new(52, 137, -7)
                task.wait(0.5)
                
                local defaultCollision = workspace:FindFirstChild("collision") or workspace:FindFirstChild("Part")
                if defaultCollision then
                    fireTouchSequence(hrp, defaultCollision)
                end
            end
        end
    end
end

C1Tab:CreateButton("Beat Night 1", function()
    get(1, "BlockTower")
end)

C1Tab:CreateButton("Beat Night 2", function()
    get(1, "Food")
end)

C1Tab:CreateButton("Beat Night 3", function()
    get(1, "Fuse")
end)

C1Tab:CreateButton("Beat Night 4", function()
    get(1, "Battery")
end)

C1Tab:CreateButton("Pop Balloons (End)", function()
    for _,balloon in pairs(workspace:FindFirstChild("Map_Finale").BalloonObstacles:GetChildren()) do
        firetouchinterest(hrp, balloon, 0)
        task.wait(0.5)
        firetouchinterest(hrp, balloon, 1)
    end
end)

C1Tab:CreateButton("Go To End (After Night 4)", function()
    hrp.CFrame = CFrame.new(-391, 18, 644)
end)

C2Tab:CreateButton("Beat Night 1", function()
    get(2, "LightBulb")
end)

C2Tab:CreateButton("Beat Night 2", function()
    get(2, "GasCanister")
end)

C2Tab:CreateButton("Beat Night 3 (BETA)", function()
    get(2, "Looky")
end)

C2Tab:CreateButton("Beat Night 4", function()
    get(2, "CakeMix")
end)

C2Tab:CreateButton("Go To End (After Carts)", function()
    hrp.CFrame = CFrame.new(1284, -168, 528)
end)

C1Tab:CreateButton("Destroy GUI", function()
    for _, v in pairs(game.CoreGui:GetChildren()) do
        if v.Name == "WizardLibrary" then
            v:Destroy()
        end
    end
end)

C2Tab:CreateButton("Destroy GUI", function()
    for _, v in pairs(game.CoreGui:GetChildren()) do
        if v.Name == "WizardLibrary" then
            v:Destroy()
        end
    end
end)
