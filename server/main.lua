RegisterServerEvent("ef-launder:server:laundersucces",function()

    local hasItem = QBCore.Functions.HasItem('markedbills')
	local ply = QBCore.Functions.GetPlayer(source)

    ply.Functions.RemoveItem('markedbills', 1)
	ply.Functions.AddMoney('cash', math.random(6500, 10000))
end)

