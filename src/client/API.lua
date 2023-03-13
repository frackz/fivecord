API = class()

local URL = 'https://discord.com/api/' .. 'v10'

local format = string.format

function API:_init(token)
    self._token = token
end

function API:_request(method, endpoint, payload, query)
    local status, data
    local err = true
    
    if not query then query = ''
    else query = json.encode(query) end

    payload = payload or {}
    payload['Authorization'] = 'Bot '..self._token
    payload['Content-Type'] = 'application/json'
    payload['User-Agent'] = "FiveCord (https://github.com/frackz/fivecord)"

    PerformHttpRequest(URL .. endpoint, function (_, __, ___)
        status, data = _, __
    end, method, query, payload)

    repeat Wait(1) until status ~= nil

    if status ~= 200 and status ~= 201 and status ~= 204 then
        err = false
    end
    
    return status, json.decode(data), err
end

function API:auth()
    return self:_request('GET', endpoints.USER_ME)
end

function API:getChannel(channel)
	return self:_request("GET", format(endpoints.CHANNEL, channel))
end

function API:getMessage(channel, message)
    return self:_request("GET", format(endpoints.CHANNEL_MESSAGE, channel, message))
end

function API:modifyChannel(channel, payload)
	return self:_request("PATCH", format(endpoints.CHANNEL_CHANNEL, channel), {}, payload)
end

function API:deleteChannel(channel)
    return self:_request("DELETE", format(endpoints.CHANNEL_CHANNEL, channel))
end

-- Guild
function API:getGuildMember(guild, member)
    return self:_request("GET", format(endpoints.GUILD_MEMBER, guild, member))
end

function API:modifyGuild(guild, payload)
    return self:_request("PATCH", format(endpoints.GUILD, guild), {}, payload)
end

-- Messages
function API:sendMessage(channel, data)
	return self:_request("POST", format(endpoints.CHANNEL_MESSAGES, channel), {}, data)
end

function API:pinMessage(channel, message)
    return self:_request("PUT", format(endpoints.CHANNEL_PIN, channel, message))
end

function API:unpinMessage(channel, message)
    return self:_request("DELETE", format(endpoints.CHANNEL_PIN, channel, message))
end

function API:editMessage(channel, message, data)
    return self:_request("PATCH", format(endpoints.CHANNEL_MESSAGE, channel, message), {}, data)
end

function API:deleteMessage(channel, message)
    return self:_request("DELETE", format(endpoints.CHANNEL_MESSAGE, channel, message))
end
