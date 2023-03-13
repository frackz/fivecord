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
        local channels, members, roles = {}, {}, {}

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
            return self:_error('Guild updated, but not cached')
        end

        self._cache.guilds[data.id].raw = data
    end)

    self._events:handle('guildDelete', function(data)
        local guild = self._cache.guilds[data.id]
        if not guild then
            return self:_error('Guild deleted, but not cached')
        end

        self._cache.guilds[data.id] = nil
    end)

    self._events:handle('channelCreate', function(data)
        if not self._cache.guilds[data.guild_id] then
            return self:_error('Channel created, but guild is not cached')
        end
        
        self._cache.guilds[data.guild_id].channels[data.id] = data
    end)

    self._events:handle('channelUpdate', function(data)
        if not self._cache.guilds[data.guild_id] or not self._cache.guilds[data.guild_id].channels[data.id] then
            return self:_error('Channel updated, but guild is not cached')
        end

        self._cache.guilds[data.guild_id].channels[data.id] = data
    end)

    self._events:handle('channelDelete', function(data)
        local guild = self._cache.guilds[data.guild_id]
        if not guild then
            return self:_error('Channel deleted, but guild is not cached')
        end

        guild.channels[data.id] = nil
    end)

    -- TODO: member leave & member join
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