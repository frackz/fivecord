Client = class()

function Client:_init(token)
    self._token = token
    self._api = API(token, self)
    self._events = Event(self)
    self._cache = {
        guilds = Cache()
    }

    self._events:handle('ready', function(data)
        self.bot = User(data.user)
        self._socket.session = data.session_id
    end)

    self._events:handle('guildCreate', function(data)
        --self._cache.guilds:define(data.id, {
        --    channels = data.channels
        --})
    end)

    self._events:handle('channelCreate', function(data)
        if not self._cache.guilds:get(data.guild_id) then
            return print("Guild not cached")
        end

        --self._cache.guilds:set(data.id)
        print(json.encode(data))
    end)
end

function Client:setToken(token)
    if type(token) ~= "string" then
        return false, "token_invalid"
    end

    self._token = token
end

function Client:getChannel(channel)
    local status, data = self._api:getChannel(channel)
    if data == nil then
        return false, "invalid_channel"
    end
    return Channel(data, self)
end

function Client:on(...)
    self._events:handle(...)
end

function Client:run()
    CreateThread(function()
        local _, data = self._api:auth()
        if data == nil then
            return print("Information is incorrect.")
        end
    
        self._socket = Socket(self._token, self)
    end)
end