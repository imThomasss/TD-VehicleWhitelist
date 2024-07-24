RegisterNetEvent('TDWhitelist:client:notify:CommandRestriction')
AddEventHandler('TDWhitelist:client:notify:CommandRestriction', function()
    lib.notify({
        id = 'CommandRestrictionNoti',
        title = 'Server Name',
        description = 'You are not allowed to use this command',
        showDuration = true,
        position = 'top-right',
        style = {
            backgroundColor = '#141517',
            color = '#C1C2C5',
            ['.description'] = {
              color = '#909296'
            }
        },
        icon = 'circle-info',
        iconAnimation = "beat",
        iconColor = '#ADD8E6'
    })
end)



RegisterNetEvent('TDWhitelist:client:notify:VehicleError')
AddEventHandler('TDWhitelist:client:notify:VehicleError', function()   -- Notification for when a player is removed from vehicle!
    lib.notify({
        id = 'VehicleErrorNoti',
        title = 'Server Name',
        description = 'This vehicle is a personal vehicle, you are not allowed to drive it.',
        showDuration = true,
        position = 'top-right',
        style = {
            backgroundColor = '#141517',
            color = '#C1C2C5',
            ['.description'] = {
              color = '#909296'
            }
        },
        icon = 'circle-info',
        iconAnimation = "beat",
        iconColor = '#ADD8E6'
    })
end)


RegisterNetEvent('TDWhitelist:client:notify:AddedVehicle')
AddEventHandler('TDWhitelist:client:notify:AddedVehicle', function()   -- Notification for when a vehicle is added!
    lib.notify({
        id = 'AddedVehicleNoti',
        title = 'Server Name',
        description = 'Vehicle has been successfully added!',
        showDuration = true,
        position = 'top-right',
        style = {
            backgroundColor = '#141517',
            color = '#C1C2C5',
            ['.description'] = {
              color = '#909296'
            }
        },
        icon = 'check',
        iconAnimation = "beat",
        iconColor = '#00ffb5'
    })
end)
