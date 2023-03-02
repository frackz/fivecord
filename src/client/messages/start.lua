addMessage(10, function(value, data)
    local d = data.d
    local heartbeat = (d or {heartbeat_interval = nil}).heartbeat_interval

    value.socket.interval = heartbeat
    CreateThread(function() -- start heartbeat
        value.socket:heartbeat()
    end)
    value.socket:identity() -- send identity payload
end)

addMessage(9, function(value, data) -- invalid session
    local d = data.d
    local heartbeat = (d or {heartbeat_interval = nil}).heartbeat_interval

    value.socket.interval = heartbeat
    value.socket:identity()
end)