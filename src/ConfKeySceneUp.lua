local ConfKeySceneUp = {}

ConfKeySceneUp.__index = ConfKeySceneUp

function ConfKeySceneUp:new()
    local this = {


    }

    
    return setmetatable(this, ConfKeySceneUp)
end

function ConfKeySceneUp:keypressed(key, scancode, isrepeat)
    if key == "escape" then
        sceneDirector:previousScene()
    
    end

    gameDirector:getMainCharacter():configKey_up(key)
    sceneDirector:previousScene()

end

function ConfKeySceneUp:draw()

    
    love.graphics.print("Pressione uma tecla.", 10, 200)
    
   

end


function ConfKeySceneUp:keyreleased(key, scancode)
    gameDirector:getMainCharacter():keyreleased(key, scancode)
end

function ConfKeySceneUp:reset()
    gameDirector:reset()
   
end





return ConfKeySceneUp
