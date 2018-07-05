local GameDirector = require "controllers.GameDirector"

function love.keypressed(key, isrepeat)
    if key == "escape" then
        love.event.quit()
    end
end

function love.load()
    love.window.setTitle("Filhos da Mãe")
    gameDirector = GameDirector:new()
end

function love.update(dt)
    gameDirector:update(dt)
end

function love.draw()
    gameDirector:draw()
end
