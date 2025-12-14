SetConvarServerInfo('tags', 'Audio_Pack')

local updatePath = "/DamienSmith428/FiveM_Engine_Sounds"
local resourceName = GetCurrentResourceName()
local versionFile = "version.lua"

if resourceName ~= "Audio_Pack" then
    print("-----------------------------------------------------")
    print("Please do NOT rename the resource to avoid errors!")
    print("-----------------------------------------------------")
end

local function isOutdated(current, latest)
    local function splitVersion(v)
        local t = {}
        for num in v:gmatch("%d+") do
            table.insert(t, tonumber(num))
        end
        return t
    end

    local c = splitVersion(current)
    local l = splitVersion(latest)
    for i = 1, math.max(#c, #l) do
        local cv = c[i] or 0
        local lv = l[i] or 0
        if cv < lv then return true end
        if cv > lv then return false end
    end
    return false
end

local function trim(s)
    if not s then return "" end
    return s:match("^%s*(.-)%s*$")
end

local function checkVersion(_, responseText, headers)
    if not responseText or responseText == "" then
        print("\27[31m-----------------------------------------------------\27[0m")
        print("\27[31mFailed to check Audio Pack version! Could not fetch latest version from GitHub.\27[0m")
        print("\27[31m-----------------------------------------------------\27[0m")
        return
    end

    local curVersion = trim(LoadResourceFile(resourceName, versionFile)) or "0.0.0"
    local latestVersion = trim(responseText)

    if curVersion ~= latestVersion and isOutdated(curVersion, latestVersion) then
        print("\27[31m║   Uh Oh! Looks like Audio Pack is outdated\27[0m")
        print("\27[31m║   Latest: "..latestVersion..", Current: "..curVersion..".\27[0m") 
        print("\27[31m║   Please update: https://github.com"..updatePath.."\27[0m")
    elseif not isOutdated(curVersion, latestVersion) and curVersion ~= latestVersion then
        print("\27[33m║   Hey there! Thanks for using my Audio Pack!\27[0m")
        print("\27[33m║\27[0m")
        print("\27[31m║   Uh Oh! You somehow skipped a few versions of Audio Pack\27[0m")
        print("\27[31m║   or the git went offline, if it's still online I advise you to update (or downgrade?)\27[0m")
    else
        print("\27[32m║   Hey there! Thanks for using my Audio Pack: Version "..latestVersion.."!\27[0m")
        print("\27[32m║\27[0m")
        print("\27[32m║\27[0m")
        print("\27[32m║   It looks like Audio Pack is up to date, have fun!\27[0m")
    end
end

Citizen.CreateThread(function()
    if resourceName == "Audio_Pack" then
        PerformHttpRequest(
    "https://raw.githubusercontent.com/DamienSmith428/FiveM_Engine_Sounds/main/Audio_Pack/version.lua",
    checkVersion,
    "GET"
)

    end
end)
