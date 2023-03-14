local insert, EventHandlers, EventNames = table.insert, {}, {
    ['READY'] = "ready",
    ['HEARTBEAT'] = 'heartbeatRecieved',
    ['SOCKET_MESSAGE'] = 'messageRecieved',
    ['GATEWAY_CLOSED'] = "gatewayClosed",
    ['GATEWAY_ERROR'] = "gatewayError",
    ['MESSAGE_CREATE'] = "messageCreate",

    -- Caching
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

    self._error = self._client._error
end

function Event:emit(name, ...)
    if not self._events[name] then
        if not EventNames[name] then
            return
        end

        name = EventNames[name]
        if not self._events[name] then
            return
        end
    end

    for i, v in pairs(self._events[name]) do
        local resp = EventHandlers[name](..., self._client)
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

function EventHandlers.roleCreate(data)
    return data
end

function EventHandlers.roleUpdate(data)
    return data
end

function EventHandlers.roleDelete(data)
    return data
end

function EventHandlers.ready(data)
    return data
end

function EventHandlers.gatewayError(err)
    return err
end

function EventHandlers.gatewayClosed(err)
    return err
end

function EventHandlers.guildCreate(data)
    return data
end

function EventHandlers.messageRecieved(data)
    return data
end

function EventHandlers.guildUpdate(data)
    return data
end

function EventHandlers.guildDelete(data)
    return data
end

function EventHandlers.channelCreate(data)
    return data
end

function EventHandlers.channelUpdate(data)
    return data
end

function EventHandlers.channelDelete(data)
    return data
end

function EventHandlers:heartbeatRecieved()
    return
end

function EventHandlers.messageCreate(data, client)
    if data.content == "" then
        return "DO_NOT_CALL"
    end
    return Message(data, client)
end