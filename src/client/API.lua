API = class()

local URL = 'https://discord.com/api/' .. 'v10'

local format = string.format

function API:_init(token)
    self._token = token
end

function API:_request(encode, method, endpoint, payload, d)
    local status, data

    if not d then d = ''
    else d = json.encode(d) end

    payload = payload or {}
    payload['Authorization'] = 'Bot '..self._token
    payload['Content-Type'] = 'application/json'

    PerformHttpRequest(URL .. endpoint, function (_, __, ___)
        if ___['x-ratelimit-remaining'] == '0' then
            Wait(___['x-ratelimit-reset-after'] * 1000)
        end

        if _ == 429 then
            print(json.encode(___))
        end
        Wait(delay)
        status, data = _, __
    end, method, d, payload)

    repeat Wait(1) until status ~= nil
    print(status, endpoint)
    if not encode then
        return status, data
    else
        return status, json.decode(data)
    end
end

function API:auth()
    return self:_request(true, 'GET', endpoints.ME)
end

function API:getChannel(channel)
	return self:_request(true, "GET", format(endpoints.CHANNEL, channel))
end

function API:getMessage(channel, message)
    return self:_request(true, "GET", format(endpoints.MESSAGE, channel, message))
end

function API:modifyChannel(channel, payload)
	return self:_request(true, "PATCH", format(endpoints.CHANNEL, channel), {}, payload)
end

function API:deleteChannel(channel)
    return self:_request(true, "DELETE", format(endpoints.CHANNEL, channel))
end

function API:deleteMessage(channel, message)
    return self:_request(true, "DELETE", format(endpoints.MESSAGE, channel, message))
end