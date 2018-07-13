local MainMenuScene = require "scenes.MainMenuScene"

local GameDirector = require "controllers.GameDirector"

function love.load()
    love.window.setTitle("Filhos da Mãe")
    gameDirector = GameDirector:new()
    gameDirector.enemiesController:createEnemies()
    mainMenu = MainMenuScene:new()
    currentScene = "mainMenu"
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        love.event.quit()
    end
    if currentScene == "mainMenu" then
        mainMenu:keypressed(key, scancode, isrepeat)
    else
        gameDirector:keypressed(key, scancode, isrepeat)
    end
end

function love.keyreleased(key, scancode)
    if currentScene == "mainMenu" then
        mainMenu:keyreleased(key, scancode)
    else
        gameDirector:keyreleased(key, scancode)
    end
end

function love.mousepressed(x, y, button)
    mainMenu:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    mainMenu:mousereleased(x, y, button)
end

function love.wheelmoved(x, y)
    mainMenu:wheelmoved(x, y)
end

function love.update(dt)
    if currentScene == "mainMenu" then
        mainMenu:update(dt)
    else
        gameDirector:update(dt)
    end
end

function love.draw()
    if currentScene == "mainMenu" then
        mainMenu:draw()
    else
        gameDirector:draw()
    end
end
