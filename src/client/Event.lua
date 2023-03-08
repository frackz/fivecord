local insert, EventHandlers, EventNames = table.insert, {}, {
    ['READY'] = "ready",
    ['heartbeatRecieved'] = 'heartbeatRecieved'
}

Event = class()

function Event:_init()
    self._events = {}
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
        v(EventHandlers[name](...))
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

function EventHandlers:heartbeatRecieved()
    return
end