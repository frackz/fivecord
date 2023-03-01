function Bots:New()
    local value = {}
    value.id = #Bots + 1
    value.token = nil
    value.intents = nil

    --- Set the token of the bot
    --- @param token string
    function value:setToken(token)
        if type(token) ~= "string" or token:len() < 17 or token:len() > 19 then
            return false, "token_invalid"
        end

        self.token = token
    end
    
    --- Set the intents of the bot
    --- @param intents table
    function value:setIntents(intents)
        if type(intents) ~= "table" then
            return false, "intents_invalid"
        end

        self.intents = intents
    end

    --- Run the discord bot
    function value:run()
        if self.token == nil or self.intents == nil then
            return false, "intents_or_token_not_set"
        end

        
    end

    return value
end