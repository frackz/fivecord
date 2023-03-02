let ws = require('ws')

exports('connect', (token, callbacks) => {
    const client = new ws('wss://gateway.discord.gg/?v=6&encoding=json')
    
    callbacks['setup']((data) => client.send(data), process.platform)

    client.on('error', console.error)
    client.on('open', () => console.log("Socket open"))
    client.on('message', (msg) => callbacks['message'](JSON.parse(msg)));
})