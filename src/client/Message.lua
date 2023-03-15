Message = class()

function Message:_init(data, client)
    self._data = data
    self._client = client
    self._api = client._api

    self._channel = data.channel_id
end

-- Getters
function Message:getChannel()
    return self._client:getGuild(self._data.guild_id):getChannel(self._data.channel_id)
end

function Message:getGuild()
    return self._data.guild_id
end

function Message:getUser()
    return User(self._data.author, self._client)
end

function Message:getAuthor()
    return self:getUser()
end

function Message:getContent()
    return self._data.content
end

function Message:getEmbeds()
    return self._data.embeds
end

function Message:getId()
    return self._data.id
end

-- Maintain
function Message:pin()
    local _, _, err = self._api:pinMessage(self._channel, self:getId())
    return err
end

function Message:unpin()
    local _, _, err =  self._api:unpinMessage(self._channel, self:getId())
    return err
end

function Message:reply(data)
    if type(data) == "string" then
        data = {content = data}
    end

    data['message_reference'] = {message_id = self:getId()}

    local _, data, err = self._api:sendMessage(self._channel, data)
    
    if not err then
        return false
    end

    return Message(data, self._client)
end

function Message:edit(data)
    local channel = self._channel
    if type(data) == "string" then
        data = {content = data}
    end

    local _, _, err = self._api:editMessage(channel, self:getId(), data)
    return err
end

function Message:react(emoji)
    local status, _, err = self._api:reactMessage(self:getChannel():getId(), self:getId(), 'U+1F600')
    print(status)
    return err
end

function Message:delete()
    local _, _, err = self._api:deleteMessage(self:getChannel():getId(), self:getId())
    return err
end