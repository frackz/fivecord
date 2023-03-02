local events = {
    ready = 'READY',
    guild_create = 'GUILD_CREATE'
}

addSetup(function(value)
    function value:on(event, func)
        local name = events[event]
        if type(event) ~= "string" then
            return false, "invalid_arguments"
        end
        if not name then
            return false, "invalid_event"
        end
        
        if value.events[name] == nil then
            value.events[name] = {func}
        else
            table.insert(value.events[name], func)
        end
    end

    function value:fireEvent(event, ...)
        if not value.events[event] then return end
        for _, v in pairs(value.events[event]) do
            v(...)
        end
    end
end)