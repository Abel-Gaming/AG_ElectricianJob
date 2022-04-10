---------- COMMANDS ----------
RegisterCommand(Config.JobCommand, function(source, args)
    -- Get the player name
    local playerName = GetPlayerName(source)

    -- Trigger client event to player only
    TriggerClientEvent('ElectricianJob:GoOnDuty', source, playerName --[[FIRST DATA PARAMETER]])

    -- Trigger client event global for duty notification
    TriggerClientEvent('ElectricianJob:DutyNotificaton', -1, playerName)
end, false)