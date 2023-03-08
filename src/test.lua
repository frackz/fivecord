local api = Client('MTA3NjU2MDM4MjkxMjYzNDkzMA.GXWDT2.1FLN-9vy5OH9QaNenLeJQggSo3SrJrnXRDPm5k')

CreateThread(function()
    api:on('ready', function ()
        print("Bot is now ready "..api.bot:getName().."#"..api.bot:getTag())
    end)

    api:on('heartbeatRecieved', function()
        print("A heartbeat was recieved.")
    end)
end)