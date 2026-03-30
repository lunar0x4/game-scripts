-- for the ones with multiple files you can execute them yourself
-- yes, we own all of these.

local scripts = {
    [13864661000] = "https://oneshotniko-11.pages.dev/breakin2_lobby.lua",
    [3851622790]  = "https://oneshotniko-11.pages.dev/breakin_lobby.lua",
    [4620170611]  = "https://oneshotniko-11.pages.dev/breakin_game.lua",
    [13864667823] = "https://oneshotniko-11.pages.dev/breakin2_game.lua",
    [5096191125]  = "https://github.com/lunar0x4/game-scripts/raw/refs/heads/main/scripts/Field%20Trip%20Z/hub.lua",
    [6447798030]  = "https://github.com/lunar0x4/game-scripts/raw/refs/heads/main/scripts/Funky%20Friday/autoplay.lua",
    [331811267]   = "https://github.com/lunar0x4/game-scripts/raw/refs/heads/main/scripts/Innovation%20INC%20Spaceship/engine_control.lua",
    [155615604]   = "https://github.com/lunar0x4/game-scripts/raw/refs/heads/main/scripts/Prison%20Life/hub.lua",
    [2647097243]  = "https://scripts.hageyexpress.xyz/gravitySubmarine.lua",
    [16454414227] = "https://scripts.hageyexpress.xyz/scary-sushi-c1.lua",
    [482742811]   = "https://scripts.hageyexpress.xyz/speedingWall.lua",
    [3245375623]  = "https://scripts.hageyexpress.xyz/ride999999999miles.lua",
    [11364087119] = "https://scripts.hageyexpress.xyz/cartRide.lua",
    [510444657]   = "https://rawscripts.net/raw/CRIMINAL-VS.-SWAT-OP-Auto-Farm-40k-an-hour-137938"
}

local url = scripts[game.PlaceId]
if not url then return end

loadstring(game:HttpGet(url))()
