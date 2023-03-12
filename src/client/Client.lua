Client = class()

function Client:_init(token)
    self._token = token
    self._api = API(token, self)
    self._events = Event(self)
    self._cache = { guilds = {} }
    self._timeout = 250

    self._events:handle('ready', function(data)
        self.bot = User(data.user, self)
        self._socket.session = data.session_id
    end)

    self._events:handle('guildCreate', function(data)
        local channels = {}
        local members = {}
        local roles = {}

        for _, v in pairs(data.channels) do
            channels[v.id] = v
        end

        for _, v in pairs(data.members) do
            members[v.user.id] = v
        end

        for _, v in pairs(data.roles) do
            roles[v.id] = v
        end

        self._cache.guilds[data.id] = {
            channels = channels, -- will be updated
            members = members,
            roles = roles,
            raw = data -- will be updated
        }
    end)

    self._events:handle('guildUpdate', function(data)
        if not self._cache.guilds[data.id] then
            return print("Guild is not cached!")
        end

        self._cache.guilds[data.id].raw = data
    end)

    self._events:handle('guildDelete', function(data)
        local guild = self._cache.guilds[data.id]
        if not guild then
            return print("Guild is not cached")
        end

        self._cache.guilds[data.id] = nil
    end)

    self._events:handle('channelCreate', function(data)
        if not self._cache.guilds[data.guild_id] then
            return print("Guild is not cached")
        end
        
        self._cache.guilds[data.guild_id].channels[data.id] = data
    end)

    self._events:handle('channelUpdate', function(data)
        if not self._cache.guilds[data.guild_id] or not self._cache.guilds[data.guild_id].channels[data.id] then
            return print("Guild or channel is not cached")
        end

        self._cache.guilds[data.guild_id].channels[data.id] = data
    end)

    self._events:handle('channelDelete', function(data)
        local guild = self._cache.guilds[data.guild_id]
        if not guild then
            return print("Guild is not cached")
        end

        guild.channels[data.id] = nil
    end)

    -- TODO: member leave & member join
end

function Client:setToken(token)
    if type(token) ~= "string" then
        return false, "token_invalid"
    end

    self._token = token
end

function Client:getGuild(id)
    local data, amount = self._cache.guilds[id], 0
    if data == nil then
        while self._cache.guilds[id] == nil do
            amount = amount + 1
            
            if amount == 250 then
                return false, "invalid_guild_or_slow_client"
            end

            Wait(1)
        end
        data = self._cache.guilds[id]
    end

    return Guild(data, self)
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