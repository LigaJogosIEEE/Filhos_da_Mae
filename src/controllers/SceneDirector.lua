local MainMenuScene = require "scenes.MainMenuScene"
local ConfigurationScene = require "scenes.ConfigurationScene"

local SceneDirector = {}

SceneDirector.__index = SceneDirector

function SceneDirector:new()
    local this = {
        currentScene = nil, 
        mainMenu = MainMenuScene:new(),
        configurationScene = ConfigurationScene:new(),
        sceneObjects = {}
    }

    this.currentScene = this.mainMenu
    this.sceneObjects["mainMenu"] = this.mainMenu
    this.sceneObjects["inGame"] = gameDirector
    this.sceneObjects["configurations"] = this.configurationScene

    scaleDimension:setGameScreenScale(800, 600)
    love.graphics.setNewFont("assets/fonts/kirbyss.ttf", 18)
    return setmetatable(this, SceneDirector)
end

function SceneDirector:switchScene(scene)
    assert(self.sceneObjects[scene], "Unable to find required scene: '" .. tostring(scene) .. "'")
    self.currentScene = self.sceneObjects[scene] or self.currentScene
end

function SceneDirector:keypressed(key, scancode, isrepeat)
    if self.currentScene.keypressed then
        self.currentScene:keypressed(key, scancode, isrepeat)
    end
end

function SceneDirector:keyreleased(key, scancode)
    if self.currentScene.keyreleased then
        self.currentScene:keyreleased(key, scancode)
    end
end

function SceneDirector:mousemoved(x, y, dx, dy, istouch)
    if self.currentScene.mousemoved then
        self.currentScene:mousemoved(x, y, dx, dy, istouch)
    end
end

function SceneDirector:mousepressed(x, y, button)
    if self.currentScene.mousepressed then
        self.currentScene:mousepressed(x, y, button)
    end
end

function SceneDirector:mousereleased(x, y, button)
    if self.currentScene.mousereleased then
        self.currentScene:mousereleased(x, y, button)
    end
end

function SceneDirector:wheelmoved(x, y)
    if self.currentScene.wheelmoved then
        self.currentScene:wheelmoved(x, y)
    end
end

function SceneDirector:update(dt)
    if self.currentScene.update then
        self.currentScene:update(dt)
    end
end

function SceneDirector:draw()
    if self.currentScene.draw then
        self.currentScene:draw()
    end
end

return SceneDirector