local GameState = {}

GameState.__index = GameState

function GameState:new()
    local this = {
        objects = {}
    }

    return setmetatable(this, GameState)
end

function GameState:cloneObject(object, alreadyCloned, newObject)
    local newObject = newObject or {}
    for key, value in pairs(object) do
        local toSave = value
        if type(value) == "table" then
            if alreadyCloned[value] then
                toSave = alreadyCloned[value]
            else
                alreadyCloned[value] = {}
                toSave = self:cloneObject(value, alreadyCloned, alreadyCloned[value])
            end
        end
        newObject[key] = toSave
    end
    return setmetatable(newObject, getmetatable(object))
end

function GameState:save(object, objectName)
    assert(type(object) == "table", "Object needs to be a table")
    assert(objectName, "Object Name required to save")
    self.objects[objectName] = self:cloneObject(object, {})
end

function GameState:load(objectName)
    local object = self.objects[objectName]
    if object then
        return self:cloneObject(object, {})
    end
    return nil
end

return GameState
