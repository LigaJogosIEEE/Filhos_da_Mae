local ConfKeySceneDown = {}

ConfKeySceneDown.__index = ConfKeySceneDown

function ConfKeySceneDown:new()
    local this = {


    }

    
    return setmetatable(this, ConfKeySceneDown)
end

function ConfKeySceneDown:keypressed(key, scancode, isrepeat)
    if key == "escape" then
        sceneDirector:previousScene()
    
    end

    gameDirector:getMainCharacter():configKey_down(key)
    sceneDirector:previousScene()

end

function ConfKeySceneDown:draw()

    
    love.graphics.print("Pressione uma tecla.", 10, 200)
    
   

end


function ConfKeySceneDown:keyreleased(key, scancode)
    gameDirector:getMainCharacter():keyreleased(key, scancode)
end

function ConfKeySceneDown:reset()
    gameDirector:reset()
   
end





return ConfKeySceneDown
