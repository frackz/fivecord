Client = class()

function Client:_init(token)
    self._token = token
    self._api = API(token, self)
    self._socket = Socket(token, self)
    self._events = Event()
end

function Client:setToken(token)
    if type(token) ~= "string" then
        return false, "token_invalid"
    end

    self._token = token
end

function Client:on(...) self._events:handle(...) end

function Client:run()

end