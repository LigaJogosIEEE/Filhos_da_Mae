local InGameScene = {}

InGameScene.__index = InGameScene

function InGameScene:new(world)
    local this = {
        level_1_map = gameDirector:getLibrary("LevelLoader"):new("assets/tilesets", world):load("level_1_map"),
        liveImage = love.graphics.newImage("assets/elements/health.png")
    }

    sceneDirector:addSubscene("pause", require "scenes.subscenes.PauseGame":new())
    return setmetatable(this, InGameScene)
end

function InGameScene:keypressed(key, scancode, isrepeat)
    if key == "escape" then
        sceneDirector:switchSubscene("pause")
    end
    gameDirector:getPlayer():keypressed(key, scancode, isrepeat)
end

function InGameScene:keyreleased(key, scancode)
    gameDirector:getPlayer():keyreleased(key, scancode)
end

function InGameScene:reset()
    gameDirector:reset()
    gameDirector.enemiesController:clearEnemies()
end

function InGameScene:update(dt)
    gameDirector:update(dt); self.level_1_map:update(dt)
end

function InGameScene:draw()
    local playerController = gameDirector:getPlayer()
    gameDirector:getCameraController():draw(function()
        self.level_1_map:draw(); playerController:draw()
        gameDirector:getEnemiesController():draw(); gameDirector:drawBullets()
    end)
    gameDirector:getLifeBar():draw()
    for counter = 1, playerController:getLives() do
        love.graphics.draw(self.liveImage, 20 * counter - 1, 80)
    end
    love.graphics.printf(string.format("Money: %d", playerController:getMoney()), 20, 60, 100, 'center')
end

return InGameScene
