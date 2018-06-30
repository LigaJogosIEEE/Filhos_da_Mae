local SpriteSheet = require "util.SpriteSheet"

function love.load()
    whale = SpriteSheet:new().loadSprite("assets/sprites/Franjostei/Franjostei_Direita.json", "assets/sprites/Franjostei/Franjostei_Direita.png")
end

function love.draw()
    love.graphics.draw(whale, 300, 200)
end
