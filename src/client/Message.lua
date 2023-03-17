Message = class()

function Message:_init(data, client)
    self._data = data
    self._client = client
    self._api = client._api

    self._channel = data.channel_id
end

-- Getters
function Message:getChannel()
    return self:getGuild():getChannel(self._channel, self._client, self._data.guild_id)
end

function Message:getGuild()
    return self._client:getGuild(self._data.guild_id)
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
    if type(data) == "string" then
        data = {content = data}
    end

    local _, _, err = self._api:editMessage(self._channel, self:getId(), data)
    return err
end

function Message:react(emoji)
    local status, _, err = self._api:reactMessage(self._channel, self:getId(), emoji)
    return err
end

--deleteUserReact
function Message:deleteAllReactions()
    local status, _, err = self._api:deleteAllReactions(self._channel, self:getId())
    return err
end

function Message:deleteReactions(emoji)
    local status, _, err = self._api:deleteReactions(self._channel, self:getId(), emoji)
    return err
end

function Message:getReactions(emoji)
    local status, data, err = self._api:getReactions(self._channel, self:getId(), emoji)
    if not err then
        return err
    end

    local value = {}
    for k,v in pairs(data) do
        table.insert(value, User(v, self._client))
    end

    return value
end

function Message:deleteUserReaction(user, emoji)
    local status, _, err = self._api:deleteUserReact(self._channel, self:getId(), emoji, user)
    return err
end

function Message:removeReaction(emoji)
    local status, _, err = self._api:deleteReact(self._channel, self:getId(), emoji)
    return err
end

function Message:delete()
    local _, _, err = self._api:deleteMessage(self._channel, self:getId())
    return err
end