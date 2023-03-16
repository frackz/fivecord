local insert, EventHandlers, EventNames = table.insert, {}, {
    ['READY'] = "ready",
    ['HEARTBEAT'] = 'heartbeatRecieved',
    ['SOCKET_MESSAGE'] = 'messageRecieved',
    ['GATEWAY_CLOSED'] = "gatewayClosed",
    ['GATEWAY_ERROR'] = "gatewayError",

    -- Caching
    ['MESSAGE_CREATE'] = "messageCreate",
    ['MESSAGE_UPDATE'] = "messageUpdate",

    ['CHANNEL_CREATE'] = "channelCreate",
    ['CHANNEL_UPDATE'] = "channelUpdate",
    ['CHANNEL_DELETE'] = "channelDelete",

    ['GUILD_CREATE'] = "guildCreate",
    ['GUILD_UPDATE'] = "guildUpdate",
    ['GUILD_DELETE'] = "guildDelete",

    ['GUILD_ROLE_CREATE'] = "roleCreate",
    ['GUILD_ROLE_UPDATE'] = "roleUpdate",
    ['GUILD_ROLE_DELETE'] = "roleDelete",
}

Event = class()

function Event:_init(client)
    self._events = {}
    self._client = client
    self._cache = self._client._cached

    self._error = self._client._error
end

function Event:emit(name, ...)
    local resp = nil
    if not self._events[name] then
        if not EventNames[name] then
            return
        end

        name = EventNames[name]
        resp = EventHandlers[name](..., self)
        if not self._events[name] then
            return
        end
    end

    for i, v in pairs(self._events[name]) do
        if resp == "DO_NOT_CALL" then return end
        local call, err = pcall(v, resp)
        if not call then
            self:_error("Error on emitting event "..name.." because of error: "..err)
            return table.remove(self._events[name], i)
        end
    end
end

function Event:handle(name, callback)
    if not self:exist(name) then
        return false, "invalid_event"
    end
    if self._events[name] then
        return insert(self._events[name], callback)
    end
    self._events[name] = {callback}
end

function Event:exist(name)
    for _, v in pairs(EventNames) do
        if v == name then
            return true
        end
    end

    return false
end

function EventHandlers.messageUpdate(data, self)
    self._cache:_emit('messageUpdate', data, self._client)
end

function EventHandlers.roleCreate(data, self)
    self._cache:_emit('roleCreate', data, self._client)
    return Role(data, self._client)
end

function EventHandlers.roleUpdate(data, self)
    self._cache:_emit('roleUpdate', data, self._client)
    return Role(data, self._client)
end

function EventHandlers.roleDelete(data)
    self._cache:_emit('roleDelete', data, self._client)
    return data
end

function EventHandlers.ready(data, self)
    self._cache:_emit('ready', data, self._client)
    return data
end

function EventHandlers.gatewayError(err)
    return err
end

function EventHandlers.gatewayClosed(err)
    return err
end

function EventHandlers.guildCreate(data, self)
    self._cache:_emit('guildCreate', data, self._client)
    return Guild(data, self._client)
end

function EventHandlers.messageRecieved(data)
    return data
end

function EventHandlers.guildUpdate(data, self)
    self._cache:_emit('guildUpdate', data, self._client)
    return Guild(data, self._client)
end

function EventHandlers.guildDelete(data)
    return data
end

function EventHandlers.channelCreate(data, self)
    self._cache:_emit('channelCreate', data, self._client)
    return Channel(data, self._client, data.guild_id)
end

function EventHandlers.channelUpdate(data, self)
    self._cache:_emit('channelUpdate', data, self._client)
    return Channel(data, self._client, data.guild_id)
end

function EventHandlers.channelDelete(data)
    return data
end

function EventHandlers:heartbeatRecieved()
    return
end

function EventHandlers.messageCreate(data, self)
    if data.content == "" then
        return "DO_NOT_CALL"
    end
    self._cache:_emit('messageCreate', data, self._client)
    return Message(data, self._client)
end