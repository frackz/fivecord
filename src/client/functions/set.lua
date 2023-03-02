addSetup(function(value)
    function value:setToken(token)
        if type(token) ~= "string" then
            return false, "token_invalid"
        end

        value.token = token
    end
    
    function value:setIntents(intents)
        if type(intents) ~= "table" then
            return false, "intents_invalid"
        end

        value.intents = intents
    end
end)