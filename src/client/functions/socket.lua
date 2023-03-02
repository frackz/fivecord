addSetup(function(value)
    function value.socket:heartbeat()
        while true do
            value.socket:send(json.encode({op = 1, d = value.socket.seq or "null"})) -- Keep discord updated
            Wait(value.socket.interval / 1000) -- Sleep timer
        end
    end

    function value.socket:identity()
        value.socket:send(json.encode({
            ['op'] = 2,
            ['d'] = {
                ['token'] = value.token,
                ['properties'] = {
                    ['$os'] = value.socket.platform,
                    ['$browser'] = "fivecord",
                    ['$device'] = "fivecord"
                }
            }
        }))
    end
end)