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
    value.socket.platform = nil
    
    value.events = {}

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

    --- Handle a event
    --- @param event string
    --- @param func function
    function value:on(event, func)
        if type(event) ~= "string" or type(func) ~= "table" then
            return false, "invalid_arguments"
        end
        if not Config.events[event] then
            return false, "invalid_event"
        end
        
        local name = Config.events[event]

        if not value.events[name] then
            value.events[name] = {func}
        else
            table.insert(value.events[name], func)
        end
    end

    --- Run the discord bot
    function value:run()
        if value.token == nil then
            return false, "intents_or_token_not_set"
        end

        exports['fivecord']:connect(value.token, {
            setup = function(send, platform)
                function value.socket:send(...)
                    send(...)
                end

                value.socket.platform = platform
            end,
            message = function(data)
                local d, event, heartbeat = data.d, data.t, (data.d or {heartbeat_interval = nil}).heartbeat_interval
                
                if data.s ~= nil then 
                    value.socket.seq = data.s
                else
                    value.socket.seq = nil
                end

                if data.op == 0 then -- event
                    if value.events[event] then
                        for _, v in pairs(value.events[event]) do
                            v('test')
                        end
                    end
                elseif data.op == 9 then -- invalid session
                    wait(5)
                    value.socket.interval = heartbeat
                    value.socket:identity()
                elseif data.op == 10 then
                    value.socket.interval = heartbeat
                    CreateThread(function()
                        value.socket:heartbeat()
                    end)
                    value.socket:identity()
                end
            end
        })
    end
    
    -- Socket
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

    return value
end