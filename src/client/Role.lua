Role = class()

function Role:_init(data, client, guild)
    self._data = data
    self._client = client
    self._guild = guild

    self._api = client._api
end


-- Get
function Role:getName()
    return self._data.name
end

function Role:getPosition()
    return self._data.position
end

function Role:getMentionable()
    return self._data.mentionable
end

function Role:getColor()
    return self._data.color
end