local CameraController = {}
CameraController.__index = CameraController

function CameraController:new()
    local this = {
        previousOrientation = true, --[[ true if right, false is left --]]
        previousPosition = {x = 0, y = 0},
        gamera = require "libs.gamera".new(0, 0, 172 * 64, 17 * 64)
    }
    this.gamera:setScale(1); this.gamera:setPosition(0, 0)
    return setmetatable(this, CameraController)
end

function CameraController:isOnCenter(xPosition, yPosition)
    local dimensions = {x = love.graphics.getWidth() / 2, y = love.graphics.getHeight() / 2}
    local x = self.previousOrientation and xPosition >= dimensions.x or not self.previousOrientation and dimensions.x >= xPosition
    local y = yPosition >= dimensions.y
    return x, y
end

function CameraController:update(dt)
    local inGround = gameDirector:getPlayer():isInGround()
    local x, y = gameDirector:getPlayer():getBody():getPosition()
    self.gamera:setPosition(x, 1000)--(inGround and y or self.previousPosition.y) - 300)
    if inGround then
        self.previousPosition.x, self.previousPosition.y = x, y
    end
end

function CameraController:draw(drawFunction)
    self.gamera:draw(drawFunction)
end

return CameraController
