-- for the ones with multiple files you can execute them yourself
-- yes, we own all of these.
-- total games supported: 13

local scripts = {
    [13864661000] = "https://oneshotniko-11.pages.dev/breakin2_lobby.lua", -- break in 2 lobby
    [3851622790]  = "https://oneshotniko-11.pages.dev/breakin_lobby.lua", -- break in 1 lobby
    [4620170611]  = "https://oneshotniko-11.pages.dev/breakin_game.lua", -- break in 1 game
    [13864667823] = "https://oneshotniko-11.pages.dev/breakin2_game.lua", -- break in 2 game
    [5096191125]  = "https://github.com/lunar0x4/game-scripts/raw/refs/heads/main/scripts/Field%20Trip%20Z/hub.lua", -- field trip z
    [6447798030]  = "https://github.com/lunar0x4/game-scripts/raw/refs/heads/main/scripts/Funky%20Friday/autoplay.lua", -- funky friday
    [331811267]   = "https://github.com/lunar0x4/game-scripts/raw/refs/heads/main/scripts/Innovation%20INC%20Spaceship/engine_control.lua", --innovation inc spaceship
    [155615604]   = "https://github.com/lunar0x4/game-scripts/raw/refs/heads/main/scripts/Prison%20Life/hub.lua", -- prison life
    [2647097243]  = "https://scripts.hageyexpress.xyz/gravitySubmarine.lua", -- gravity submarine
    [16454414227] = "https://scripts.hageyexpress.xyz/scary-sushi-c1.lua", -- scary sushi (chapter 1)
    [482742811]   = "https://scripts.hageyexpress.xyz/speedingWall.lua", -- get crushed by a speeding wall
    [3245375623]  = "https://scripts.hageyexpress.xyz/ride999999999miles.lua", -- ride 999,999,999 miles down a slide or whatever
    [11364087119] = "https://scripts.hageyexpress.xyz/cartRide.lua", -- cart ride (theres multiple but the correct one is https://www.roblox.com/games/11364087119/Cart-Ride)
    [510444657]   = "https://rawscripts.net/raw/CRIMINAL-VS.-SWAT-OP-Auto-Farm-40k-an-hour-137938", -- swat vs criminal
    [8888615802] = "https://github.com/lunar0x4/game-scripts/raw/refs/heads/main/scripts/Rainbow%20Friends/main.lua", -- rainbow friends
    [13622981808] = "https://github.com/lunar0x4/game-scripts/raw/refs/heads/main/scripts/Rainbow%20Friends/main.lua" -- rainbow friends (if you wondering why its doubled its cuz its chapter 1 and 2 combined in a script)
}

local url = scripts[game.PlaceId]
if not url then return end

loadstring(game:HttpGet(url))()
