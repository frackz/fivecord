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
    return User(self._data.author)
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
    local channel = self:getChannel():getId()
    if type(data) == "string" then
        return self._api:sendMessage(channel, {
            content = data,
            message_reference = {message_id = self:getId()}
        })
    else
        data['message_reference'] = {message_id = self:getId()}
        return self._api:sendMessage(channel, data)
    end
end

function Message:edit()

end

function Message:delete()
    self._api:deleteMessage(self._channel, self:getId())
end