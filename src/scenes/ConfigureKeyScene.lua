local ConfigureKeyScene = {}

ConfigureKeyScene.__index = ConfigureKeyScene

function ConfigureKeyScene:new()
    local this = {
        message = nil
    }

    return setmetatable(this, ConfigureKeyScene)
end

function ConfigureKeyScene:keypressed(key, scancode, isrepeat)
    if key == "escape" then
        sceneDirector:previousScene()
    end

    gameDirector:getMainCharacter():configureKeys(self.message, key)
    sceneDirector:previousScene()
end

function ConfigureKeyScene:draw()
    love.graphics.print("Pressione uma tecla.", 10, 200)
end

function ConfigureKeyScene:keyreleased(key, scancode)
    gameDirector:getMainCharacter():keyreleased(key, scancode)
end

function ConfigureKeyScene:reset()
    gameDirector:reset()
end

return ConfigureKeyScene
