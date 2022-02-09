-- Variables

local QBCore = exports['qb-core']:GetCoreObject()
local inMiningArea = false
local inWashingArea = false
local inSmeltingArea = false
local currentspot = nil
local previousspot = nil
local MiningLocations = {}
local WashingLocations = {}
local SmeltingLocations = {}
local Blips = {}
local Peds = {}
local mineWait = false

-- Functions

local function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            s = s .. '['..k..'] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
       return tostring(o)
    end
end

local function loadModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
        RequestModel(model)
    end
    return model
end

local function loadDict(dict, anim)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
        RequestAnimDict(dict)
    end
    return dict
end

local function helpText(msg)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

local function addBlip(coords, sprite, colour, scale, text)
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, colour)
    SetBlipScale(blip, scale)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
end

local function CreateBlips() -- Create mining blips
	for k, v in pairs(Config.Blips) do
        Blips[k] = AddBlipForCoord(v.blippoint)
        SetBlipSprite(Blips[k], v.blipsprite)
        SetBlipDisplay(Blips[k], 4)
        SetBlipScale(Blips[k], v.blipscale)
        SetBlipAsShortRange(Blips[k], true)
        SetBlipColour(Blips[k], v.blipcolour)
        SetBlipAlpha(Blips[k], 0.7)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(v.label)
        EndTextCommandSetBlipName(Blips[k])
    end
end

local function SpawnPeds() -- Create shop peds
	for k, v in pairs(Config.Peds) do
		local pednum = exports['qb-target']:SpawnPed(v)
        Peds[k] = pednum
	end
end

local function IsInWater()
    local startedCheck = GetGameTimer()

    local ped = PlayerPedId()
    local pedPos = GetEntityCoords(ped)

    local forwardVector = GetEntityForwardVector(ped)
    local forwardPos = vector3(pedPos["x"] + forwardVector["x"] * 10, pedPos["y"] + forwardVector["y"] * 10, pedPos["z"])

    local fishHash = `a_c_fish`

    loadModel(fishHash)

    local waterHeight = GetWaterHeight(forwardPos["x"], forwardPos["y"], forwardPos["z"])

    local fishHandle = CreatePed(1, fishHash, forwardPos, 0.0, false)
    
    SetEntityAlpha(fishHandle, 0, true) -- makes the fish invisible.

    -- DrawBusySpinner("Checking fishing location....")
    QBCore.Functions.Notify("Checking washing location...", "success", "3000")

    while GetGameTimer() - startedCheck < 3000 do
        Citizen.Wait(0)
    end

    RemoveLoadingPrompt()

    local fishInWater = IsEntityInWater(fishHandle)

    DeleteEntity(fishHandle)

    SetModelAsNoLongerNeeded(fishHash)

    return fishInWater or false
end

-- Events

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function() -- Event when player has successfully loaded
    TriggerEvent('qb-mine:client:DestroyZones') -- Destroy all zones
	TriggerEvent('qb-mine:client:DestroyPeds') -- Destroy all peds
	Wait(100)
	TriggerEvent('qb-mine:client:UpdateMiningZones') -- Reload mining information
	Wait(100)
	TriggerEvent('qb-mine:client:UpdateWashingZones') -- Reload washing information
	Wait(100)
	TriggerEvent('qb-mine:client:UpdateSmeltingZones') -- Reload smelting information
	Wait(100)
	CreateBlips() --Reload blips
	Wait(100)
	SpawnPeds() -- Shop ped at mining site
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function() -- Reset all variables
	TriggerEvent('qb-mine:client:DestroyZones') -- Destroy all zones
	inMineArea = false
    currentspot = nil
    previousspot = nil
    MiningLocations = {}
    WashingLocations = {}
    SmeltingLocations = {}
	Blips = {}
	Peds = {}
end)

AddEventHandler('onResourceStart', function(resource) -- Event when resource is reloaded
    if resource == GetCurrentResourceName() then -- Reload player information
		TriggerEvent('qb-mine:client:DestroyZones') -- Destroy all zones
		TriggerEvent('qb-mine:client:DestroyPeds') -- Destroy all peds
		Wait(100)
		TriggerEvent('qb-mine:client:UpdateMiningZones') -- Reload mining information
		Wait(100)
		TriggerEvent('qb-mine:client:UpdateWashingZones') -- Reload washing information
		Wait(100)
		TriggerEvent('qb-mine:client:UpdateSmeltingZones') -- Reload smelting information
		Wait(100)
		CreateBlips() --Reload blips
		Wait(100)
		SpawnPeds() -- Shop ped at mining site
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then -- Reload player information
		TriggerEvent('qb-mine:client:DestroyZones') -- Destroy all zones
		TriggerEvent('qb-mine:client:DestroyPeds') -- Destroy all peds
    end
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo) --Events when players change jobs
	TriggerEvent('qb-mine:client:DestroyZones') -- Destroy all zones
	TriggerEvent('qb-mine:client:DestroyPeds') -- Destroy all peds
	Wait(100)
	TriggerEvent('qb-mine:client:UpdateMiningZones') -- Reload mining information
	Wait(100)
	TriggerEvent('qb-mine:client:UpdateWashingZones') -- Reload washing information
	Wait(100)
	TriggerEvent('qb-mine:client:UpdateSmeltingZones') -- Reload smelting information
	Wait(100)
	CreateBlips() --Reload blips
	Wait(100)
	SpawnPeds() -- Shop ped at mining site
end)

RegisterNetEvent('qb-mine:client:UpdateMiningZones', function() -- Update Mining Zones
    for k, v in pairs(Config.Mining) do
        MiningLocations[k] = PolyZone:Create(v.zones, {
            name='MiningStation '..k,
            minZ = 	v.minz,
            maxZ = v.maxz,
            debugPoly = false
        })
    end
end)

RegisterNetEvent('qb-mine:client:UpdateWashingZones', function() -- Update Washing Zones
    for k, v in pairs(Config.Washing) do
        WashingLocations[k] = PolyZone:Create(v.zones, {
            name='WashingStation '..k,
            minZ = 	v.minz,
            maxZ = v.maxz,
            debugPoly = false
        })
    end
end)

RegisterNetEvent('qb-mine:client:UpdateSmeltingZones', function() -- Update Smelting Zones
    for k, v in pairs(Config.Smelting) do
        SmeltingLocations[k] = PolyZone:Create(v.zones, {
            name='SmeltingStation '..k,
            minZ = 	v.minz,
            maxZ = v.maxz,
            debugPoly = false
        })
    end
end)

RegisterNetEvent('qb-mine:client:DestroyZones', function() -- Destroy all zones
    if MiningLocations then
		for k, v in pairs(MiningLocations) do
			MiningLocations[k]:destroy()
		end
	end
    if WashingLocations then
		for k, v in pairs(WashingLocations) do
			WashingLocations[k]:destroy()
		end
	end
    if SmeltingLocations then
		for k, v in pairs(SmeltingLocations) do
			SmeltingLocations[k]:destroy()
		end
	end
	MiningLocations = {}
    WashingLocations = {}
    SmeltingLocations = {}
end)

RegisterNetEvent('qb-mine:client:DestroyPeds', function() -- Destroy spawned peds
    if Peds then
        for k, v in pairs(Peds) do
            exports['qb-target']:RemoveSpawnedPed(v)
        end
    end
	Peds = {}
end)

RegisterNetEvent('qb-mine:client:startmine', function() -- Start mining
	if not mineWait then
		mineWait = true
		SetTimeout(5000, function()
			mineWait = false
		end)
		local Ped = PlayerPedId()
		local coord = GetEntityCoords(Ped)
		for k, v in pairs(MiningLocations) do
			if MiningLocations[k] then
				if MiningLocations[k]:isPointInside(coord) then
					local model = loadModel(`prop_tool_pickaxe`)
					local axe = CreateObject(model, GetEntityCoords(Ped), true, false, false)
					AttachEntityToEntity(axe, Ped, GetPedBoneIndex(Ped, 57005), 0.09, 0.03, -0.02, -78.0, 13.0, 28.0, false, true, true, true, 0, true)
					QBCore.Functions.Progressbar("startmine", "Hacking and smacking", 3000, false, false, {
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = false,
						disableCombat = true,
					}, {
						animDict = "melee@hatchet@streamed_core",
						anim = "plyr_rear_takedown_b",
						flags = 16,
					}, {}, {}, function() -- Done
						Wait(1000)
						StopAnimTask(Ped, "melee@hatchet@streamed_core", "startmine", 1.0)
						ClearPedTasks(Ped)
						DeleteObject(axe)
						TriggerServerEvent('qb-mine:server:getItem', Config.MiningItems)
					end)
				end
			end
		end
	else
		QBCore.Functions.Notify("You need to wait a few more seconds to catch your breath.", "error")
	end
end)

RegisterNetEvent('qb-mine:client:startwash', function() -- Start washing
	local Ped = PlayerPedId()
	local coord = GetEntityCoords(Ped)
	for k, v in pairs(WashingLocations) do
		if WashingLocations[k] then 
			if WashingLocations[k]:isPointInside(coord) then
				if IsPedSwimming(PlayerPedId()) then
					QBCore.Functions.Notify("Can't wash this ore while swimming.", "error")
				else
					local waterValidated = IsInWater()
					if waterValidated then
						QBCore.Functions.Progressbar("startwash", "Washing your dirty rocks.", 4000, false, false, {
							disableMovement = true,
							disableCarMovement = true,
							disableMouse = false,
							disableCombat = true,
						}, {
							animDict = "amb@world_human_bum_wash@male@high@base", 
							anim = "base", 
							flags = 8,
						}, {}, {}, function() -- Done
							StopAnimTask(Ped, "amb@world_human_bum_wash@male@high@base", "startwash", 1.0)
							ClearPedTasks(Ped)
							TriggerServerEvent('qb-mine:server:getItem', Config.WashingItems)
						end)
					else
						QBCore.Functions.Notify("The water is too shallow here.", "error")
					end
				end
			else
				QBCore.Functions.Notify('The water here is not pure enough.', 'error')
			end
		end
	end	
end)

RegisterNetEvent('qb-mine:client:startsmelt', function() -- Start smelting
	local Ped = PlayerPedId()
	local coord = GetEntityCoords(Ped)
	for k, v in pairs(SmeltingLocations) do
		if SmeltingLocations[k] then 
			if SmeltingLocations[k]:isPointInside(coord) then
				QBCore.Functions.Progressbar("startsmelt", "Getting your rocks all hot and bothered.", 4000, false, false, {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				}, {
					animDict = "mp_arresting", 
					anim = "a_uncuff", 
					flags = 8,
				}, {}, {}, function() -- Done
					StopAnimTask(Ped, "mp_arresting", "startsmelt", 1.0)
					ClearPedTasks(Ped)
					TriggerServerEvent('qb-mine:server:getItem', Config.SmeltingItems)
				end)
			end
		end
	end
end)