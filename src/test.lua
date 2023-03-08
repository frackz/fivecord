local api = Client('MTA3NjU2MDM4MjkxMjYzNDkzMA.GXWDT2.1FLN-9vy5OH9QaNenLeJQggSo3SrJrnXRDPm5k')

CreateThread(function()
    api:on('ready', function ()
        print("REQADY?api?")
    end)

    api:on('heartbeatRecieved', function(asd)
        print("Vi fik et heartbeat ")
    end)
end)