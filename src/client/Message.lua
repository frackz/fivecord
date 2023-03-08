Message = class()

function Message:_init(data, client)
    self._data = data
    self._client = client
end

-- Getters
function Message:getChannel()
    return self._client:getChannel(self._data.channel_id)
end

function Message:getGuild()
    return self._data.guild_id
end

function Message:getUser()
    return User(self._data.author)
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
function Message:edit()

end

function Message:delete()
    self._client._api:deleteMessage(self:getChannel():getId(), self:getId())
end