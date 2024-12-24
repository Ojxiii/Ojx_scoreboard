local BoardOpen = false
local playerOptin = {}

local function GetPlayers()
    local players = {}
    local activePlayers = GetActivePlayers()
    for i = 1, #activePlayers do
        local player = activePlayers[i]
        local ped = GetPlayerPed(player)
        if DoesEntityExist(ped) then
            players[#players + 1] = player
        end
    end
    return players
end

local function GetPlayersFromCoords(coords, distance)
    local players = GetPlayers()
    local closePlayers = {}

    coords = coords or GetEntityCoords(PlayerPedId())
    distance = distance or 5.0

    for i = 1, #players do
        local player = players[i]
        local target = GetPlayerPed(player)
        local targetCoords = GetEntityCoords(target)
        local targetdistance = #(targetCoords - vector3(coords.x, coords.y, coords.z))
        if targetdistance <= distance then
            closePlayers[#closePlayers + 1] = player
        end
    end

    return closePlayers
end

-- Events

RegisterNetEvent('Ojx_scoreboard:client:busy', function(activity, busy)
    Config.crime[activity].busy = busy
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, 246) then
            if not BoardOpen then
                local players, cops, playerList = lib.callback.await('Ojx_scoreboard:server:GetData')
                if players then
                    SetNuiFocus(true, true)
                    SendNUIMessage({
                        action = 'open',
                        players = players,
                        maxPlayers = Config.MaxPlayers,
                        requiredCops = Config.crime,
                        currentCops = cops
                    })
                    BoardOpen = true
                end
            else
                SetNuiFocus(false, false)
                SendNUIMessage({ action = 'close' })
                BoardOpen = false
            end
        end
    end
end)

RegisterNUICallback('exit', function(_, cb)
    SetNuiFocus(false, false)
    BoardOpen = false
    cb('ok')
end)


CreateThread(function()
    Wait(1000)
    local actions = {}
    for k, v in pairs(Config.crime) do
        if v.label then
            actions[k] = v.label
        end
    end
    SendNUIMessage({
        action = 'setup',
        items = actions
    })
end)

-- ids

local function DrawText3D(x, y, z, text)
	SetTextScale(0.65, 0.65)
    SetTextFont(0) 
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(true)
    SetTextDropshadow(0, 0, 0, 0, 55)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    ClearDrawOrigin()
end

CreateThread(function()
    while true do
        local loop = 100
        if BoardOpen then
            for _, player in pairs(GetPlayersFromCoords(GetEntityCoords(PlayerPedId()), 10.0)) do
                local playerId = GetPlayerServerId(player)
                local playerPed = GetPlayerPed(player)
                local playerCoords = GetEntityCoords(playerPed)
                if Config.ShowIDs or playerOptin[playerId].optin then
                    loop = 0
                     DrawText3D(playerCoords.x, playerCoords.y, playerCoords.z + 1.1, ''..playerId..' ')
                end
            end
        end
        Wait(loop)
    end
end)
