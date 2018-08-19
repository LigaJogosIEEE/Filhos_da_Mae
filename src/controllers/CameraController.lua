local CameraController = {}
CameraController.__index = CameraController

function CameraController:new()
    local this = {
        previousOrientation = true, --[[ true if right, false is left --]]
        originalPosition = {mainCharacter = {0, 0}},
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
    --[[local orientation = gameDirector:getMainCharacter():getOrientation() == "right"
    local follow = false
    if orientation and self.previousOrientation then
        if self:isOnCenter(gameDirector:getMainCharacter():getPosition()) then
            follow = true
        end
    end
    if follow then
        self.gamera:setPosition(gameDirector:getMainCharacter():getPosition())
    end--]]
    self.gamera:setPosition(gameDirector:getMainCharacter():getPosition())
end

function CameraController:draw(drawFunction)
    self.gamera:draw(drawFunction)
end

return CameraController
