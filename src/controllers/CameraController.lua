local CameraController = {}
CameraController.__index = CameraController

function CameraController:new()
    local this = {
        previousOrientation = true, --[[ true if right, false is left --]]
        previousPosition = {x = 0, y = 0},
        stalkerX = require "libs.STALKER-X"()
    }
    this.stalkerX.scale = 2
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
    self.stalkerX:attach(); drawFunction(); self.stalkerX:detach(); self.stalkerX:draw()
end

return CameraController
