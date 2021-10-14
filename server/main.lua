local QBCore = exports['qb-core']:GetCoreObject()
local sellables = {
    steel = Config.Price.steel,
    iron = Config.Price.iron,
    copper = Config.Price.copper
}

RegisterServerEvent('qb-mine:getItem')
AddEventHandler('qb-mine:getItem', function()
    local Player, randomItem = QBCore.Functions.GetPlayer(source), Config.Items[math.random(1, #Config.Items)]
    if math.random(0, 100) <= Config.ChanceToGetItem then
        Player.Functions.AddItem(randomItem, 1)
        TriggerClientEvent("QBCore:Notify", source, "You mined some ".. randomItem .." ", "success", 10000)
    end
end)

RegisterServerEvent('qb-mine:sell')
AddEventHandler('qb-mine:sell', function()
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    for k,v in pairs(sellables) do
        local item = xPlayer.Functions.GetItemByName(k)
        if item ~= nil then
            if xPlayer.Functions.RemoveItem(k, item.amount) then
                TriggerClientEvent("QBCore:Notify", src, 'You sold '..item.amount..' '..k, 'success')
                xPlayer.Functions.AddMoney('cash', v * item.amount)
            end
        end
    end
end)
