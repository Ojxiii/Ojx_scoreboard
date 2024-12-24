Config = Config or {}

Config.MaxPlayers = GetConvarInt('sv_maxclients', 69)
Config.ShowIDs = true
Config.Framework = "qbox" -- qbx, qbcore, esx

Config.crime = {
    ['storerobbery'] = {
        minimumPolice = 0,
        busy = false,
        label = 'convenience store',
    },
    ['cashexchange'] = {
        minimumPolice = 2,
        busy = false,
        label = 'Cash exchange robbery',
    },
    ['bank'] = {
        minimumPolice = 4,
        busy = false,
        label = 'Fleeca robbery'
    }
}

