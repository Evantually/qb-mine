local QBCore = exports['qb-core']:GetCoreObject()
local sellables = {
    steel = Config.Price.steel,
    iron = Config.Price.iron,
    copper = Config.Price.copper
}

-- Events
RegisterServerEvent('qb-mine:server:getItem', function()
    local Player, randomItem = QBCore.Functions.GetPlayer(source), Config.Items[math.random(1, #Config.Items)]
    if math.random(0, 100) <= Config.ChanceToGetItem then
        Player.Functions.AddItem(randomItem, 1)
        TriggerClientEvent('QBCore:Notify', source, 'You mined some '.. randomItem ..' ', 'success', 10000)
    end
end)

RegisterServerEvent('qb-mine:server:sell', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    for k,v in pairs(sellables) do
        local item = Player.Functions.GetItemByName(k)
        if item ~= nil then
            if Player.Functions.RemoveItem(k, item.amount) then
                TriggerClientEvent('QBCore:Notify', src, 'You sold '..item.amount..' '..k, 'success')
                Player.Functions.AddMoney('cash', v * item.amount)
            end
        end
    end
end)
