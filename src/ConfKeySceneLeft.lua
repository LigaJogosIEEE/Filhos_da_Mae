local ConfKeySceneLeft = {}

ConfKeySceneLeft.__index = ConfKeySceneLeft

function ConfKeySceneLeft:new()
    local this = {


    }

    
    return setmetatable(this, ConfKeySceneLeft)
end

function ConfKeySceneLeft:keypressed(key, scancode, isrepeat)
    if key == "escape" then
        sceneDirector:previousScene()
    
    end

    gameDirector:getMainCharacter():configKey_left(key)
    sceneDirector:previousScene()

end

function ConfKeySceneLeft:draw()

    
    love.graphics.print("Pressione uma tecla.", 10, 200)
    
   

end


function ConfKeySceneLeft:keyreleased(key, scancode)
    gameDirector:getMainCharacter():keyreleased(key, scancode)
end

function ConfKeySceneLeft:reset()
    gameDirector:reset()
   
end





return ConfKeySceneLeft
