--- Send a endpoint
--- @param url string
function Endpoint:Send(url, data, headers)
    local timeout = 0
    local value = {}

    PerformHttpRequest(url, function(_, __, ___)
        value.error = _
        value.result = ___

        function value:json() return json.decode(__) end
        function value:number() return tonumber(__) end

        setmetatable(value, {
            __tostring = function()
                return __
            end
        })
    end, data, headers)

    repeat
        Wait(1)
        timeout = timeout + 1

        if timeout == Config.timeout then
            return {error = "endpoint_timeout"}
        end
    until value.error ~= nil

    return value
end