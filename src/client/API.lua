API = class()

local URL = 'https://discord.com/api/' .. 'v10'

local format = string.format

function API:_init(token)
    self._token = token
end

function API:_request(method, endpoint, payload, query)
    local status, data
    
    if not query then query = ''
    else query = json.encode(query) end

    payload = payload or {}
    payload['Authorization'] = 'Bot '..self._token
    payload['Content-Type'] = 'application/json'
    payload['User-Agent'] = "FiveCord (https://github.com/frackz/fivecord, 1.0)"

    PerformHttpRequest(URL .. endpoint, function (_, __, ___)
        status, data = _, __
    end, method, query, payload)

    repeat Wait(1) until status ~= nil
    return status, json.decode(data)
end

function API:auth()
    return self:_request('GET', endpoints.ME)
end

function API:getChannel(channel)
	return self:_request("GET", format(endpoints.CHANNEL, channel))
end

function API:getMessage(channel, message)
    return self:_request("GET", format(endpoints.MESSAGE, channel, message))
end

function API:modifyChannel(channel, payload)
	return self:_request("PATCH", format(endpoints.CHANNEL, channel), {}, payload)
end

function API:deleteChannel(channel)
    return self:_request("DELETE", format(endpoints.CHANNEL, channel))
end


-- Messages
function API:sendMessage(channel, data)
	return self:_request("POST", format(endpoints.MESSAGES, channel), {}, data)
end

function API:pinMessage(channel, message)
    return self:_request("PUT", format(endpoints.PIN, channel, message))
end

function API:unpinMessage(channel, message)
    return self:_request("DELETE", format(endpoints.PIN, channel, message))
end

function API:deleteMessage(channel, message)
    return self:_request("DELETE", format(endpoints.MESSAGE, channel, message))
end
