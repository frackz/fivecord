Client = class()

function Client:_init(token)
    self._token = token
    self._api = API(token, self)
    self._events = Event(self)

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

function Client:getChannel(channel)
    local status, data = self._api:getChannel(channel)
    if data == nil then
        return false, "invalid_channel"
    end
    return Channel(data, self)
end

function Client:on(...)
    self._events:handle(...)
end

function Client:run()
    CreateThread(function()
        local _, data = self._api:auth()
        if data == nil then
            return print("Information is incorrect.")
        end
    
        self._socket = Socket(self._token, self)
    end)
end