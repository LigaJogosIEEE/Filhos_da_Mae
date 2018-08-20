local CameraController = {}
CameraController.__index = CameraController

function CameraController:new()
    local this = {
        previousOrientation = true, --[[ true if right, false is left --]]
        previousPosition = {x = 0, y = 0},
        gamera = require "libs.gamera".new(0, 0, 2000, 2000)
    }
    this.gamera:setScale(2)
    this.gamera:setPosition(0, 570)
    return setmetatable(this, CameraController)
end

function CameraController:isOnCenter(xPosition, yPosition)
    local dimensions = {x = love.graphics.getWidth() / 2, y = love.graphics.getHeight() / 2}
    local x = self.previousOrientation and xPosition >= dimensions.x or not self.previousOrientation and dimensions.x >= xPosition
    local y = yPosition >= dimensions.y
    return x, y
end

function CameraController:update(dt)
    local inGround = gameDirector:getMainCharacter().inGround
    local x, y = gameDirector:getMainCharacter():getPosition()
    self.gamera:setPosition(x, inGround and y or self.previousPosition.y)
    if inGround then
        self.previousPosition.x, self.previousPosition.y = x, y
    end
end

function CameraController:draw(drawFunction)
    self.gamera:draw(drawFunction)
end

return CameraController
