local bot = exports['fivecord']:new()

bot:setToken('MTA3NjU2MDM4MjkxMjYzNDkzMA.GMjHEf.tsb3G2ATG2zXmCp8PVkuZGBSVVjqS0B6gipu6U')

bot:on('ready', function()
    print("READY")
end)

bot:run()