Guild = class()

function Guild:_init(data, client)
    self._data = data
    self._client = client
    self._api = client._api
end

--- Get guild id
--- @return string | nil
function Guild:getId()
    return self._data.raw.id
end

--- Get guild name
--- @return string | nil
function Guild:getName()
    return self._data.raw.name
end

--- Set guild name
--- @return boolean
function Guild:setName(name)
    local _, _, err = self._api:modifyGuild(self:getId(), {
        name = name
    })

    return err
end

--- Get guild by id
--- @return table | boolean
function Guild:getUser(id)
    local member = self._data.members[id]
    if member then
        return User(member, self._client)
    else
        local _, data, err = self._client._api:getGuildMember(self:getId(), id)
        if data and err then
            self._data.members[id] = data
            return User(data, self._client)
        else
            return false
        end
    end
end

--- Ban a user
--- @param user table | string
--- @param reason string | nil
--- @param data table | nil
function Guild:banUser(user, reason, data)

end

--- Kick a user
--- @param user table | string
--- @param reason string | nil
function Guild:kickUser(user, reason)

end

--- Get channel
--- @param id string
--- @return table | boolean
function Guild:getChannel(id)
    if not self._data.channels[id] then
        return false
    end

    return Channel(self._data.channels[id], self._client, self:getId())
end

--- Get role
--- @param id string
--- @return table | boolean
function Guild:getRole(id)
    if not self._data.roles[id] then
        return false
    end

    return Role(self._data.roles[id], self._client, self)
end