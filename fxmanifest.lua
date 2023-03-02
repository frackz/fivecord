-- Resource Metadata
fx_version 'cerulean'
game 'gta5' 

author 'frackz <github.com/frackz | frackz.xyz>'
description 'Example resource'
version '1.0.0'

server_scripts {
    'src/main.lua',
    'src/utils.lua',

    'src/client/socket.js',

    'src/endpoint.lua',
    'src/client/config.lua',
    'src/client/main.lua',

    'src/client/functions/set.lua',
    'src/client/functions/event.lua',
    'src/client/functions/socket.lua',
    'src/client/functions/run.lua',
    'src/client/functions/bot.lua',

    'src/client/messages/*.lua',
    'src/client/events/*.lua',

    'src/testing.lua'
}