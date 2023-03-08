Socket = class()

local encode, cord = json.encode, exports["fivecord2"]

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

    function err()
        print("ERROR")
    end

    function message(msg)
        local op, d = msg.op, msg.d
        local heartbeat = (d or {heartbeat_interval = nil}).heartbeat_interval
        
        if msg.s ~= nil then self._seq = msg.s
        else self._seq = nil end
        
        if op == 10 then
            if heartbeat then self._interval = heartbeat end

            CreateThread(function()
                self:startHeartbeat()
            end)

            if self._session then
                self:resume()
            else
                self:identity()
            end
        elseif op == 7 then
            print("Requested reconnecting")
            self._reconnect()
        elseif op == 9 then
            if d and self._session then
                self:resume()
            else
                Wait(math.random(1000, 5000))
                self:identity()
            end
        elseif op == 0 then
            print("Event fired "..msg["t"])
            if msg["t"] == "READY" then
                self._session = d.session_id
                client._events:emit(msg["t"], msg["d"])
            end
        elseif op == 11 then
            client._events:emit('heartbeatRecieved')
        elseif op == 1 then
            self:heartbeat()
        end
    end

    function close(err)
        self:_reconnect()
        print("Gateway closed with error code: ".. err.. ". Now reconnecting")
    end

    cord:socket(open, err, message, close)
end

function Socket:heartbeat()
    self:send(encode({op = 1, d = self._seq or "null"}))
end

function Socket:startHeartbeat()
    while true do
        self:heartbeat()
        Wait(self._interval)
    end
end

function Socket:identity()
    self:send(encode({
        ['op'] = 2,
        ['d'] = {
            ['token'] = self._token,
            ['properties'] = {
                ['$os'] = self._platform,
                ['$browser'] = "fivecord",
                ['$device'] = "fivecord"
            }
        }
    }))
end

function Socket:resume()
    self:send(encode({
        op = 6,
        d = {
            token = self._token,
            session_id = self._session,
            seq = self._seq
        }
    }))
end