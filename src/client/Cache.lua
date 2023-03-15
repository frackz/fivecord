Cache = class()

function Cache:_init(client)
    self._client = client
    self._events = self._client._events
    self._guilds = self._client._cache.guilds
    self._events = {}
    function self:_error(...) self._client:_error(...) end

    function self:_getGuild(guild)
        return self._guilds[guild]
    end

    function self:_isChannel(guild, channel)
        return self:_getGuild(guild).channels[channel] ~= nil
    end

    function self:_isRole(guild, role)
        return self:_getGuild(guild).roles[role] ~= nil
    end

    function self:_isCached(guild)
        return self:_getGuild(guild) ~= nil
    end

    function self:_handle(event, func)
        self._events[event] = func
    end

    self:_handle('ready', function(data)
        self._client.bot = User(data.user, self)
        self._client._socket.session = data.session_id
    end)

    self:_handle('guildCreate', function(data)
        local channels, members, roles = {}, {}, {}

        for _, v in pairs(data.channels) do channels[v.id] = v end
        for _, v in pairs(data.members) do members[v.user.id] = v end
        for _, v in pairs(data.roles) do roles[v.id] = v end

        self._guilds[data.id] = { channels = channels, members = members, roles = roles, raw = data }
    end)

    self:_handle('guildUpdate', function(data)
        if not self:_isCached(data.id) then
            return self:_error('Guild updated, but not cached')
        end

        self:_getGuild(data.id).raw = data
    end)

    self:_handle('guildDelete', function(data)
        if not self:_isCached(data.id) then
            return self:_error('Guild deleted, but not cached')
        end

        self._cache.guilds[data.id] = nil
    end)

    self:_handle('channelCreate', function(data)
        if not self:_isCached(data.guild_id) then
            return self:_error('Channel created, but guild is not cached')
        end
        
        self:_getGuild(data.guild_id).channels[data.id] = data
    end)

    self:_handle('channelUpdate', function(data)
        if not self:_isCached(data.guild_id) or not self:_isChannel(data.guild_id, data.id) then
            return self:_error('Channel updated, but guild is not cached')
        end

        self:_getGuild(data.guild_id).channels[data.id] = data
    end)

    self:_handle('channelDelete', function(data)
        if not self:_isCached(data.guild_id) then
            return self:_error('Channel deleted, but guild is not cached')
        end

        self:_getGuild(data.guild_id).channels[data.id] = nil
    end)

    self:_handle('roleCreate', function(data)
        if not self:_isCached(data.guild_id) then
            return self:_error('Role created, but guild is not cached')
        end
        
        self:_getGuild(data.guild_id).roles[data.id] = data
    end)

    self:_handle('roleUpdate', function(data)
        if not self:_isCached(data.guild_id) or not self:_isRole(data.guild_id, data.id) then
            return self:_error('Role updated, but guild is not cached')
        end

        self:_getGuild(data.guild_id).roles[data.id] = data
    end)

    self:_handle('roleDelete', function(data)
        if not self:_isCached(data.guild_id) then
            return self:_error('Role deleted, but guild is not cached')
        end

        self:_getGuild(data.guild_id).roles[data.id] = nil
    end)
end

function Cache:_emit(name, ...)
    self._events[name](...)
end
