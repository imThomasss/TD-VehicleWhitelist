fx_version 'cerulean'
game 'gta5'
lua54 'yes'



author 'Thomas'
description 'Vehicle Permissions System'
version '1.0.0'

client_scripts {
    'client.lua',
    'c_notification.lua',
    'commands.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

shared_scripts {   -- add notifaction here
    'config.lua',
    '@ox_lib/init.lua'
}

ui_page 'ui.html'

files {
    'ui.html'
}


escrow_ignore {
	"config.lua",
    "notification.lua",
    "commands.lua"
}

export 'SendNUIMessage'