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
    if not self:exist(name, true) then
        return false, "invalid_event"
    end

    if not self._events[name] then
        self._events[name] = {callback}
    else
        insert(self._events[name], callback)
    end
end

function Event:exist(name, after)
    if not after then
        return EventNames[name] ~= nil
    else
        for _, v in pairs(EventNames) do
            if v == name then
                return true
            end
        end
        return false
    end
end

function EventHandlers.ready(self, data)
    return
end

function EventHandlers:heartbeatRecieved()
    return
end