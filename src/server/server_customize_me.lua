local QBCore = nil
local ESX = nil

if SDC.Framework == "qb-core" then
    QBCore = exports['qb-core']:GetCoreObject()
elseif SDC.Framework == "esx" then
    ESX = exports['es_extended']:getSharedObject()
end

function HasItemAmt(src, item, amt)
    if SDC.Framework == "qb-core" then
        local Player = QBCore.Functions.GetPlayer(src)
        if Player.Functions.GetItemByName(item) and Player.Functions.GetItemByName(item).amount >= amt then
            return true
        else
            return false
        end
    elseif SDC.Framework == "esx" then
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer.getInventoryItem(item) and xPlayer.getInventoryItem(item).count >= amt then
            return true
        else
            return false
        end
    end
end

function GetOwnerTag(src)
    if SDC.Framework == "qb-core" then
        local Player = QBCore.Functions.GetPlayer(src)
        if Player then
            return Player.PlayerData.citizenid
        else
            return nil
        end
    elseif SDC.Framework == "esx" then
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer then
            return xPlayer.identifier
        else
            return nil
        end
    end
end



function SendDispatchAlert(event, coords, extras)
    if SDC.DispatchSystem == "none" then
        TriggerClientEvent(event, -1, coords, extras)
    elseif SDC.DispatchSystem == "cd_dispatch" then
        local jobTab = {}
        for k,v in pairs(SDC.CallPolice.AlertJobs) do
            table.insert(jobTab, k)
        end
        TriggerClientEvent('cd_dispatch:AddNotification', -1, {
            job_table = jobTab,
            coords = vector3(coords.x, coords.y, coords.z),
            title = extras.Title,
            message = extras.Message,
            flash = 0,
            unique_id = tostring(math.random(0000000,9999999)),
            sound = 1,
            blip = {
                sprite = extras.Blip.Sprite,
                scale = extras.Blip.Size,
                colour = extras.Blip.Color,
                flashes = false,
                text = extras.Title,
                time = 5,
                radius = 0,
            }
        })
    elseif SDC.DispatchSystem == "ps-dispatch" then
        local playerid = nil
        if SDC.Framework == "qb-core" then
            local Players = QBCore.Functions.GetPlayers()
            if #Players > 0 then
                for i=1, #Players do
                    local Player = QBCore.Functions.GetPlayer(Players[i])
                    if Player and GetPlayerName(Players[i]) and not playerid then
                        playerid = Players[i]
                    end
                end
            end
        elseif SDC.Framework == "esx" then
            local Players = ESX.GetPlayers()
            if #Players > 0 then
                for i=1, #Players do
                    local Player = ESX.GetPlayerFromId(Players[i])
                    if Player and GetPlayerName(Players[i]) and not playerid then
                        playerid = Players[i]
                    end
                end
            end
        end
        TriggerClientEvent(event, playerid, coords, extras)
    end
end


--------Exports
function ResetPlayerPumpkinCount(id)
    if id and GetPlayerName(id) then
        TriggerEvent("SDPS:Server:ResetPumpkinCount", id)
        return true
    else
        return false
    end
end
exports('ResetPlayerPumpkinCount', ResetPlayerPumpkinCount)