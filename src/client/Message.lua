Message = class()

function Message:_init(data, client)
    self._data = data
    self._client = client
    self._api = client._api

    self._channel = data.channel_id
end

--- Get channel
--- @return table | boolean
function Message:getChannel()
    return self:getGuild():getChannel(self._channel, self._client, self._data.guild_id)
end

--- Get guild
--- @return table | boolean
function Message:getGuild()
    return self._client:getGuild(self._data.guild_id)
end

--- Get user
--- @return table
function Message:getUser()
    return User(self._data.author, self._client)
end

--- Get author / user
--- @return table
function Message:getAuthor()
    return self:getUser()
end

--- Get message-content
--- @return string
function Message:getContent()
    return self._data.content
end

--- Get message-embeds
--- @return table | nil
function Message:getEmbeds()
    return self._data.embeds
end

--- Get message-id
--- @return string
function Message:getId()
    return self._data.id
end

--- Pin message
--- @return boolean
function Message:pin()
    local _, _, err = self._api:pinMessage(self._channel, self:getId())
    return err
end

--- Unpin message
--- @return boolean
function Message:unpin()
    local _, _, err =  self._api:unpinMessage(self._channel, self:getId())
    return err
end

--- Reply to message
--- @param data string | table
--- @return table | boolean
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

--- Edit message
--- @param data string | table
--- @return table | boolean
function Message:edit(data)
    if type(data) == "string" then
        data = {content = data}
    end

    local _, _, err = self._api:editMessage(self._channel, self:getId(), data)
    return err
end

--- React to the message
--- @param data string | table
--- @return boolean
function Message:react(emoji)
    local _, _, err = self._api:reactMessage(self._channel, self:getId(), emoji)
    return err
end

--- Delete all reactions from message
--- @return boolean
function Message:clearReactions()
    local _, _, err = self._api:deleteAllReactions(self._channel, self:getId())
    return err
end

--- Delete all reactions
--- @param emoji table | string
--- @return boolean
function Message:deleteReactions(emoji)
    local _, _, err = self._api:deleteReactions(self._channel, self:getId(), emoji)
    return err
end

--- Get all reactions from specific emoji
--- @param emoji table | string
--- @return table | boolean
function Message:getReactions(emoji)
    local _, data, err = self._api:getReactions(self._channel, self:getId(), emoji)
    if not err then
        return err
    end

    local value = {}
    for k,v in pairs(data) do
        table.insert(value, User(v, self._client))
    end

    return value
end

--- Delete a user's reaction from the message
--- @param emoji table | string
--- @param user table | string
--- @return boolean
function Message:deleteUserReaction(user, emoji)
    local _, _, err = self._api:deleteUserReact(self._channel, self:getId(), emoji, user)
    return err
end

--- Delete the bot's reaction from the message
--- @param emoji table | string
--- @return boolean
function Message:removeReaction(emoji)
    local _, _, err = self._api:deleteReact(self._channel, self:getId(), emoji)
    return err
end

--- Delete the message
--- @param emoji table | string
--- @return boolean
function Message:delete()
    local _, _, err = self._api:deleteMessage(self._channel, self:getId())
    return err
end