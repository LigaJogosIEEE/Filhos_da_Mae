local Ground = require "models.business.Ground"

local InGameScene = {}

InGameScene.__index = InGameScene

function InGameScene:new(world)
    local this = {
        ground = Ground:new(world, nil, 800, 30, 400, 570),
        level_1_map = gameDirector:getLibrary("TilemapLoader"):new("level_1_map", "assets/tilesets")
    }

    return setmetatable(this, InGameScene)
end

function InGameScene:keypressed(key, scancode, isrepeat)
    if key == "escape" then
        sceneDirector:switchSubscene("pause")
    end
    gameDirector:getMainCharacter():keypressed(key, scancode, isrepeat)
end

function InGameScene:keyreleased(key, scancode)
    gameDirector:getMainCharacter():keyreleased(key, scancode)
end

function InGameScene:reset()
    gameDirector:reset()
end

function InGameScene:update(dt)
    gameDirector:update(dt)
end

function InGameScene:draw()
    local mainCharacter, characterController = gameDirector:getMainCharacter()
    gameDirector:getLifeBar():draw()
    love.graphics.printf(string.format("Money: %d", characterController:getMoney()), 20, 60, 100, 'center')
    gameDirector:getCameraController():draw(function()
        mainCharacter:draw()
        gameDirector:getEnemiesController():draw()
        self.ground:draw()
        gameDirector:drawBullets()
    end)
end

return InGameScene