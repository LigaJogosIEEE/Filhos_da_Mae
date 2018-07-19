local ButtonManager = require "util/GUI/ButtonManager"

local MainMenuScene = {}

MainMenuScene.__index = MainMenuScene

function MainMenuScene:new()
    local this = {
        background = love.graphics.newImage("assets/background.png"),
        logo = love.graphics.newImage("assets/menuLogo.png"),
        buttons = ButtonManager:new(),
        actualScene = "MainMenu"
    }
    --buttonName, x, y, width, height, image, originalImage, animation, 70
    local button = this.buttons:addButton('Start Game', 350, 320, 128, 60, love.graphics.newImage("assets/gui/start_button_normal.png"))
    button:setButtonImage(love.graphics.newImage("assets/gui/start_button_hover.png"), "hover")
    button:setButtonImage(love.graphics.newImage("assets/gui/start_button_pressed.png"), "pressed")
    button.callback = function(this, x, y)
        sceneDirector:setCurrentScene("inGame")
    end
    
    button = this.buttons:addButton('Configurations', 350, 390, 128, 60, love.graphics.newImage("assets/gui/start_button_normal.png"))
    button:setButtonImage(love.graphics.newImage("assets/gui/start_button_hover.png"), "hover")
    button:setButtonImage(love.graphics.newImage("assets/gui/start_button_pressed.png"), "pressed")
    button.callback = function(this, x, y)
        sceneDirector:setCurrentScene("configuration")
    end

    return setmetatable(this, MainMenuScene)
end

function MainMenuScene:keypressed(key, scancode, isrepeat)
    self.buttons:keypressed(key, scancode, isrepeat)
end

function MainMenuScene:keyreleased(key, scancode)
    self.buttons:keyreleased(key, scancode)
end

function MainMenuScene:mousemoved(x, y, dx, dy, istouch)
    self.buttons:mousemoved(x, y, dx, dy, istouch)
end

function MainMenuScene:mousepressed(x, y, button)
    self.buttons:mousepressed(x, y, button)
end

function MainMenuScene:mousereleased(x, y, button)
    self.buttons:mousereleased(x, y, button)
end

function MainMenuScene:wheelmoved(x, y)
end

function MainMenuScene:update(dt)
    self.buttons:update(dt)
end

function MainMenuScene:draw()
    love.graphics.draw(self.background)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 250, 50, 320, 150)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.logo, 250, 50, 0, 0.2)
    self.buttons:draw()
end

return MainMenuScene
