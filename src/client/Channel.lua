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
    local _, data = self._api:getMessage(self:getId(), id)
    if data == nil then
        return false, "invalid_message"
    end
    return Message(data, self._client)
end

function Channel:setName(name)
    return self._api:modifyChannel(self:getId(), {
        name = name
    })
end

function Channel:setParent(id)
    return self._api:modifyChannel(self:getId(), {
        parent_id = id
    })
end

function Channel:send(data)
    if type(data) == "string" then
        print(self._api:sendMessage(self:getId(), {
            content = data
        }))
    else
        self._api:sendMessage(self:getId(), data)
    end
end

function Channel:delete()
    return self._api:deleteChannel(self:getId())
end