--- Send a endpoint
--- @param url string
function Endpoint:Send(url, data, headers)
    local timeout = 0
    local value = {}

    PerformHttpRequest(url, function(_, __, ___)
        function value:getError() return _ end
        function value:getData()
            local resp = {}

            function resp:json() return json.decode(__) end
            function resp:number() return tonumber(__) end
            setmetatable(resp, {__tostring = function() return __ end})

            return resp
        end
        function value:getResult() return ___ end
    end, data, headers)

    repeat
        Wait(1)
        timeout = timeout + 1

        if timeout == Config.timeout then
            function value:getError()
                return "endpoint_timeout_failure"
            end

            return value
        end
    until value.getData ~= nil

    return value
end