Guild = class()

function Guild:_init(data, client)
    self._data = data
    self._client = client
    self._api = client._api
end

function Guild:getId()
    return self._data.raw.id
end

function Guild:getName()
    return self._data.raw.name
end

function Guild:setName(name)
    local _, _, err = self._api:modifyGuild(self:getId(), {
        name = name
    })

    return err
end

function Guild:getUser(id)
    local member = self._data.members[id]
    if member then
        return User(member, self._client)
    else
        local status, data, err = self._client._api:getGuildMember(self:getId(), id)
        if data and err then
            self._data.members[id] = data
            return User(data, self._client)
        else
            return false, "invalid_user"
        end
    end
end

function Guild:getChannel(id)
    if not self._data.channels[id] then
        return false, "invalid_channel"
    end

    return Channel(self._data.channels[id], self._client, self:getId())
end

function Guild:getRole(id)
    if not self._data.roles[id] then
        return false, "invalid_role"
    end

    return Role(self._data.roles[id], self._client, self)
end