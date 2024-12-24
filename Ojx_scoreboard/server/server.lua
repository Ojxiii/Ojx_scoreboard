local Framework
local Frameworktype = Config.Framework:lower()

if Frameworktype == 'qbcore' and GetResourceState('qb-core') == 'started' then
    Framework = exports['qb-core']:GetCoreObject()
elseif Frameworktype == 'esx' and GetResourceState('es_extended') == 'started' then
    TriggerEvent('esx:getSharedObject', function(obj) Framework = obj end)
elseif Frameworktype == 'qbox' and GetResourceState('qbx_core') == 'started' then
    print('qbox:D')
else
    print("Not supporting this framework sorry, :(")
    return
end

lib.callback.register('Ojx_scoreboard:server:GetData', function(_, cb)
    local totalPlayers = 0
    local policeCount = 0
    local players = {}

    if Frameworktype == 'qbcore' then
        for _, v in pairs(Framework.Functions.GetQBPlayers()) do
            if v then
                totalPlayers += 1
                if v.PlayerData.job.name == 'police' and v.PlayerData.job.onduty then
                    policeCount += 1
                end
                players[v.PlayerData.source] = { optin = Framework.Functions.IsOptin(v.PlayerData.source) }
            end
        end

    elseif Frameworktype == 'esx' then
        local playerList = Framework.GetPlayers()
        for _, playerId in pairs(playerList) do
            local xPlayer = Framework.GetPlayerFromId(playerId)
            if xPlayer then
                totalPlayers += 1
                if xPlayer.job.name == 'police' and (xPlayer.job.duty or xPlayer.job.onduty) then
                    policeCount += 1
                end
                players[playerId] = { optin = true } 
        end
    end
elseif frameworkType == 'qbox' then
    for _, v in pairs(exports.qbx_core:GetQBPlayers()) do
        local player = exports.qbx_core:GetQBPlayers(v)
        if player then
            totalPlayers += 1
            if player.job.name == 'police' and player.job.duty then
                policeCount += 1
            end
            players[v] = { optin = true } 
        end
    end
end

return totalPlayers, policeCount, players
end)


RegisterNetEvent('Ojx_scoreboard:server:busy', function(activity, bool)
    if Config.crime and Config.crime[activity] then
        Config.crime[activity].busy = bool
        TriggerClientEvent('Ojx_scoreboard:client:busy', -1, activity, bool)
    end
end)
