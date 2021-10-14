local mining = false
local QBCore = exports['qb-core']:GetCoreObject()

-- Functions
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

-- Threads
CreateThread(function()
    local ped = PlayerPedId()
    for k, v in pairs(Config.MiningPositions) do
        addBlip(v.coords, 618, 5, 0.5, 'Mine')
    end
    addBlip(Config.Sell, 207, 1, 0.5, 'Sell mined items')

    CreateThread(function()
        while true do
            local sleep = 250
            if #(GetEntityCoords(PlayerPedId()) - Config.Sell) <= 3.0 then
                local sleep = 0
                helpText('Press ~INPUT_CONTEXT~ to sell all your mined items.')
                if IsControlJustReleased(0, 38) then
                    TriggerServerEvent('qb-mine:server:sell')
                    RequestAnimDict('amb@medic@standing@kneel@base')
                    RequestAnimDict('anim@gangops@facility@servers@bodysearch@')
                    FreezeEntityPosition(ped, true)

                    local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.9, -0.98))
                    prop1 = CreateObject(`hei_prop_heist_box`, x, y, z, true, true, true)
                    
                    TaskPlayAnim(ped, 'amb@medic@standing@kneel@base', 'base', 8.0, -8.0, -1, 1, 0, false, false, false)
                    TaskPlayAnim(ped, 'anim@gangops@facility@servers@bodysearch@', 'player_search', 8.0, -8.0, -1, 48, 0, false, false, false)

                    Wait(6000)
                    DeleteObject(prop1)
                    ClearPedTasksImmediately(ped)
                    FreezeEntityPosition(ped, false)
                end
            end
            Wait(sleep)
        end
    end)
    while true do
        local closeTo = 0
        for k, v in pairs(Config.MiningPositions) do
            if #(GetEntityCoords(PlayerPedId()) - vector3(v.coords.x, v.coords.y, v.coords.z)) <= 2.5 then
                closeTo = v
                break
            end
        end
        if type(closeTo) == 'table' then
            while #(GetEntityCoords(PlayerPedId()) - vector3(closeTo.coords.x, closeTo.coords.y, closeTo.coords.z)) <= 2.5 do
                Wait(0)
                helpText('Press ~INPUT_CONTEXT~ to mine.')
                if IsControlJustReleased(0, 38) then
                    local player, distance = QBCore.Functions.GetClosestPlayer()
                    if distance == -1 or distance >= 4.0 then
                        mining = true
                        SetEntityCoords(ped, closeTo.coords)
                        SetEntityHeading(ped, closeTo.coords.w)
                        FreezeEntityPosition(ped, true)
                        
                        local model = loadModel(`prop_tool_pickaxe`)
                        local axe = CreateObject(model, GetEntityCoords(ped), true, false, false)
                        AttachEntityToEntity(axe, ped, GetPedBoneIndex(ped, 57005), 0.09, 0.03, -0.02, -78.0, 13.0, 28.0, false, true, true, true, 0, true)
                        
                        while mining do
                            Wait(0)
                            SetCurrentPedWeapon(ped, `WEAPON_UNARMED`)
                            helpText('Press ~INPUT_ATTACK~ to chop, ~INPUT_FRONTEND_RRIGHT~ to stop.')
                            DisableControlAction(0, 24, true)
                            if IsDisabledControlJustReleased(0, 24) then
                                local dict = loadDict('melee@hatchet@streamed_core')
                                TaskPlayAnim(ped, dict, 'plyr_rear_takedown_b', 8.0, -8.0, -1, 2, 0, false, false, false)
                                local timer = GetGameTimer() + 800
                                while GetGameTimer() <= timer do
                                    Wait(0)
                                    DisableControlAction(0, 24, true)
                                end
                                ClearPedTasks(ped)
                                TriggerServerEvent('qb-mine:server:getItem')
                            elseif IsControlJustReleased(0, 194) then
                                break
                            end
                        end
                        mining = false
                        DeleteObject(axe)
                        FreezeEntityPosition(ped, false)
                    else
                        helpText('There is a player too close to you!')
                    end
                end
            end
        end
        Wait(250)
    end
end)