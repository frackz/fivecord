Bots = {}
Endpoint = {}
Config = {
    timeout = 3000, -- timeout for endpoint to wait for response
    events = {
        ready = 'READY',
        guild_create = 'GUILD_CREATE'
    }
}


exports("new", function()
    return Bots:New()
end)