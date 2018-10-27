local ConfKeySceneRight = {}

ConfKeySceneRight.__index = ConfKeySceneRight

function ConfKeySceneRight:new()
    local this = {


    }

    
    return setmetatable(this, ConfKeySceneRight)
end

function ConfKeySceneRight:keypressed(key, scancode, isrepeat)
    if key == "escape" then
        sceneDirector:previousScene()
    
    end

    gameDirector:getMainCharacter():configKey_right(key)
    sceneDirector:previousScene()

end

function ConfKeySceneRight:draw()

    
    love.graphics.print("Pressione uma tecla.", 10, 200)
    
   

end


function ConfKeySceneRight:keyreleased(key, scancode)
    gameDirector:getMainCharacter():keyreleased(key, scancode)
end

function ConfKeySceneRight:reset()
    gameDirector:reset()
   
end





return ConfKeySceneRight
