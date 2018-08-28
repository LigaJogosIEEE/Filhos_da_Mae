local ConfigurationScene = {}

ConfigurationScene.__index = ConfigurationScene

function ConfigurationScene:new()
    local this = {
        
    }
    
    return setmetatable(this, ConfigurationScene)
end

function ConfigurationScene:keypressed(key, scancode, isrepeat)
    if key == "escape" then
        sceneDirector:previousScene()
    end
end

function ConfigurationScene:keyreleased(key, scancode)
end

function ConfigurationScene:mousemoved(x, y, dx, dy, istouch)
end

function ConfigurationScene:mousepressed(x, y, button)
end

function ConfigurationScene:mousereleased(x, y, button)
end

function ConfigurationScene:wheelmoved(x, y)
end

function ConfigurationScene:update(dt)
end

function ConfigurationScene:draw()
end

function ConfigurationScene:resize(w, h)
end

return ConfigurationScene
