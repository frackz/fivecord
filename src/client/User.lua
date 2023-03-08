User = class()

function User:_init(data)
    self._data = data
end

function User:getName()
    return self._data.username
end

function User:getTag()
    return self._data.discriminator
end

function User:getId()
    return self._data.id
end

function User:getAvatar()
    return self._data.avatar
end
