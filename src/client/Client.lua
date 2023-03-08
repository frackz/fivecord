Client = class()

function Client:_init(token)
    self._token = token
    self._api = API(token, self)
    self._socket = Socket(token, self)
    self._events = Event()

    self._events:handle('ready', function(data)
        self.bot = User(data.user)
        self._socket.session = data.session_id
    end)
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