addSetup(function(value)
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
                local op = data.op

                if data.s ~= nil then value.socket.seq = data.s
                else value.socket.seq = nil end

                if messages[op] then
                    for _, v in pairs(messages[op]) do
                        v(value, data)
                    end
                end
            end
        })
    end
end)