Channel = class()

function Channel:_init(data, client)
    self._data = data
    self._client = client
    self._api = client._api
end

function Channel:getName()
    return self._data.name
end

function Channel:getId()
    return self._data.id
end

function Channel:getGuild()
    return self._data.guild_id
end

function Channel:isNSWF()
    return self._data.nsfw
end

function Channel:getMessage(id)
    local _, data, err = self._api:getMessage(self:getId(), id)
    if data == nil or not err then
        return false, "invalid_message"
    end
    
    return Message(data, self._client)
end

function Channel:setName(name)
    local _, _, err = self._api:modifyChannel(self:getId(), {
        name = name
    })

    return err
end

function Channel:setParent(id)
    local _, _, err = self._api:modifyChannel(self:getId(), {
        parent_id = id
    })

    return err
end

function Channel:send(data)
    if type(data) == "string" then
        data = {content = data}
    end

    local _, data, err = self._api:sendMessage(self:getId(), data)
    if not err then return false end

    return Message(data, self._client)
end

function Channel:delete()
    local _, _, err = self._api:deleteChannel(self:getId())
    return err
end