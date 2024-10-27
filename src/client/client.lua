local loadedClient = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if NetworkIsSessionStarted() then
			Citizen.Wait(200)
			loadedClient = true
            TriggerServerEvent("SDPS:Server:LoadedIn")
			return -- break the loop
		end
	end
end)

----------------------------------------------------------------------------
local allSLocs = {}
local s_allSLocs = {}
local closestSLoc = nil
local inMenu = nil

local PlayerHasProp = {}

local showingUI = nil

RegisterNetEvent("SDPS:Client:UpdateLocs")
AddEventHandler("SDPS:Client:UpdateLocs", function(tab)
	allSLocs = tab
end)


RegisterCommand(SDC.Commands.MainMenu, function()
	if inMenu then
		lib.hideContext(true)
	end
	inMenu = "main"
	lib.registerContext({
		id = 'pumpkinsmash_main',
		title = SDC.Lang.PumpkinSmash,
		onExit = function()
			inMenu = nil
		end,
		options = {
			{
				title = SDC.Lang.MyProfile,
				description = SDC.Lang.MyProfile2,
				icon = 'user',
				arrow = true,
				onSelect = function()
					inMenu = nil
					TriggerServerEvent("SDPS:Server:GrabProfile")
				end,
			},
			{
				title = SDC.Lang.Leaderboard,
				description = SDC.Lang.Leaderboard2,
				icon = 'ranking-star',
				arrow = true,
				onSelect = function()
					inMenu = nil
					TriggerServerEvent("SDPS:Server:GrabLeaderboard")
				end,
			},
		}
	})
	 
	lib.showContext('pumpkinsmash_main')
end, false)
TriggerEvent('chat:addSuggestion', '/'..SDC.Commands.MainMenu, 'Open Pumpkin Smash Main Menu', {})
RegisterCommand(SDC.Commands.ResetCommand, function()
	local myjob = GetCurrentJob()
	if myjob and SDC.JobsThatCanResetPumpkinsSmashed[myjob] then
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		local player, distance = GetClosestPlayer(coords)

		if player and distance <= 2 then
			TriggerServerEvent("SDPS:Server:TryReset", GetPlayerServerId(player))
		else
			TriggerEvent("SDPS:Client:Notification", SDC.Lang.NoPlayerNearby, "error")
		end
	else
		TriggerEvent("SDPS:Client:Notification", SDC.Lang.MissingJobForThis, "error")
	end
end, false)
TriggerEvent('chat:addSuggestion', '/'..SDC.Commands.ResetCommand, 'Reset Nearby Players Pumpkin Smash Count', {})

RegisterNetEvent("SDPS:Client:ShowProfile")
AddEventHandler("SDPS:Client:ShowProfile", function(dat, dat2)
	local opts = {}
	local ps = 0

	if dat2 then
		ps = dat2.Psmashed
	end

	table.insert(opts, {
		title = SDC.Lang.Name..": "..dat.User,
		description = SDC.Lang.Name2,
		icon = 'file-pen',
		arrow = true,
		onSelect = function()
			inMenu = nil
			local input = lib.inputDialog(SDC.Lang.Name, {
				{type = 'input', label = SDC.Lang.Name3, description = SDC.Lang.Name4, required = true, min = SDC.DisplayNameLength.Min, max = SDC.DisplayNameLength.Max},
			})

			if input and input[1] then
				if tostring(input[1]) then
					newname = tostring(input[1])

					if #newname >= SDC.DisplayNameLength.Min and #newname <= SDC.DisplayNameLength.Max then
						TriggerServerEvent("SDPS:Server:TryNewName", newname)
					else
						TriggerEvent("SDPS:Client:Notification", SDC.Lang.InvalidName, "error")
					end
				else
					TriggerEvent("SDPS:Client:Notification", SDC.Lang.InvalidName, "error")
				end
			else
				TriggerEvent("SDPS:Client:Notification", SDC.Lang.InvalidName, "error")
			end
		end,
	})

	table.insert(opts, {
		title = SDC.Lang.TCaught..": "..dat.TC,
		description = SDC.Lang.TCaught2,
		icon = 'handcuffs'
	})

	table.insert(opts, {
		title = SDC.Lang.PSmashed..": "..ps,
		description = SDC.Lang.PSmashed2,
		icon = 'hammer'
	})

	inMenu = "profile"
	lib.registerContext({
		id = 'pumpkinsmash_profile',
		title = SDC.Lang.MyProfile,
		options = opts,
		menu = "pumpkinsmash_main",
		onExit = function()
			inMenu = nil
		end,
	})
	 
	lib.showContext('pumpkinsmash_profile')
end)
RegisterNetEvent("SDPS:Client:ShowLeaderboard")
AddEventHandler("SDPS:Client:ShowLeaderboard", function(dat, myid, users)
	local newtab = {}
	for key, _ in pairs(dat) do
		table.insert(newtab, key)
	end
	if newtab[1] then
		table.sort(newtab, function(keyLhs, keyRhs) return dat[keyLhs].Psmashed > dat[keyRhs].Psmashed end)
	end

	local opts = {}


	if dat[myid] then
		local myplace = 0
		for i=1, #newtab do
			if newtab[i] == myid then
				myplace = i
			end
		end

		table.insert(opts, {
			title = SDC.Lang.CurrentPos..": "..myplace,
			description = SDC.Lang.CurrentPos2,
			icon = 'user'
		})
		table.insert(opts, {
			title = "---"..SDC.Lang.Leaderboard3.."---",
		})
	else
		table.insert(opts, {
			title = SDC.Lang.CurrentPos..": "..SDC.Lang.Unranked,
			description = SDC.Lang.CurrentPos2,
			icon = 'user'
		})
		table.insert(opts, {
			title = "---"..SDC.Lang.Leaderboard3.."---",
		})
	end
	if newtab[1] then
		for i=1, #newtab do
			if i <= SDC.LeaderboardLength then
				if newtab[i] == myid then
					table.insert(opts, {
						title = "["..i.."] "..users[newtab[i]].User,
						description = SDC.Lang.PSmashed..": "..dat[newtab[i]].Psmashed,
						icon = 'user-tie',
						iconColor = "green"
					})
				else
					table.insert(opts, {
						title = "["..i.."] "..users[newtab[i]].User,
						description = SDC.Lang.PSmashed..": "..dat[newtab[i]].Psmashed,
						icon = 'user-tie'
					})
				end
			end
		end
	else
		table.insert(opts, {
			title = SDC.Lang.NoRanked,
			description = SDC.Lang.NoRanked2,
			icon = 'ban'
		})
	end

	lib.registerContext({
		id = 'pumpkinsmash_leaderboard',
		title = SDC.Lang.Leaderboard,
		options = opts,
		menu = "pumpkinsmash_main",
		onExit = function()
			inMenu = nil
		end,
	})
	 
	lib.showContext('pumpkinsmash_leaderboard')
end)

Citizen.CreateThread(function()
	while true do
		if allSLocs[1] then
			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)
			for i=1, #allSLocs do
				if not allSLocs[i].Cooldown and not s_allSLocs[tostring(i)] and Vdist(coords.x, coords.y, coords.z, SDC.SpawnLocations[i]) <= SDC.PumpkinSpawnDist then
					LoadPropDict(allSLocs[i].Model)
					local daPumpkin = CreateObject(GetHashKey(allSLocs[i].Model), SDC.SpawnLocations[i].x, SDC.SpawnLocations[i].y, SDC.SpawnLocations[i].z,  false,  true, false)
					SetEntityHeading(daPumpkin, SDC.SpawnLocations[i].w)
					PlaceObjectOnGroundProperly(daPumpkin)
					FreezeEntityPosition(daPumpkin, true)
					SetModelAsNoLongerNeeded(allSLocs[i].Model)
					s_allSLocs[tostring(i)] = daPumpkin

					if SDC.Target ~= "none" then
						AddTargetToPumpkin(daPumpkin, "SDPS:Client:TrySmashPumpkin", i)
					end
				elseif s_allSLocs[tostring(i)] and Vdist(coords.x, coords. y,coords.z, SDC.SpawnLocations[i]) > SDC.PumpkinSpawnDist then
					if DoesEntityExist(s_allSLocs[tostring(i)]) then
						DeleteEntity(s_allSLocs[tostring(i)])
					end
					s_allSLocs[tostring(i)] = nil
				elseif s_allSLocs[tostring(i)] and allSLocs[i].Cooldown then
					if DoesEntityExist(s_allSLocs[tostring(i)]) then
						DeleteEntity(s_allSLocs[tostring(i)])
					end
					s_allSLocs[tostring(i)] = nil
				end
			end

			local minDistance = 100
			local closestSLoc2 = nil
			for k,v in pairs(s_allSLocs) do
				dist = Vdist(SDC.SpawnLocations[tonumber(k)].x, SDC.SpawnLocations[tonumber(k)].y, SDC.SpawnLocations[tonumber(k)].z, coords)
				if dist < minDistance then
					minDistance = dist
					closestSLoc2 = k
				end
			end
			closestSLoc = closestSLoc2
			
			Citizen.Wait(500)
		else
			Citizen.Wait(1000)
		end		
	end
end)

RegisterNetEvent("SDPS:Client:TrySmashPumpkin")
AddEventHandler("SDPS:Client:TrySmashPumpkin", function(dat)
	local theid = dat.theid

	if allSLocs[theid] and not allSLocs[theid].CanSmash then
		myjob = GetCurrentJob()
		if myjob and not SDC.JobsThatCanResetPumpkinsSmashed[myjob] then
			TriggerEvent("SDPS:Client:Notification", SDC.Lang.CantSmashPumpkin2, "error")
		else
			TriggerServerEvent("SDPS:Server:SmashPumpkin", theid)
		end
	else
		TriggerEvent("SDPS:Client:Notification", SDC.Lang.CantSmashPumpkin, "error")
	end
end)
RegisterNetEvent("SDPS:Client:SmashPumpkinNow")
AddEventHandler("SDPS:Client:SmashPumpkinNow", function(theid)
	local ped = PlayerPedId()

	if SDC.SmashMinigame.Enabled then
		local checktotal = {}
		local keys = {}
		for i=1, SDC.SmashMinigame.Checks do
			table.insert(checktotal, SDC.SmashMinigame.Difficulty)
			table.insert(keys, SDC.SmashMinigame.Keys[math.random(1, #SDC.SmashMinigame.Keys)])
		end
		local finished = lib.skillCheck(checktotal, keys)

		if finished then
			LoadAnim("melee@large_wpn@streamed_core")
			MakeEntityFaceEntity(ped, s_allSLocs[tostring(theid)])
			AddPropToPlayer("prop_tool_hammer", 57005, 0.11, 0.0, 0.0, 90.0, 0.0, 180.0, "hammy", nil, true)
			TaskPlayAnim(ped, 'melee@large_wpn@streamed_core', 'ground_attack_on_spot', 8.0, 8.0, -1, 1, 1, 0, 0, 0)
			FreezeEntityPosition(ped, true)
			RemoveAnimDict("melee@large_wpn@streamed_core")
			DoProgressbar(SDC.SmashAnimationTime*1000, SDC.Lang.SmashingPumpkin)
			ClearPedTasksImmediately(ped)
			FreezeEntityPosition(ped, false)
			if DoesEntityExist(PlayerHasProp["hammy"]) then
				DeleteEntity(PlayerHasProp["hammy"])
			end
			PlayerHasProp["hammy"] = nil
			TriggerServerEvent("SDPS:Server:FinishSmash", theid)
		else
			TriggerEvent("SDPS:Client:Notification", SDC.Lang.FailedPumpkinSmash, "error")
			TriggerServerEvent("SDPS:Server:AlertPoliceNow", theid)
		end
	else
		LoadAnim("melee@large_wpn@streamed_core")
		MakeEntityFaceEntity(ped, s_allSLocs[tostring(theid)])
		AddPropToPlayer("prop_tool_hammer", 57005, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, "hammy", nil, true)
		TaskPlayAnim(ped, 'melee@large_wpn@streamed_core', 'ground_attack_on_spot', 8.0, 8.0, -1, 1, 1, 0, 0, 0)
		FreezeEntityPosition(ped, true)
		RemoveAnimDict("melee@large_wpn@streamed_core")
		DoProgressbar(SDC.SmashAnimationTime*1000, SDC.Lang.SmashingPumpkin)
		ClearPedTasksImmediately(ped)
		FreezeEntityPosition(ped, false)
		if DoesEntityExist(PlayerHasProp["hammy"]) then
			DeleteEntity(PlayerHasProp["hammy"])
		end
		PlayerHasProp["hammy"] = nil
		TriggerServerEvent("SDPS:Server:FinishSmash", theid)
	end
end)

if SDC.Target == "none" then
	Citizen.CreateThread(function()
		while true do
			if closestSLoc then
				local ped = PlayerPedId()
				local coords = GetEntityCoords(ped)

				if closestSLoc and Vdist(coords.x, coords.y, coords.z, SDC.SpawnLocations[tonumber(closestSLoc)]) <= SDC.SmashPumpkinDist then
					if not showingUI or showingUI ~= "smashp" then
						showingUI = "smashp"
						lib.showTextUI('['..SDC.SmashPKeybind.Label..'] - '..SDC.Lang.SmashPumpkin, {
							position = "right-center",
							icon = 'hand',
						})
					end

					if IsControlJustReleased(0, SDC.SmashPKeybind.Input) then
						TriggerEvent("SDPS:Client:TrySmashPumpkin", {theid = tonumber(closestSLoc)})
						Citizen.Wait(2000)
					end
					Citizen.Wait(1)
				else
					if showingUI and showingUI == "smashp" then
						showingUI = nil
						lib.hideTextUI()
					end
					Citizen.Wait(500)
				end
			else
				if showingUI and showingUI == "smashp" then
					showingUI = nil
					lib.hideTextUI()
				end
				Citizen.Wait(1000)
			end
		end
	end)
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
		for k,v in pairs(s_allSLocs) do
			if DoesEntityExist(v) then
				DeleteEntity(v)
			end
		end

		for k,v in pairs(PlayerHasProp) do
			if DoesEntityExist(v) then
				DeleteEntity(v)
			end
		end
	end
end)

---------------------------------------------------------------------
-------------------------Functions-----------------------------------
---------------------------------------------------------------------
function MakeEntityFaceEntity(entity1, entity2)
	local p1 = GetEntityCoords(entity1, true)
	local p2 = GetEntityCoords(entity2, true)

	local dx = p2.x - p1.x
	local dy = p2.y - p1.y

	local heading = GetHeadingFromVector_2d(dx, dy)
	SetEntityHeading( entity1, heading )
end

function LoadPropDict(model)
	while not HasModelLoaded(GetHashKey(model)) do
	  RequestModel(GetHashKey(model))
	  Wait(10)
	end
end

function LoadAnim(dict)
	while not HasAnimDictLoaded(dict) do
	  RequestAnimDict(dict)
	  Wait(10)
	end
end

function AddPropToPlayer(prop1, bone, off1, off2, off3, rot1, rot2, rot3, namies, player, network)
	local Player = nil
	if player ~= nil then
		Player = player
	else
		Player = PlayerPedId()
	end
	local x,y,z = table.unpack(GetEntityCoords(Player))
  
	if not HasModelLoaded(prop1) then
	  LoadPropDict(prop1)
	end
  
	if network then
		prop = CreateObject(GetHashKey(prop1), x, y, z+0.2,  true,  true, true)
		AttachEntityToEntity(prop, Player, GetPedBoneIndex(Player, bone), off1, off2, off3, rot1, rot2, rot3, true, true, false, true, 1, true)
		--table.insert(PlayerHasProp, {id = namies, object = prop})
		PlayerHasProp[namies] = prop
		SetModelAsNoLongerNeeded(prop1)
	else
		prop = CreateObject(GetHashKey(prop1), x, y, z+0.2,  false,  true, true)
		AttachEntityToEntity(prop, Player, GetPedBoneIndex(Player, bone), off1, off2, off3, rot1, rot2, rot3, true, true, false, true, 1, true)
		--table.insert(PlayerHasProp, {id = namies, object = prop})
		PlayerHasProp[namies] = prop
		SetModelAsNoLongerNeeded(prop1)
	end
end