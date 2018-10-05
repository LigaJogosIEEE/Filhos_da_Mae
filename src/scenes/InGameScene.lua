local InGameScene = {}

InGameScene.__index = InGameScene

function InGameScene:new(world)
    local this = {
        level_1_map = gameDirector:getLibrary("LevelLoader"):new("level_1_map", "assets/tilesets", world)
    }

    sceneDirector:addSubscene("pause", require "scenes.subscenes.PauseGame":new())
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
    gameDirector.enemiesController:clearEnemies()
    gameDirector.enemiesController:createEnemy("Bill", 600, 500)
end

function InGameScene:update(dt)
    gameDirector:update(dt)
    self.level_1_map:update(dt)
end

function InGameScene:draw()
    local mainCharacter, characterController = gameDirector:getMainCharacter()
    gameDirector:getLifeBar():draw()
    love.graphics.printf(string.format("Money: %d", characterController:getMoney()), 20, 60, 100, 'center')
    gameDirector:getCameraController():draw(function()
        self.level_1_map:draw()
        mainCharacter:draw()
        gameDirector:getEnemiesController():draw()
        gameDirector:drawBullets()
    end)
end

return InGameScene
