Role = class()

function Role:_init(data, client, guild)
    self._data = data
    self._client = client
    self._guild = guild

    self._api = client._api
end


--- Get the role's name
--- @return string | nil
function Role:getName()
    return self._data.name
end

--- Get the role's position
--- @return number | nil
function Role:getPosition()
    return self._data.position
end

--- Is the role mentionable?
--- @return boolean | nil
function Role:getMentionable()
    return self._data.mentionable
end

--- Get the role's color
function Role:getColor()
    return self._data.color
end