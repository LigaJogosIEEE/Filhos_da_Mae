local CameraController = {}
CameraController.__index = CameraController

function CameraController:new()
    local this = {
        previousOrientation = true, --[[ true if right, false is left --]]
        originalPosition = {mainCharacter = {0, 0}}
    }

    return setmetatable(this, CameraController)
end

function CameraController:isOnCenter(xPosition, yPosition)
    local dimensions = {x = love.graphics.getWidth() / 2, y = love.graphics.getHeight() / 2}
    local x = previousOrientation and xPosition >= dimensions.x or not previousOrientation and dimensions.x >= xPosition
    local y = yPosition >= dimensions.y
    return x, y
end

function CameraController:update(dt)
    local orientation = gameDirector:getMainCharacter():getOrientation() == "right"
    local follow = false
    if orientation and self.previousOrientation then
        if self:isOnCenter(gameDirector:getMainCharacter():getPosition()) then
            follow = true
        end
    end
end

function CameraController:draw()
end

return CameraController
