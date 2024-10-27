local QBCore = nil
local ESX = nil

if SDC.Framework == "qb-core" then
    QBCore = exports['qb-core']:GetCoreObject()
elseif SDC.Framework == "esx" then
    ESX = exports["es_extended"]:getSharedObject()
end

function GetCurrentJob()
    if SDC.Framework == "qb-core" then
        local PlayerData = QBCore.Functions.GetPlayerData()
        return PlayerData.job.name
    elseif SDC.Framework == "esx" then
        local PlayerData = ESX.GetPlayerData()
        return PlayerData.job.name
    end
end

function GetClosestPlayer(coords)
	if SDC.Framework == "qb-core" then
        local player, distance = QBCore.Functions.GetClosestPlayer(coords)
        return player, distance
    elseif SDC.Framework == "esx" then
        local player, distance = ESX.Game.GetClosestPlayer(coords)
        return player, distance
    end
end

function AddTargetToPumpkin(prop, eventtotrigger, id)
    if SDC.Target == "qb-target" then
        exports['qb-target']:AddTargetEntity(prop, { 
            options = {  
                {  
                    type = "client", 
                    event = eventtotrigger,  
                    icon = 'fas fa-hammer',  
                    label = SDC.Lang.SmashPumpkin, 
                    theid = id
                }
            },
            distance = 1.5, 
        })
    elseif SDC.Target == "ox-target" then
        exports.ox_target:addLocalEntity(prop, {
            {  
                label = SDC.Lang.SmashPumpkin, 
                icon = 'fa-hammer', 
                distance = 1.5,
                event = eventtotrigger, 
                theid = id
            }
        })
    end
end

function DoProgressbar(time, label)
    if SDC.UseProgBar == "progressBars" then
        exports['progressBars']:startUI(time, label)
        Wait(time)
        return true
    elseif SDC.UseProgBar == "mythic_progbar" then
        TriggerEvent("mythic_progbar:client:progress", {
            name = "sdc_pumpkinsmash",
            duration = time,
            label = label,
            useWhileDead = false,
            canCancel = false,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }
        })
        Wait(time)
        return true
    elseif SDC.UseProgBar == "ox_lib" then
        if lib.progressBar({
            duration = time,
            label =  label,
            useWhileDead = false,
            canCancel = false,
            disable = {
                car = true,
            },
        }) then 
            return true
        end
    else
        Wait(time)
        return true
    end
end

RegisterNetEvent("SDPS:Client:Notification")
AddEventHandler("SDPS:Client:Notification", function(msg, extra)
	if SDC.NotificationSystem == 'tnotify' then
		exports['t-notify']:Alert({
			style = 'message', 
			message = msg
		})
	elseif SDC.NotificationSystem == 'mythic_old' then
		exports['mythic_notify']:DoHudText('inform', msg)
	elseif SDC.NotificationSystem == 'mythic_new' then
		exports['mythic_notify']:SendAlert('inform', msg)
	elseif SDC.NotificationSystem == 'okoknotify' then
		exports['okokNotify']:Alert(SDC.Lang.PumpkinSmash, msg, 3000, 'neutral')
	elseif SDC.NotificationSystem == 'print' then
		print(msg)
	elseif SDC.NotificationSystem == 'framework' then
        if SDC.Framework == "qb-core" then
            QBCore.Functions.Notify(msg, extra)
        elseif SDC.Framework == "esx" then
            ESX.ShowNotification(msg)
        end
	end 
end)

local psmashAlerts = {}
RegisterNetEvent("SDPS:Client:PSPoliceAlert")
AddEventHandler("SDPS:Client:PSPoliceAlert", function(coordss, extra)
	local myjob = GetCurrentJob()

    if SDC.DispatchSystem == "none" then
        scoords = {x = math.ceil(coordss.x), y = math.ceil(coordss.y), z = math.ceil(coordss.z)}
		for i=1, #SDC.CallPolice.AlertJobs do
			if SDC.CallPolice.AlertJobs[i] == myjob and not psmashAlerts[tostring(scoords.x.."_"..scoords.y.."_"..scoords.z)] then
				TriggerEvent("SDPS:Client:Notification", SDC.Lang.PumpkinSmashed2, "primary")
				local psBlip = AddBlipForCoord(coordss.x, coordss.y, coordss.z)
				SetBlipSprite(psBlip, extra.Blip.Sprite)
				SetBlipScale(psBlip, extra.Blip.Size)
				SetBlipColour(psBlip, extra.Blip.Color)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(SDC.Lang.PumpkinSmashed)
				EndTextCommandSetBlipName(psBlip)
				psmashAlerts[tostring(scoords.x.."_"..scoords.y.."_"..scoords.z)] = psBlip
				Wait(45 *1000)--45 Seconds
				if psmashAlerts[tostring(scoords.x.."_"..scoords.y.."_"..scoords.z)] and DoesBlipExist(psmashAlerts[tostring(scoords.x.."_"..scoords.y.."_"..scoords.z)]) then
					RemoveBlip(psBlip)
				end
				psmashAlerts[tostring(scoords.x.."_"..scoords.y.."_"..scoords.z)] = nil
			end
		end
    elseif SDC.DispatchSystem == "ps-dispatch" then
        local jobTab = {}
        for k,v in pairs(SDC.CallPolice.AlertJobs) do
            table.insert(jobTab, k)
        end

        exports["ps-dispatch"]:CustomAlert({
            message = SDC.Lang.PumpkinSmashed,
            icon = "fas fa-hammer",
            coords = coordss,
            job = jobTab,
            alert = {
                sprite = extras.Blip.Sprite,
                scale = extras.Blip.Size,
                color = extras.Blip.Color,
            }
        })
    end
end)


------Exports

function ResetPumpkinCount()
	TriggerServerEvent("SDPS:Server:ResetPumpkinCount")
end
exports('ResetPumpkinCount', ResetPumpkinCount)