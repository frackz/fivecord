local timeout = 3000

function sendEndpoint(url, data, headers)
    local amount = 0
    local value = {}

    PerformHttpRequest(url, function(_, __, ___)
        value.error = _
        value.result = ___

        function value:json() return json.decode(__) end
        function value:number() return tonumber(__) end

        setmetatable(value, {__tostring = function() return __ end})
    end, data, headers)

    repeat
        Wait(1)
        amount = amount + 1
        if amount == timeout then
            return {error = "endpoint_timeout"}
        end
    until value.error ~= nil
    return value
end