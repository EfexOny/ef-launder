RegisterServerEvent("ef-launder:server:laundersucces",function(bani)

    local hasItem = QBCore.Functions.HasItem('markedbills')
	local ply = QBCore.Functions.GetPlayer(source)
    local nr = ply.Functions.GetItemByName(bani).amount

    ply.Functions.RemoveItem('markedbills', nr)
	ply.Functions.AddMoney('cash', nr*math.random(6500, 10000))
end)

