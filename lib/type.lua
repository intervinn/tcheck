local typeof = type
local type = {}
type.__index = type

function type.create(predicate)
    local self = setmetatable({}, type)
    self.predicate = predicate
    return self
end

function type.compare(a, b)
    if typeof(a) ~= typeof(b) then
        return
    end

    if typeof(a) == "table" then
        for k,v in pairs(a) do
            if b[k] ~= v then
                return false
            end
        end
    else
        return a == b
    end
 end

return type