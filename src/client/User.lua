User = class()

function User:_init(data, client)
    self._data = data
    self._client = client

    self._api = client._api
    self._isMember = self._data.user ~= nil
end


-- Get
function User:getName()
    return self._data.username or self._data.user.username
end

function User:getTag()
    return self._data.discriminator or self._data.user.discriminator
end

function User:getId()
    return self._data.id or self._data.user.id
end

function User:getAvatar()
    return self._data.avatar or self._data.user.avatar
end
