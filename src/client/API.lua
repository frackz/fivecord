API = class()

local URL = 'https://discord.com/api/' .. 'v10'

local insert, format, encode, decode = table.insert, string.format, json.encode, json.decode

function API:_init(token)
    self._token = token
end

function API:_request(method, endpoint, payload, d)
    local status, data
    if not d then d = ''
    else d = encode(d) end

    payload = payload or {}
    payload['Authorization'] = 'Bot '..self._token
    payload['Content-Type'] = 'application/json'

    PerformHttpRequest(URL .. endpoint, function (_, __, ___)
        status, data = _, __
    end, method, d, payload)

    repeat Wait(1) until status ~= nil
    return status, data
end

function API:auth()
    return self:_request('GET', endpoints.ME)
end

function API:getChannel(channel)
	return self:_request("GET", format(endpoints.CHANNEL, channel))
end

function API:modifyChannel(channel, payload)
	return self:_request("PATCH", format(endpoints.CHANNEL, channel), {}, payload)
end

function API:deleteChannel(channel)
    return self:_request("DELETE", format(endpoints.CHANNEL, channel))
end