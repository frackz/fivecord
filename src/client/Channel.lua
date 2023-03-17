Channel = class()

function Channel:_init(data, client, guild)
    self._data = data
    self._client = client
    self._api = client._api
    self._guild = guild
end

--- Get the channel's name
--- @return string
function Channel:getName()
    return self._data.name
end

--- Get the channel's id
--- @return string
function Channel:getId()
    return self._data.id
end

--- Get the channel's guild
--- @return table
function Channel:getGuild()
    return self._client:getGuild(self._guild)
end

--- Is the channel NSWF?
--- @return boolean
function Channel:isNSWF()
    return self._data.nsfw
end

--- Is the channel NSWF?
--- @param id string
--- @return table | boolean
function Channel:getMessage(id)
    local message = (self:getGuild()._data.messages[id] or {raw = nil}).raw
    if message then
        return Message(message, self._client)
    end
    
    local _, data, err = self._api:getMessage(self:getId(), id)
    if data == nil or not err then
        return false
    end

    return Message(data, self._client)
end

--- Modify the channel
--- @param data table
--- @return boolean
function Channel:modify(data)
    local _, _, err = self._api:modifyChannel(data)
    return err
end

--- Set the channel's name
--- @param name string
--- @return boolean
function Channel:setName(name)
    return self:modify({name = name})
end

--- Set the channel's parent
--- @param id string
--- @return boolean
function Channel:setParent(id)
    return self:modify({parent_id = id})
end

--- Send a message in the channel
--- @param data table | string
--- @return table | boolean
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

--- Delete the channel
--- @return boolean
function Channel:delete()
    local _, _, err = self._api:deleteChannel(self:getId())
    return err
end