Socket = class()

local encode, cord = json.encode, exports["fivecord"]

local HELLO, RECONNECT, INVALID, EVENT, HEARTBEAT_ACK, HEARTBEAT = 10, 7, 9, 0, 11, 1

function Socket:_init(token, client)
    self._token = token
    self._interval = nil
    self._session = nil
    self._reconnect = nil
    self._client = client

    function open(send, platform, reconnect)
        function self:send(...) send(...) end
        self._platform = platform
        self._reconnect = reconnect
    end

    function err(error)
        print("Gateway error "..error)
    end

    function message(msg)
        local op, d, t = msg.op, msg.d, msg.t
        local heartbeat = (d or {heartbeat_interval = nil}).heartbeat_interval
        
        if msg.s ~= nil then self._seq = msg.s
        else self._seq = nil end
        
        client._events:emit('SOCKET_MESSAGE', msg)

        if op == HELLO then
            if heartbeat then
                self._interval = heartbeat
            end

            if self._session then
                self:resume()
            end

            self:startHeartbeat()
            return self:identity()

        elseif op == RECONNECT then
            self._reconnect()

        elseif op == INVALID then
            if d and self._session then
                return self:resume()
            end

            Wait(math.random(1000, 5000))
            self:identity()

        elseif op == EVENT then
            client._events:emit(t, d)

        elseif op == HEARTBEAT_ACK then
            client._events:emit('HEARTBEAT')

        elseif op == HEARTBEAT then
            self:heartbeat()
        end
    end

    function close(err)
        if err == 4004 then
            return print("Gateway closed, bot information is invalid")
        end

        self:_reconnect()
        print("Gateway closed with error code: ".. err.. ". Now reconnecting")
    end

    cord:socket(open, err, message, close)
end

function Socket:heartbeat()
    self:send(encode({op = 1, d = self._seq or "null"}))
end

function Socket:startHeartbeat()
    CreateThread(function()
        while true do
            self:heartbeat()
            Wait(self._interval)
        end
    end)
end

function Socket:identity() -- identity payload
    self:send(encode({ ['op'] = 2, ['d'] = { ['token'] = self._token,  ['properties'] = { ['$os'] = self._platform, ['$browser'] = "fivecord", ['$device'] = "fivecord" }}}))
end

function Socket:resume() -- resume payload
    self:send(encode({ op = 6, d = { token = self._token, session_id = self._session, seq = self._seq }}))
end