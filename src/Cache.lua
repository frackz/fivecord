Cache = class()

function Cache:_init()
    self._objects = {}
end

function Cache:define(name, value)
    self._objects[name] = value
end

function Cache:set(name, object, value)
    self._objects[name][object] = value
end

function Cache:delete(name)
    self._objects[name] = nil
end

function Cache:get(name)
    return self._objects[name]
end