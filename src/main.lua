local SpriteSheet = require "util.SpriteSheet"

function love.load()
    franjostei = SpriteSheet:new()
    franjostei.loadSprite("assets/sprites/Franjostei/Franjostei_Direita.json", "assets/sprites/Franjostei/Franjostei_Direita.png")
    franjostei.splitFrame()
    franjostei.setType("infinity")
end

function love.update(dt)
	franjostei.update(dt)
end

function love.draw()
	franjostei.draw()
end
