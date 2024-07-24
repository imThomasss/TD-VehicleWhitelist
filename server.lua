local label = [[

_   __      __    _       __       _      __ __    _  __        __ _      __    _   __ ___
| | / /___  / /   (_)____ / /___   | | /| / // /   (_)/ /_ ___  / /(_)___ / /_  | | / /<  /
| |/ // -_)/ _ \ / // __// // -_)  | |/ |/ // _ \ / // __// -_)/ // /(_-</ __/  | |/ / / / 
|___/ \__//_//_//_/ \__//_/ \__/   |__/|__//_//_//_/ \__/ \__//_//_//___/\__/   |___/ /_/  
                                                                                          

    Created by Thomas
]]


Citizen.CreateThread(function()
    Citizen.Wait(4000)
    print( label )
end)

Citizen.CreateThread( function()
	SetConvarServerInfo("Thomas' Vehicle Whitelist", "V1.0")

end)




local json = json


function hasPermission(playerId, vehicleSpawnCode)
    local query = string.format("SELECT * FROM vehicle_permissions WHERE player_id = '%s' AND vehicle_spawn_code = '%s'", playerId, vehicleSpawnCode)
    local result = exports["oxmysql"]:executeSync(query)
    return #result > 0
end


function whitelistPlayer(playerId, playerName, playerDiscordId, vehicleSpawnCode)
    local query = string.format("INSERT INTO vehicle_permissions (player_id, player_name, player_discord_id, vehicle_spawn_code) VALUES ('%s', '%s', '%s', '%s')", playerId, playerName, playerDiscordId, vehicleSpawnCode)
    exports["oxmysql"]:execute(query)
end

function kickPlayerFromVehicle(playerId)
    local vehicle = GetVehiclePedIsIn(GetPlayerPed(playerId), false)
    TaskLeaveVehicle(GetPlayerPed(playerId), vehicle, 0)
end

RegisterServerEvent("spawnVehicle")
AddEventHandler("spawnVehicle", function(vehicleSpawnCode)
    local playerId = source

    local isBlacklistedQuery = string.format("SELECT * FROM vehicle_permissions WHERE vehicle_spawn_code = '%s'", vehicleSpawnCode)
    local isBlacklisted = exports["oxmysql"]:executeSync(isBlacklistedQuery)
    if #isBlacklisted > 0 then
        TriggerClientEvent("chatMessage", playerId, "^1This vehicle is blacklisted.")
        return
    end

    if not hasPermission(playerId, vehicleSpawnCode) then
        TriggerClientEvent("chatMessage", playerId, "^1You don't have permission to drive this vehicle.")
        return
    end

    TriggerClientEvent("spawnVehicle", playerId, vehicleSpawnCode)
end)



RegisterNetEvent("addVehiclePermission")
AddEventHandler("addVehiclePermission", function(data)
    local vehicleSpawnCode = data.vehicleSpawnCode
    local cfxIdentifier = data.cfxIdentifier
    local playerName = data.playerName
    local playerDiscordId = data.playerDiscordId
    local playeradding = GetPlayerName(source)
    local player = source

    exports.oxmysql:execute('INSERT INTO vehicle_permissions (player_id, player_name, player_discord_id, vehicle_spawn_code) VALUES (?, ?, ?, ?)', {cfxIdentifier, playerName, playerDiscordId, vehicleSpawnCode}, function(rowsChanged)

        if Config.discordlogging then
            logwhitelist(vehicleSpawnCode, cfxIdentifier, playerName, playerDiscordId, playeradding)
        end
        TriggerClientEvent("TDWhitelist:client:notify:AddedVehicle", player)
    end, function(error)
        print("TD-Personal Vehicle Whitelist - There was an error when whitelisting a vehicle", error)
    end)
end)


function logwhitelist(vehicleSpawnCode, cfxIdentifier, playerName, playerDiscordId, playeradding)
    webhookmessage = (
        "**Player Name:** " .. playerName .. 
        "\n" ..
        "**Player Discord ID:** " .. playerDiscordId ..
        "\n" ..
        "**Identifier** " .. cfxIdentifier ..
        "\n" ..
        "**Vehicle Hash:** " .. vehicleSpawnCode ..
        "\n" ..
        "**Added by:** " .. playeradding  
    )
    if Config.discordlogging then
        local connect = {
            {
                ["color"] = 65280,
                ["title"] = "**[Thomas Developments] A Vehicle has been added to the whitelist.**",
                ["description"] = webhookmessage,
                ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ"),
                ["footer"] = {
                    ["text"] = "[TD Personal Vehicle Whitelist]",
                },
            }
        }
        PerformHttpRequest(Config.webhook, function(err, text, headers) end, 'POST', json.encode({embeds = connect}), { ['Content-Type'] = 'application/json' })
    end
end

RegisterServerEvent("open_menu")
AddEventHandler("open_menu", function()
    TriggerClientEvent("openUI", source) 
end)


RegisterServerEvent("close_menu")
AddEventHandler("close_menu", function()
    TriggerClientEvent("closeUI", source) 
end)



function kickPlayerFromVehicle(playerId)
    local playerPed = GetPlayerPed(playerId)
    if playerPed and DoesEntityExist(playerPed) then
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        if vehicle and DoesEntityExist(vehicle) then
            TaskLeaveVehicle(playerPed, vehicle, 0)
        end
    end
end




RegisterServerEvent("Thomas:WhitelistCheck")
AddEventHandler("Thomas:WhitelistCheck", function()
    local playerID = source
    local playerPed = GetPlayerPed(playerID)
    
    if not playerPed then
        print("Failed to get player ped.")
        TriggerClientEvent("chatMessage", source, "^1Error: Failed to retrieve player ped.")
        return
    end

    local vehicle = GetVehiclePedIsIn(playerPed, false) 
    

   
    
    local vehicle_spawn_code = GetEntityModel(vehicle)
    local player_cfx_id = GetPlayerIdentifier(playerID)

    local checkQuery = "SELECT * FROM vehicle_permissions WHERE vehicle_spawn_code = '" .. vehicle_spawn_code .. "'"
    
    exports.oxmysql:execute(checkQuery, {}, function(checkResult, checkAffectedRows)
        if checkResult and #checkResult > 0 then
            local query = "SELECT * FROM vehicle_permissions WHERE player_id = '" .. player_cfx_id .. "' AND vehicle_spawn_code = '" .. vehicle_spawn_code .. "'"

            exports.oxmysql:execute(query, {}, function(result, affectedRows)
                if result and #result > 0 then
                    -- print("Authorized")
                else
                    ClearPedTasksImmediately(playerID)
                    TriggerClientEvent('TDWhitelist:client:notify:VehicleError', playerID)
                    
                end
            end)
        else
            -- here you can notify staff or whatever you want 
        end
    end)
end)





RegisterCommand(Config.openUIcommand, function(source, args, rawCommand)
    local permission = source
    if Config.UsePlayerAce then
        if IsPlayerAceAllowed(source, "Thomas.PersonalVehicleUI") then
            TriggerClientEvent("Thomas:Development:OpenUI", source)
        else
            TriggerClientEvent('TDWhitelist:client:notify:CommandRestriction', source)
        end
    else 
        TriggerClientEvent("Thomas:Development:OpenUI", source)
    end
end)





RegisterCommand(Config.PlayerIDCommand, function(source, args, rawCommand)
    local playerId = source

    local cfxId = GetPlayerIdentifier(playerId, 0) 

    if cfxId ~= nil then

        TriggerClientEvent('chatMessage', source, " [Thomas Developments] Your CFX ID is: " .. cfxId)
    else
        TriggerClientEvent('chatMessage', source, "^1[Thomas Developments] Error: Unable to find your CFX ID.")
    end
end, false)
