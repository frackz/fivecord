local Class = {}

function Class:_init(...) end

function Class:extend(obj)
	local obj = obj or {}

	local function copyTable(table, destination)
		local table = table or {}
		local result = destination or {}

		for k, v in pairs(table) do
			if not result[k] then
				if type(v) == "table" then result[k] = copyTable(v)
                else result[k] = v end
			end
		end

		return result
	end

	copyTable(self, obj)
	obj._ = obj._ or {}

	local mt = {}
    mt.__call = function(self, ...)
		return self:new(...)
	end

	setmetatable(obj, mt)
	return obj
end

function Class:new(...)
	local obj = self:extend({})
	if obj._init then obj:_init(...) end
	return obj
end

function class(attr)
	attr = attr or {}
	return Class:extend(attr)
end
