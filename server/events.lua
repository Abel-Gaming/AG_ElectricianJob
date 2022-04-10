RegisterServerEvent('ElectricianJob:BoxRepaired')
AddEventHandler('ElectricianJob:BoxRepaired', function(jobName)
    -- Get the player name
    local playerName = GetPlayerName(source)

    -- Trigger the client event
    TriggerClientEvent('ElectricianJob:BoxRepairedNotificaton', -1, playerName, jobName)
end)