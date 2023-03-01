Bots = {}
Endpoint = {}
Config = {
    timeout = 3000 -- timeout for endpoint to wait for response
}


exports("new", function()
    return Bots:New()
end)