Channel = class()

function Channel:_init(data, client, guild)
    self._data = data
    self._client = client
    self._api = client._api
    self._guild = guild
end

function Channel:getName()
    return self._data.name
end

function Channel:getId()
    return self._data.id
end

function Channel:getGuild()
    return self._client:getGuild(self._guild)
end

function Channel:isNSWF()
    return self._data.nsfw
end

function Channel:getMessage(id)
    local message = (self:getGuild()._data.messages[id] or {raw = nil}).raw
    if message then
        return Message(message, self._client)
    end
    
    local _, data, err = self._api:getMessage(self:getId(), id)
    if data == nil or not err then
        return false, "invalid_message"
    end

    return Message(data, self._client)
end

function Channel:modify(data)
    local _, _, err = self._api:modifyChannel(data)

    return err
end

function Channel:setName(name)
    return self:modify({name = name})
end

function Channel:setParent(id)
    return self:modify({parent_id = id})
end

function Channel:send(data)
    if type(data) == "string" then
        data = {content = data}
    end

    local _, data, err = self._api:sendMessage(self:getId(), data)

    if not err then
        return false
    end

    return Message(data, self._client)
end

function Channel:delete()
    local _, _, err = self._api:deleteChannel(self:getId())
    return err
end