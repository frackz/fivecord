const ws = require('ws')

function Open(open, error, message, close) {
    const client = new ws('wss://gateway.discord.gg/?v=6&encoding=json')
    
    client.on('close', close)

    client.on('error', error)
    client.on('open', () => open((data) => client.send(data), process.platform, () => {
        Open(open, error, message, close)
    }))
    client.on('message', (msg) => message(JSON.parse(msg)));
}

exports('socket', Open)