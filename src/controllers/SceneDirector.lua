local MainMenuScene = require "scenes.MainMenuScene"
local ConfigurationScene = require "scenes.ConfigurationScene"

local SceneDirector = {}

SceneDirector.__index = SceneDirector

function SceneDirector:new()
    local this = {
        currentScene = "mainMenu", 
        mainMenu = MainMenuScene:new(),
        configurationScene = ConfigurationScene:new(),
        sceneObjects = {}
    }

    this.sceneObjects["mainMenu"] = this.mainMenu
    this.sceneObjects["inGame"] = gameDirector
    this.sceneObjects["configurations"] = this.configurationScene

    scaleDimension:setGameScreenScale(800, 600)
    love.graphics.setNewFont("assets/fonts/kirbyss.ttf", 18)
    return setmetatable(this, SceneDirector)
end

function SceneDirector:setCurrentScene(newScene)
    self.currentScene = newScene
end

function SceneDirector:keypressed(key, scancode, isrepeat)
    if self.sceneObjects[self.currentScene].keypressed then
        self.sceneObjects[self.currentScene]:keypressed(key, scancode, isrepeat)
    end
end

function SceneDirector:keyreleased(key, scancode)
    if self.sceneObjects[self.currentScene].keyreleased then
        self.sceneObjects[self.currentScene]:keyreleased(key, scancode)
    end
end

function SceneDirector:mousemoved(x, y, dx, dy, istouch)
    if self.sceneObjects[self.currentScene].mousemoved then
        self.sceneObjects[self.currentScene]:mousemoved(x, y, dx, dy, istouch)
    end
end

function SceneDirector:mousepressed(x, y, button)
    if self.sceneObjects[self.currentScene].mousepressed then
        self.sceneObjects[self.currentScene]:mousepressed(x, y, button)
    end
end

function SceneDirector:mousereleased(x, y, button)
    if self.sceneObjects[self.currentScene].mousereleased then
        self.sceneObjects[self.currentScene]:mousereleased(x, y, button)
    end
end

function SceneDirector:wheelmoved(x, y)
    if self.sceneObjects[self.currentScene].wheelmoved then
        self.sceneObjects[self.currentScene]:wheelmoved(x, y)
    end
end

function SceneDirector:update(dt)
    if self.sceneObjects[self.currentScene].update then
        self.sceneObjects[self.currentScene]:update(dt)
    end
end

function SceneDirector:draw()
    if self.sceneObjects[self.currentScene].draw then
        self.sceneObjects[self.currentScene]:draw()
    end
end

return SceneDirector