Citizen.CreateThread(function()
    -- PlayerData management
    local PlayerData = QBCore.Functions.GetPlayerData()

    RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
    AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
        PlayerData = QBCore.Functions.GetPlayerData()
    end)

    RegisterNetEvent("QBCore:Client:OnPlayerUnload")
    AddEventHandler("QBCore:Client:OnPlayerUnload", function()
        PlayerData = nil
    end)

    RegisterNetEvent("QBCore:Client:OnJobUpdate")
    AddEventHandler("QBCore:Client:OnJobUpdate", function(job)
        if PlayerData then
            PlayerData.job = job
        else
            PlayerData = QBCore.Functions.GetPlayerData()
        end
    end)

    RegisterNetEvent("QBCore:Client:SetDuty")
    RegisterNetEvent('QBCore:Client:SetDuty', function(duty)
        if PlayerData.job then
            PlayerData.job.onduty = duty
        else
            PlayerData = QBCore.Functions.GetPlayerData()
        end
    end)
end)

RegisterNetEvent('ef-launder:client:notify')
AddEventHandler('ef-launder:client:notify', function(msg, type)
    QBCore.Functions.Notify(msg,type)
end)

function SetupLaunderBoss()
	BossHash = Config.BossPed[math.random(#Config.BossPed)]
	loc = Config.BossLocation[math.random(#Config.BossLocation)]
	QBCore.Functions.LoadModel(BossHash)
    Boss = CreatePed(0, BossHash, loc.x, loc.y, loc.z-1.0, loc.w, false, false)
    SetPedFleeAttributes(Boss, 0, 0)
    SetPedDiesWhenInjured(Boss, false)
    TaskStartScenarioInPlace(Boss, "WORLD_HUMAN_STAND_IMPATIENT", 0, true)
    SetPedKeepTask(Boss, true)
    SetBlockingOfNonTemporaryEvents(Boss, true)
    SetEntityInvincible(Boss, true)
    FreezeEntityPosition(Boss, true)
end

function DeleteBoss()
    local player = PlayerPedId()
	if DoesEntityExist(Boss) then
        ClearPedTasks(Boss) 
		ClearPedTasksImmediately(Boss)
        ClearPedSecondaryTask(Boss)
        FreezeEntityPosition(Boss, false)
        SetEntityInvincible(Boss, false)
        SetBlockingOfNonTemporaryEvents(Boss, false)
        TaskReactAndFleePed(Boss, player)
		SetPedAsNoLongerNeeded(Boss)
		Wait(8000)
		DeletePed(Boss)
        SetupLaunderBoss()
	end
end

function CreatePeds()
	SetupLaunderBoss()
end

CreateThread(function()
    CreatePeds()
end)


CreateThread(function()
    exports['qb-target']:AddTargetModel(Config.BossPed, {
        options = {
            { 
                type = "client", 
				event = "ef-launder:client:launder",
				icon = "fas fa-box",
				label = ("Clean that dirty money"),
			},
			
        },
        distance = 3.0 
    })

end)

function policeAlert()
    exports['ps-dispatch']:DrugSale()
end


RegisterNetEvent('ef-launder:client:launder', function()
    local hasItem = QBCore.Functions.HasItem('markedbills')

    if hasItem  then
        QBCore.Functions.Progressbar("search_register", ("We are cleaning the money series"), 5200, false, true, {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		}, {
		}, {}, {}, function() 
        end)
        Wait(5200)
        TriggerServerEvent("ef-launder:server:laundersucces")
        TriggerEvent('ef-launder:client:notify', "Here take the cash and watch out for the cops.", 'success')
        if math.random(1,100) <= Config.CallCopsChance then
            policeAlert()
        end
    else 
        TriggerEvent('ef-launder:client:notify', "You don't have any money to launder", 'error')
    end
end)

AddEventHandler('onResourceStop', function(r)
    if r == GetCurrentResourceName()
    then
        
        local player = PlayerPedId()
	    if DoesEntityExist(Boss) then
        ClearPedTasks(Boss) 
		ClearPedTasksImmediately(Boss)
        ClearPedSecondaryTask(Boss)
        FreezeEntityPosition(Boss, false)
        SetEntityInvincible(Boss, false)
        SetBlockingOfNonTemporaryEvents(Boss, false)
        TaskReactAndFleePed(Boss, player)
		SetPedAsNoLongerNeeded(Boss)
		Wait(8000)
		DeletePed(Boss)
	end
        end
    end)
