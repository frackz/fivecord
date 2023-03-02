const sleep = ms => new Promise(r => setTimeout(r, ms)), ws = require('ws')

exports('connect', (token, callbacks) => {
    console.log("hey")
    const client = new ws('wss://gateway.discord.gg/?v=6&encoding=json')
    let interval, seq, heartbeat = async () => {
        while (true) {
            client.send(JSON.stringify({op: 1, d: seq})) // Keep discord updated
            await sleep(interval / 1000) // Sleep timer
        }
    }, upkeep = () => {
        client.send(JSON.stringify({
            op: 2,
            d: {
                "token": token,
                "properties": {
                    "$os": process.platform,
                    "$browser": "fivecord",
                    "$device": "fivecord"
                }
            }
        }))
    }

    callbacks['setup'](client.send)

    client.on('error', console.error)

    client.on('open', () => console.log("Socket open"))

    client.on('message', (msg) => {
        callbacks['message'](msg)
        let data = JSON.parse(msg), d = data.d, event = data.t, heartbeat_interval = (d || {heartbeat_interval: null}).heartbeat_interval
        
        if (data.s) seq = data.s
        else seq = null
        
        if (data.op == 0) { // event
            console.log("fire event: "+event)
            callbacks['fireEvent'](event['d'])
        } else if (data.op == 9) { // invalid session
            sleep(5)

            interval = heartbeat_interval
            upkeep()
        } else if (data.op == 10) {
            interval = data["d"]["heartbeat_interval"]

            heartbeat()
            upkeep()
        }
    });
})