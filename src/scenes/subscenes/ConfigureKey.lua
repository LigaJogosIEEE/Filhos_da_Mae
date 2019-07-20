local ConfigureKey = {}; ConfigureKey.__index = ConfigureKey

function ConfigureKey:new()
    local this = {
        args = nil
    }

    return setmetatable(this, ConfigureKey)
end

function ConfigureKey:keypressed(key, scancode, isrepeat)
    if key == "escape" then
        sceneDirector:exitSubscene()
    end

    gameDirector:getPlayer():configureKeys(self.args, key)
    sceneDirector:exitSubscene()
end

function ConfigureKey:draw()
    love.graphics.print("Pressione uma tecla.", 10, 200)
end

function ConfigureKey:keyreleased(key, scancode)
    gameDirector:getPlayer():keyreleased(key, scancode)
end

function ConfigureKey:reset()
    gameDirector:reset()
end

return ConfigureKey
