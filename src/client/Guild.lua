Guild = class()

function Guild:_init(data, client)
    self._data = data
    self._client = client
    self._api = client._api
end

function Guild:getName()
    return self._data.name
end

function Guild:getChannel(id)
    if not self._data.channels[id] then
        return false, "invalid_channel"
    end

    return Channel(self._data.channels[id], self._client)
end