local typeof = type
local type = require("lib.type")

local tc = {}
tc.__index = tc

function tc.any()
    return type.create(function(val)
        return val ~= nil
    end)
end

function tc.null(value)
    return function (val)
        return val == nil
    end
end

function tc.boolean(value)
    if value then
        return type.create(function(val)
            return val == value
        end)
    end

    return type.create(function(val)
        return typeof(val) == "boolean"
    end)
end

function tc.string(value)
    if value then
        return type.create(function(val)
            return val == value
        end)
    end

    return type.create(function(val)
        return typeof(val) == "string"
    end)
end

function tc.number(value)
    if value then
        return type.create(function(val)
            return val == value
        end)
    end

    return type.create(function(val)
        return typeof(val) == "number"
    end)
end

function tc.table()
    return type.create(function(val)
        return typeof(val) == "table"
    end)
end

function tc.match(type, value)
    return type.predicate(value)
end

function tc.object(schema)
    return type.create(function(val)
        for k,v in pairs(schema) do
            if not val[k] or not tc.match(schema[k], val[k]) then
                return false
            end
        end
        return true
    end)
end

function tc.func(...)
    local self = {}
    self.params = {...}
    self.impl = function(fn)
        self.fn = fn
        return self
    end
    self.wrap = function()
        return function(...)
            local args = {...}
            for i,v in pairs(args) do
                if not tc.match(self.params[i], v) then
                    error("type mismatch: types "
                    ..typeof(self.params[i].." and "..typeof(v)))
                end
            end
            if not self.fn then
                error("implementation not given")
            end
            self.fn(...)
        end
    end
    return self
end

function tc.either(...)
    local values = {...}
    return type.create(function(val)
        for _,v in pairs(values) do
            if tc.match(v, val) then
                return true
            end
        end
        return false
    end)
end

function tc.union(...)
    local values = {...}
    return type.create(function(val)
        for _,v in pairs(values) do
            if not tc.match(v, val) then
                return false
            end
        end
        return true
    end)
end

return tc