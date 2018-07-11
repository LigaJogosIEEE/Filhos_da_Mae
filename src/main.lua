local GameDirector = require "controllers.GameDirector"

function love.load()
    love.window.setTitle("Filhos da Mãe")
    gameDirector = GameDirector:new()
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        love.event.quit()
    end
    gameDirector:keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key, scancode)
    gameDirector:keyreleased(key, scancode)
end

function love.update(dt)
    gameDirector:update(dt)
end

function love.draw()
    gameDirector:draw()
end
