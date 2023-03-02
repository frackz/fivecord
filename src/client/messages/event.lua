local eventhandlers = {}

addMessage(0, function(value, data)
    if eventhandlers[data.t] then
        value:fireEvent(data.t, eventhandlers[data.t](value, data))
    else
        value:fireEvent(data.t)
    end
end)

function handleEvent(name, func)
    eventhandlers[name] = func
end