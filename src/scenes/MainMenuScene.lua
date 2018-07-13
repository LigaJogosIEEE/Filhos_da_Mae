local MainMenuScene = {}

MainMenuScene.__index = MainMenuScene

function MainMenuScene:new()
    local this = {
        background = love.graphics.newImage("assets/background.png"),
        logo = love.graphics.newImage("assets/menuLogo.png"),
        Gspot = require "libs.Gspot",
        actualScene = "MainMenu",
        options = {"Start Game", "Configurations", "Credits"},
        currentOption = 1
    }
    
    local button = this.Gspot:button('Start Game', {x = 350, y = 320, w = 128, h = 60})
    button.click = function(this, x, y)
        currentScene = "startGame"
    end
    
    button = this.Gspot:button('Configuration', {x = 350, y = 390, w = 128, h = 60})
    button.click = function(this, x, y)
        currentScene = "configurationMenu"
    end
    
    button = this.Gspot:button('Credits', {x = 350, y = 460, w = 128, h = 60})
    button.click = function(this, x, y)
        currentScene = "credits"
    end
    
    return setmetatable(this, MainMenuScene)
end

function MainMenuScene:keypressed(key, scancode, isrepeat)
    if key == "down" and self.currentOption < #self.options then
        self.currentOption = self.currentOption + 1
    elseif key == "up" and self.currentOption > 1 then
        self.currentOption = self.currentOption - 1
    end
end

function MainMenuScene:keyreleased(key, scancode)
end

function MainMenuScene:mousepressed(x, y, button)
    self.Gspot:mousepress(x, y, button)
end

function MainMenuScene:mousereleased(x, y, button)
    self.Gspot:mouserelease(x, y, button)
end

function MainMenuScene:wheelmoved(x, y)
    self.Gspot:mousewheel(x, y)
end

function MainMenuScene:update(dt)
    self.Gspot:update(dt)
end

function MainMenuScene:draw()
    love.graphics.draw(self.background)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 250, 50, 320, 150)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.logo, 250, 50, 0, 0.2)
    self.Gspot:draw()
end

return MainMenuScene
