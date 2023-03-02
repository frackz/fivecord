CreateThread(function()
    local bot = exports['fivecord']:new()

    bot:setToken('MTA3NjU2MDM4MjkxMjYzNDkzMA.GchNNh.ucL3A3LH_16vAJub6XqFDsvaqjizU1jVN6U_wc')

    bot:on('ready', function()
        print("Logged in as "..bot:getName().."#"..bot:getTag())
    end)

    bot:run()
end)