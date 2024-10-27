local loadedTabs = false
local users = {}
local scores = {}

local slocs = {}

Citizen.CreateThread(function()
    local daUsers = MySQL.query.await('SELECT * from sdc_pumpkinsmash_users', {})
    local users2 = {}
    if daUsers and daUsers[1] then
        for i=1, #daUsers do
            users2[daUsers[i].ident] = {User = daUsers[i].name, TC = daUsers[i].tcaught}
        end
    end
    users = users2

    local daScores = MySQL.query.await('SELECT * from sdc_pumpkinsmash_score', {})
    local scores2 = {}
    if daScores and daScores[1] then
        for i=1, #daScores do
            scores2[daScores[i].ident] = {Psmashed = daScores[i].psmashed}
        end
    end
    scores = scores2

    for i=1, #SDC.SpawnLocations do
        table.insert(slocs, {CanSmash = nil, Cooldown = nil, Model = SDC.PumpkinModels[math.random(1, #SDC.PumpkinModels)]})
    end

    loadedTabs = true
end)

RegisterServerEvent("SDPS:Server:LoadedIn")
AddEventHandler("SDPS:Server:LoadedIn", function()
    local src = source
    local theirid = nil

    repeat
        theirid = GetOwnerTag(src)
        Wait(2000)
    until loadedTabs and theirid

    if not users[theirid] then
        users[theirid] = {User = SDC.Lang.DefaultName, TC = 0}
        MySQL.insert('INSERT INTO sdc_pumpkinsmash_users (ident, name, tcaught) VALUES (?, ?, ?)',
        {
            theirid,
            SDC.Lang.DefaultName,
            0
        })
    end

    TriggerClientEvent("SDPS:Client:UpdateLocs", src, slocs)
end)


RegisterServerEvent("SDPS:Server:GrabProfile")
AddEventHandler("SDPS:Server:GrabProfile", function()
    local src = source
    theirid = GetOwnerTag(src)

    if users[theirid] then
        if scores[theirid] then
            TriggerClientEvent("SDPS:Client:ShowProfile", src, users[theirid], scores[theirid])
        else
            TriggerClientEvent("SDPS:Client:ShowProfile", src, users[theirid], nil)
        end
    else
        TriggerClientEvent("SDPS:Client:Notification", src, SDC.Lang.IssueGrabbingProfile, "error")
    end
end)

RegisterServerEvent("SDPS:Server:GrabLeaderboard")
AddEventHandler("SDPS:Server:GrabLeaderboard", function()
    local src = source
    local theirid = GetOwnerTag(src)

    TriggerClientEvent("SDPS:Client:ShowLeaderboard", src, scores, theirid, users)
end)

RegisterServerEvent("SDPS:Server:TryNewName")
AddEventHandler("SDPS:Server:TryNewName", function(nn)
    local src = source
    theirid = GetOwnerTag(src)
    
    if users[theirid] then
        local good = true
        for k,v in pairs(users) do
            if v.User == nn then
                good = false
            end
        end

        if good then
            users[theirid].User = nn
            MySQL.update('UPDATE sdc_pumpkinsmash_users SET name = ? WHERE (`ident`) = (?)', {nn, theirid})
            TriggerClientEvent("SDPS:Client:Notification", src, SDC.Lang.NameChanged..": "..nn, "success")
        else
            TriggerClientEvent("SDPS:Client:Notification", src, SDC.Lang.NameUsed, "error")
        end
    else
        TriggerClientEvent("SDPS:Client:Notification", src, SDC.Lang.IssueGrabbingProfile, "error")
    end
end)

RegisterServerEvent("SDPS:Server:TryReset")
AddEventHandler("SDPS:Server:TryReset", function(daid)
    local src = source
    theirid = GetOwnerTag(src)

    if daid then
        theirid2 = GetOwnerTag(daid)

        if theirid2 then
            if scores[theirid2] then
                users[theirid2].TC = users[theirid2].TC + 1
                scores[theirid2] = nil
                MySQL.update('UPDATE sdc_pumpkinsmash_users SET tcaught = ? WHERE (`ident`) = (?)', {users[theirid2].TC, theirid2})
                MySQL.update('DELETE FROM sdc_pumpkinsmash_score WHERE (`ident`) = (?)', {theirid2})
                TriggerClientEvent("SDPS:Client:Notification", src, SDC.Lang.ResetPlayer, "success")
            else
                TriggerClientEvent("SDPS:Client:Notification", src, SDC.Lang.PersonClean, "success")
            end
        else
            TriggerClientEvent("SDPS:Client:Notification", src, SDC.Lang.IssueReset, "error")
        end
    else
        TriggerClientEvent("SDPS:Client:Notification", src, SDC.Lang.IssueReset, "error")
    end
end)

RegisterServerEvent("SDPS:Server:SmashPumpkin")
AddEventHandler("SDPS:Server:SmashPumpkin", function(daid)
    local src = source
    theirid = GetOwnerTag(src)

    if users[theirid] and users[theirid].User ~= SDC.Lang.DefaultName then
        if slocs[daid] and not slocs[daid].CanSmash then
            local missingItem = nil
            for k,v in pairs(SDC.RequiredItemsToSmash) do
                if not HasItemAmt(src, k, v.AmtNeeded) then
                    if missingItem then
                        missingItem = missingItem..", "..v.AmtNeeded.."x "..v.Label
                    else
                        missingItem = v.AmtNeeded.."x "..v.Label
                    end
                end
            end

            if not missingItem then
                slocs[daid].CanSmash = src
                TriggerClientEvent("SDPS:Client:UpdateLocs", -1, slocs)
                TriggerClientEvent("SDPS:Client:SmashPumpkinNow", src, daid)
                
                if math.random(1, 100) <= SDC.CallPolice.ChanceToCall then
                    SendDispatchAlert("SDPS:Client:PSPoliceAlert", SDC.SpawnLocations[daid], {
                        Title = SDC.Lang.PumpkinSmashed,
                        Message = SDC.Lang.PumpkinSmashed2,
                        Blip = SDC.CallPolice.Blip
                    })
                end
            else
                TriggerClientEvent("SDPS:Client:Notification", src, SDC.Lang.CantSmashPumpkin4..": "..missingItem, "error")
            end
        else
            TriggerClientEvent("SDPS:Client:Notification", src, SDC.Lang.CantSmashPumpkin, "error")
        end
    else
        TriggerClientEvent("SDPS:Client:Notification", src, SDC.Lang.CantSmashPumpkin3, "error")
    end
end)

RegisterServerEvent("SDPS:Server:AlertPoliceNow")
AddEventHandler("SDPS:Server:AlertPoliceNow", function(daid)
    local src = source

    if slocs[daid] and slocs[daid].CanSmash and slocs[daid].CanSmash == src then
        slocs[daid].CanSmash = nil
        TriggerClientEvent("SDPS:Client:UpdateLocs", -1, slocs)
        if SDC.CallPolice.CallOnMinigameFail then
            SendDispatchAlert("SDPS:Client:PSPoliceAlert", SDC.SpawnLocations[daid], {
                Title = SDC.Lang.PumpkinSmashed,
                Message = SDC.Lang.PumpkinSmashed2,
                Blip = SDC.CallPolice.Blip
            })
        end
    end
end)

RegisterServerEvent("SDPS:Server:FinishSmash")
AddEventHandler("SDPS:Server:FinishSmash", function(daid)
    local src = source
    theirid = GetOwnerTag(src)

    if slocs[daid] and slocs[daid].CanSmash and slocs[daid].CanSmash == src then
        slocs[daid].CanSmash = 0
        slocs[daid].Cooldown = os.time()
        TriggerClientEvent("SDPS:Client:UpdateLocs", -1, slocs)

        if users[theirid] then
            if scores[theirid] then
                scores[theirid].Psmashed = scores[theirid].Psmashed + 1
                MySQL.update('UPDATE sdc_pumpkinsmash_score SET psmashed = ? WHERE (`ident`) = (?)', {scores[theirid].Psmashed, theirid})
            else
                scores[theirid] = {Psmashed = 1}
                MySQL.insert('INSERT INTO sdc_pumpkinsmash_score (ident, psmashed) VALUES (?, ?)',
                {
                    theirid,
                    1,
                })
            end
        end
        TriggerClientEvent("SDPS:Client:Notification", src, SDC.Lang.SmashedPumpkin, "success")
    end
end)


RegisterServerEvent("SDPS:Server:ResetPumpkinCount")
AddEventHandler("SDPS:Server:ResetPumpkinCount", function(id)
    local src = source
    local daid = nil
    if id then
        daid = id
    else
        daid = src
    end

    theirid = GetOwnerTag(daid)

    if theirid then
        if scores[theirid] then
            users[theirid].TC = users[theirid].TC + 1
            scores[theirid] = nil
            MySQL.update('UPDATE sdc_pumpkinsmash_users SET tcaught = ? WHERE (`ident`) = (?)', {users[theirid].TC, theirid})
            MySQL.update('DELETE FROM sdc_pumpkinsmash_score WHERE (`ident`) = (?)', {theirid})
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(SDC.ServerSyncTimer*1000)

        local change = false
        for i=1, #slocs do
            if slocs[i].Cooldown and math.abs(os.difftime(slocs[i].Cooldown, os.time())) > (SDC.SmashLocationCooldown*60) then
                slocs[i].Cooldown = nil
                slocs[i].CanSmash = nil
                change = true
            end
        end
        if change then
            TriggerClientEvent("SDPS:Client:UpdateLocs", -1, slocs)
        end
    end
end)