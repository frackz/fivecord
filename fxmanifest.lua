-- Resource Metadata
fx_version 'cerulean'
game 'common' 

name 'FiveCord'
description 'Discord API wrapper for FXServer'
version '1.0.0'
url 'https://github.com/frackz/fivecord'
author 'frackz <github.com/frackz | frackz.xyz>'

server_scripts {
    'src/Endpoints.lua',
    'src/Class.lua',
    'src/Cache.lua',
    'src/Socket.js',
    'src/client/API.lua',
    'src/client/Socket.lua',
    'src/client/Event.lua',
    'src/client/User.lua',
    'src/client/Guild.lua',
    'src/client/Message.lua',
    'src/client/Role.lua',
    'src/client/Channel.lua',
    'src/client/Client.lua',

    'src/Test.lua'
}