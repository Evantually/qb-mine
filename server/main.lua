local QBCore = exports['qb-core']:GetCoreObject()

-- Events
RegisterServerEvent('qb-mine:server:getItem', function(itemlist)
    local Player = QBCore.Functions.GetPlayer(source)
    local itemlist = itemlist
    local removed = false
    for k, v in pairs(itemlist) do
        if v.threshold > math.random(0, 100) then
            Player.Functions.AddItem(v.name, math.random(1, v.max))
            TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[v.name], "add")
            if v.remove ~= nil and not removed then
                removed = true
                Player.Functions.RemoveItem(v.remove, 1)
                TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[v.remove], "remove")
            end
        end
    end
end)

QBCore.Functions.CreateUseableItem("pickaxe", function(source, item)
	local src = source
    TriggerClientEvent('qb-mine:client:startmine', src)
end)

QBCore.Functions.CreateUseableItem("sifter", function(source, item)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local item = Player.Functions.GetItemByName("raw_ore")
    if item ~= nil then
        TriggerClientEvent('qb-mine:client:startwash', src)
    else
        TriggerClientEvent('QBCore:Notify', src, 'You have nothing to wash.', 'error')
    end
end)

QBCore.Functions.CreateUseableItem("unrefined_ore", function(source, item)
	local src = source
    TriggerClientEvent('qb-mine:client:startsmelt', src)
end)