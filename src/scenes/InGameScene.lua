local Ground = require "models.business.Ground"

local InGameScene = {}

InGameScene.__index = InGameScene

function InGameScene:new(world)
    local this = {
        ground = Ground:new(world, nil, 800, 30, 400, 570)
    }

    return setmetatable(this, InGameScene)
end

function InGameScene:update(dt)
    gameDirector:getMainCharacter():update(dt)
    gameDirector:getCameraController():update(dt)
    gameDirector:getEnemiesController():update(dt)
end

function InGameScene:draw()
    gameDirector:getMainCharacter():draw()
    gameDirector:getEnemiesController():draw()
    self.ground:draw()
end

return InGameScene