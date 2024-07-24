
RegisterNetEvent("Thomas:Development:OpenUI")
AddEventHandler("Thomas:Development:OpenUI", function()
    SendNUIMessage({ type = "open" })
    SetNuiFocus(true, true)
end)


RegisterNUICallback("open", function(data, cb)
    SetNuiFocus(true, true)
    SendNUIMessage({ type = "open" })
    cb("ok")
end)


RegisterNUICallback("close", function(data, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({ type = "close" })
    cb("ok")
end)


RegisterNetEvent("openAddVehicleMenu")
AddEventHandler("openAddVehicleMenu", function()
    SendNUIMessage({
        type = "open_menu" 
    })
    SetNuiFocus(true, true) 
end)

RegisterNUICallback("close_menu", function(data, cb)
    SetNuiFocus(false, false) 
    SendNUIMessage({
        type = "close_menu" 
    })
    cb("ok")
end)

RegisterNUICallback("add_vehicle_permission", function(data, cb)
    TriggerServerEvent("addVehiclePermission", data)
end)


RegisterNetEvent("vehiclePermissionAdded")
AddEventHandler("vehiclePermissionAdded", function(success)
    if success then
        SetNuiFocus(false, false) 
        SendNUIMessage({
            type = "close_menu" 
        })
    else
        -- Handle error or display message to the player
    end
end)


RegisterNetEvent("openUI")
AddEventHandler("openUI", function()

    reveaUI();
end)


RegisterNetEvent("closeUI")
AddEventHandler("closeUI", function(source)
    closeUI();
end)



function IsPlayerInVehicle()
    local playerPed = PlayerPedId()
    return IsPedInAnyVehicle(playerPed, false)
end



    Citizen.CreateThread(function()
        local lastVehicle = 0
        
        while true do
            Citizen.Wait(0) 
            
            local playerPed = PlayerPedId()
            local currentVehicle = GetVehiclePedIsIn(playerPed, false)
            
            if currentVehicle ~= 0 and currentVehicle ~= lastVehicle then
                local seat = GetPedInVehicleSeat(currentVehicle, -1) 
                TriggerServerEvent("playerEnteredVehicle", currentVehicle, seat)
                lastVehicle = currentVehicle
            end
        end
    end)


    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(100)
            local playerPed = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            if vehicle ~= 0 and DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
                local seat = GetPedInVehicleSeat(vehicle, source)
                local model = GetEntityModel(vehicle)
                local driver = GetPedInVehicleSeat(vehicle, -1)
                if driver == playerPed then
                    TriggerServerEvent("Thomas:WhitelistCheck", seat, vehicle, model)
                end
            end
        end
    end)
    
