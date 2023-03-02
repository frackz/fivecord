local functions = {}
messages = {}

function createBot()
    local value = table.copy(config.default)

    for _, v in pairs(functions) do
        v(value)
    end

    return value
end

function addSetup(func)
    table.insert(functions, func)
end

function addMessage(num, func)
    if not messages[num] then messages[num] = {func}
    else table.insert(messages[num], func) end
end