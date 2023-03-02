function Bots:New()
    local id = #Bots + 1
    Bots[id] = {}

    local value = Bots[id]
    value.id = id
    value.token = nil
    value.intents = nil

    value.socket = {}
    value.socket.interval = nil
    value.socket.seq = nil

    --- Set the token of the bot
    --- @param token string
    function value:setToken(token)
        if type(token) ~= "string" then
            return false, "token_invalid"
        end

        value.token = token
    end
    
    --- Set the intents of the bot
    --- @param intents table
    function value:setIntents(intents)
        if type(intents) ~= "table" then
            return false, "intents_invalid"
        end

        value.intents = intents
    end

    --- Run the discord bot
    function value:run()
        if value.token == nil then
            return false, "intents_or_token_not_set"
        end

        exports['fivecord']:connect(value.token, {
            setup = function(send)
                function value.socket:send(...)
                    send(...)
                end
            end,
            message = function(data)
                local data, d, event, heartbeat = JSON.parse(msg), data.d, data.t, (d or {heartbeat_interval = nil}).heartbeat_interval
        
                if data.s then value.socket.seq = data.s
                else value.socket.seq = nil end
                
                if data.op == 0 then -- event
                    print("fire event " ..json.encode(d))
                    callbacks['fireEvent'](event['d'])
                else if data.op == 9 then -- invalid session
                    sleep(5)

                    value.socket.interval = heartbeat
                    upkeep()
                else if data.op == 10 then
                    interval = heartbeat

                    heartbeat()
                    upkeep()
                end
            end
        })
        en
    end
    
    -- Socket
    function value.socket:heartbeat()
        while true do
            value.socket:send(json.encode({op = 1, d = value.socket.seq})) -- Keep discord updated
            wait(value.socket.interval / 1000) -- Sleep timer
        end
    end

    return value
end