local insert, EventHandlers, EventNames = table.insert, {}, {
    ['READY'] = "ready",
    ['heartbeatRecieved'] = 'heartbeatRecieved',
    ['MESSAGE_CREATE'] = "messageCreate",

    -- Caching
    ['GUILD_CREATE'] = "guildCreate",
    ['CHANNEL_CREATE'] = "channelCreate",
    ['CHANNEL_UPDATE'] = "channelUpdate",
    ['GUILD_UPDATE'] = "guildUpdate"
}

Event = class()

function Event:_init(client)
    self._events = {}
    self._client = client
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

    for _, v in pairs(self._events[name]) do
        v(EventHandlers[name](..., self._client))
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

function EventHandlers.ready(data)
    return data
end

function EventHandlers.guildCreate(data)
    return data
end

function EventHandlers.guildUpdate(data)
    return data
end

function EventHandlers.channelCreate(data)
    return data
end

function EventHandlers.channelUpdate(data)
    return data
end

function EventHandlers:heartbeatRecieved()
    return
end

function EventHandlers.messageCreate(data, client)
    return Message(data, client)
end