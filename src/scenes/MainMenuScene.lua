local MainMenuScene = {}

MainMenuScene.__index = MainMenuScene

function MainMenuScene:new()
    local this = {
        background = love.graphics.newImage("assets/background.png"),
        logo = love.graphics.newImage("assets/menuLogo.png"),
        buttonManager = nil
    }
    
    return setmetatable(this, MainMenuScene)
end

function MainMenuScene:update(dt)
    
end

function MainMenuScene:draw()
    love.graphics.draw(self.background)
    love.graphics.draw(self.logo, 200, 0, 0, 0.2)
end

return MainMenuScene
