local bot = exports['fivecord']:new()

bot:setToken('MTA3NjU2MDM4MjkxMjYzNDkzMA.G2ECPh.U1BYVwbSCNWsUSSc26rgnb6bLisuDYWfGy2Xqc')

bot:on('ready', function()
    print("READY")
end)

bot:run()