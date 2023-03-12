local insert, EventHandlers, EventNames = table.insert, {}, {
    ['READY'] = "ready",
    ['HEARTBEAT'] = 'heartbeatRecieved',
    ['SOCKET_MESSAGE'] = 'messageRecieved',
    ['MESSAGE_CREATE'] = "messageCreate",

    -- Caching
    ['CHANNEL_CREATE'] = "channelCreate",
    ['CHANNEL_UPDATE'] = "channelUpdate",
    ['CHANNEL_DELETE'] = "channelDelete",

    ['GUILD_CREATE'] = "guildCreate",
    ['GUILD_UPDATE'] = "guildUpdate",
    ['GUILD_DELETE'] = "guildDelete",
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

    for i, v in pairs(self._events[name]) do
        local resp = EventHandlers[name](..., self._client)
        if resp == "DO_NOT_CALL" then return end
        
        local call, err = pcall(v, resp)
        if not call then
            print("Error on emitting event "..name.." because of error: "..err)
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

local first = true
function EventHandlers.ready(data)
    if first then
        return data
    else
        repeat Wait(1) until self._client._socket._session ~= nil
        return data
    end
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