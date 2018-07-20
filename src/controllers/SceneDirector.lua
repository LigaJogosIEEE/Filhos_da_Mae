local MainMenuScene = require "scenes.MainMenuScene"

local SceneDirector = {}

SceneDirector.__index = SceneDirector

function SceneDirector:new()
    local this = {
        currentScene = "mainMenu", 
        mainMenu = MainMenuScene:new()
    }
    scaleDimension:setGameScreenScale(800, 600)
    love.graphics.setNewFont("assets/fonts/kirbyss.ttf", 18)
    return setmetatable(this, SceneDirector)
end

function SceneDirector:setCurrentScene(newScene)
    self.currentScene = newScene
end

function SceneDirector:keypressed(key, scancode, isrepeat)
    if self.currentScene == "mainMenu" then
        self.mainMenu:keypressed(key, scancode, isrepeat)
    elseif self.currentScene == "inGame" then
        gameDirector:keypressed(key, scancode, isrepeat)
    end
end

function SceneDirector:keyreleased(key, scancode)
    if self.currentScene == "mainMenu" then
        self.mainMenu:keyreleased(key, scancode)
    elseif self.currentScene == "inGame" then
        gameDirector:keyreleased(key, scancode)
    end
end

function SceneDirector:mousemoved(x, y, dx, dy, istouch)
    if self.currentScene == "mainMenu" then
        self.mainMenu:mousemoved(x, y, dx, dy, istouch)
    end
end

function SceneDirector:mousepressed(x, y, button)
    if self.currentScene == "mainMenu" then
        self.mainMenu:mousepressed(x, y, button)
    end
end

function SceneDirector:mousereleased(x, y, button)
    if self.currentScene == "mainMenu" then
        self.mainMenu:mousereleased(x, y, button)
    end
end

function SceneDirector:wheelmoved(x, y)
    if self.currentScene == "mainMenu" then
        self.mainMenu:wheelmoved(x, y)
    end
end

function SceneDirector:update(dt)
    if self.currentScene == "mainMenu" then
        self.mainMenu:update(dt)
    elseif self.currentScene == "inGame" then
        gameDirector:update(dt)
    end
end

function SceneDirector:draw()
    if self.currentScene == "mainMenu" then
        self.mainMenu:draw()
    elseif self.currentScene == "inGame" then
        gameDirector:draw()
    end
end

return SceneDirector