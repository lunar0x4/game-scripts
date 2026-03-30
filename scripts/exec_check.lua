local missing = {}

if not fireclickdetector then
    table.insert(missing, "fireclickdetector")
end

if not firetouchinterest then
    table.insert(missing, "firetouchinterest")
end

if not fireproximityprompt then
    table.insert(missing, "fireproximityprompt")
end

if not cloneref then
    if setmetatable then
        getgenv().cloneref = function(obj)
            return setmetatable({}, {
                __index = obj,
                __newindex = obj,
                __eq = function()
                    return false
                end
            })
        end
    elseif newproxy and getmetatable then
        local ok, proxy = pcall(function()
            return newproxy(true)
        end)
        if ok and proxy then
            getgenv().cloneref = function(obj)
                local p = newproxy(true)
                local mt = getmetatable(p)

                mt.__index = obj
                mt.__newindex = obj
                mt.__eq = function()
                    return false
                end

                return p
            end
        else
            table.insert(missing, "setmetatable/newproxy(true)")
            getgenv().cloneref = function(obj)
                return obj
            end
        end
    else
        table.insert(missing, "setmetatable")
        table.insert(missing, "newproxy")
        table.insert(missing, "getmetatable")

        -- we use a fake but working function, doesn't pass unc tests
        getgenv().cloneref = function(obj)
            return obj
        end
    end
end

if #missing > 0 then
    game:GetService("Players").LocalPlayer:Kick("Missing " .. table.concat(missing, ", ")) -- FIXED!
end

if string.lower(identifyexecutor()) == "xeno" then
    game:GetService("Players").LocalPlayer:Kick("Your executor is trash, try using solara instead")
end

return true
