User = class()

function User:_init(data, client)
    self._data = data
    self._client = client

    self._api = client._api
    self._isMember = self._data.user ~= nil
end

--- Get the user's name
--- @return string | nil
function User:getName()
    return self._data.username or self._data.user.username
end

--- Get the user's tag
--- @return number | nil
function User:getTag()
    return self._data.discriminator or self._data.user.discriminator
end

--- Get the user's id
--- @return string | nil
function User:getId()
    return self._data.id or self._data.user.id
end

--- Get the user's avatar
--- @return string | nil
function User:getAvatar()
    return self._data.avatar or self._data.user.avatar
end