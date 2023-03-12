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
    self._api:pinMessage(self._channel, self:getId())
end

function Message:unpin()
    self._api:unpinMessage(self._channel, self:getId())

end

function Message:reply(data)
    if type(data) == "string" then
        data = {content = data}
    end

    data['message_reference'] = {message_id = self:getId()}

    local status, data = self._api:sendMessage(self._channel, data)
    if status ~= 200 then
        return false, data
    end

    return Message(data, self._client)
end

function Message:edit(data)
    local channel = self._channel
    if type(data) == "string" then
        return self._api:editMessage(channel, self:getId(), {
            content = data
        })
    else
        return self._api:editMessage(channel, self:getId(), data)
    end
end

function Message:delete()
    return self._api:deleteMessage(self._channel, self:getId())
end