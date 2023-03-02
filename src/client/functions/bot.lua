addSetup(function(value)
    value.data = nil
    local info = value.data

    value:on('ready', function(data)
        info = data
    end)

    function value:getName()
        return info.user.username
    end

    function value:getId()
        return info.user.id
    end

    function value:getTag()
        return info.user.discriminator
    end

    function value:getAvatar()
        return 'https://cdn.discordapp.com/avatars/'..value:getId()..'/'..info.user.avatar..'.png'
    end
end)