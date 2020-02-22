local CameraController = {}
CameraController.__index = CameraController

function CameraController:new()
    local width, height = scaleDimension.gameScreenScale.width, scaleDimension.gameScreenScale.height
    local this = {
        previousOrientation = true, --[[ true if right, false is left --]]
        previousPosition = {x = 0, y = 0},
        stalkerX = require "libs.STALKER-X"(width / 2, height / 2, width, height, 2)
    }
    this.stalkerX:setFollowStyle('PLATFORMER'); this.stalkerX:setFollowLerp(0.1); this.stalkerX:setFollowLead(5)
    return setmetatable(this, CameraController)
end

function CameraController:shake()
    self.stalkerX:shake(4, 0.2, 60)
end

function CameraController:getPosition()
    return self.stalkerX.x, self.stalkerX.y
end

function CameraController:update(dt)
    local inGround = gameDirector:getPlayer():isInGround()
    local x, y = gameDirector:getPlayer():getBody():getPosition()
    if y > 1048 then y = 1048 end
    self.stalkerX:follow(x < 10400 and x or 10400, y)--(inGround and y or self.previousPosition.y) - 300)
    self.stalkerX:update(dt)
    if inGround then
        self.previousPosition.x, self.previousPosition.y = x, y
    end
end

function CameraController:draw(drawFunction)
    local camera = self.stalkerX
    local x = math.floor(camera.x * camera.scale + 0.5) / camera.scale
    local y = math.floor(camera.y * camera.scale + 0.5) / camera.scale
    camera:attach()
    love.graphics.translate(camera.x - x, camera.y - y)
    drawFunction(); camera:detach(); camera:draw()
end

return CameraController
