Client = class()

function Client:_init(token)
    self._token = token
    self._api = API(token, self)
    self._cache = { guilds = {} }
    self._timeout = 250
    self._cached = Cache(self)
    self._events = Event(self)
end

--- Get a guild by id
--- @param id string
--- @return table | boolean
function Client:getGuild(id)
    local data, amount = self._cache.guilds[id], 0
    if data == nil then
        -- wait for guilds to be loaded in, if ain't after 250 milliseconds the request will be discarded.
        while self._cache.guilds[id] == nil do
            amount = amount + 1
            
            if amount == 250 then
                return false
            end

            Wait(1)
        end
        data = self._cache.guilds[id]
    end

    return Guild(data, self)
end

--- Handle a event
function Client:on(...)
    return self._events:handle(...)
end

--- Run the bot, and start the socket, etc...
function Client:run()
    CreateThread(function()
        local _, data = self._api:auth()
        if data == nil then
            return self:_error('Failed to authenticate token')
        end
    
        self._socket = Socket(self._token, self)
    end)
end

function Client:_error(err)
    print("\27[31;1m"..err..'\27[0m')
end

function Client:_warn(warn)
    print("\27[33m"..warn..'\27[0m')
end

exports('new', function(token)
    return Client(token)
end)