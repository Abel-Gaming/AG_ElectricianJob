local onDuty = false
local onJob = false
---------- THREADS ----------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if onDuty then
			for k,v in pairs(Config.JobCoords) do
				local jobName = v.name
				local jobCoord = v.coord
				local jobTime = v.time

				while #(GetEntityCoords(PlayerPedId()) - jobCoord) <= 3.0 do
					Citizen.Wait(0)
					ShowHelpText('Press ~INPUT_PICKUP~ to repair')
					if IsControlJustReleased(0, 38) then
						RepairBox(jobName, jobCoord, jobTime)
					end
				end
			end
		end
	end
end)

---------- EVENTS ----------
RegisterNetEvent('ElectricianJob:GoOnDuty')
AddEventHandler('ElectricianJob:GoOnDuty', function(playerName)
	if onDuty then
		-- Happens if you are on duty
		InfoMessage('You are no longer an electrician')
		onDuty = false
	else
		-- Happens if you are off duty
		SuccessMessage('You are now an electrician!')
		onDuty = true
	end
end)

RegisterNetEvent('ElectricianJob:DutyNotificaton')
AddEventHandler('ElectricianJob:DutyNotificaton', function(playerName)
	InfoMessage('~b~' .. playerName .. ' ~w~is now available as an electrician')
end)

RegisterNetEvent('ElectricianJob:BoxRepairedNotificaton')
AddEventHandler('ElectricianJob:BoxRepairedNotificaton', function(playerName, jobName)
	InfoMessage('~b~' .. playerName .. ' ~w~has just repaired ~b~' .. jobName)
end)
---------- FUNCTIONS ----------
function sendChatMessage(message)
	TriggerEvent("chatMessage", "", {0, 0, 0}, "^7" .. message)
end

function SuccessMessage(successMessage)
	SetNotificationTextEntry('STRING')
	AddTextComponentSubstringPlayerName('~g~[SUCCESS]~w~ ' .. successMessage)
	DrawNotification(false, true)
end

function InfoMessage(message)
	SetNotificationTextEntry('STRING')
	AddTextComponentSubstringPlayerName('~y~[INFO]~w~ ' .. message)
	DrawNotification(false, true)
end

function ShowHelpText(message)
	BeginTextCommandDisplayHelp("THREESTRINGS")
	AddTextComponentSubstringPlayerName(message)
    -- shape (always 0), loop (bool), makeSound (bool), duration (0 for loop)
    EndTextCommandDisplayHelp(0, false, false, 500)
end

function SwtNotification(message)
	TriggerEvent("swt_notifications:Icon", message, "top", 2500, "blue-10", "white", true, "mdi-earth")
end

function RepairBox(jobName, jobCoord, jobTime)
	--Set job bool
	onJob = true

	--Show Info Message
	InfoMessage('Beginning repair')

	--Notify the server that the box has been repaired
	TriggerServerEvent('ElectricianJob:BoxRepaired', jobName)

	--Wait
	Citizen.Wait(jobTime * 1000)

	--End Repair
	RepairBoxEnd()
end

function RepairBoxEnd()
	-- Message
	SuccessMessage('Box repaired')

	-- Set bool
	onJob = false
end