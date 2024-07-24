RegisterCommand(Config.HashCommand, function(source, args)
    local player = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(player, false)
    if IsPedInAnyVehicle(player, true) then
        local vehicleHash = GetEntityModel(vehicle)
        TriggerEvent('chat:addMessage', {
            args = { '[Thomas Developments] Vehicle Hash: '.. vehicleHash }
        })
    else
        TriggerEvent('chat:addMessage', {
            args = { '[Thomas Developments] You are not in a vehicle.' }
        })
    end
end, false)



-- You can edit this to add custom notifiactions etc