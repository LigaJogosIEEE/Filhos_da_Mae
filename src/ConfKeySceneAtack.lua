local ConfKeySceneAtack = {}

ConfKeySceneAtack.__index = ConfKeySceneAtack
function ConfKeySceneAtack:new()
    local this = {


    }

    
    return setmetatable(this, ConfKeySceneAtack)
end

function ConfKeySceneAtack:keypressed(key, scancode, isrepeat)
    if key == "escape" then
        sceneDirector:previousScene()
    
    end

    gameDirector:getMainCharacter():configKey_atack(key)
    sceneDirector:previousScene()

end

function ConfKeySceneAtack:draw()

    
    love.graphics.print("Pressione uma tecla.", 10, 200)
    
   

end


function ConfKeySceneAtack:keyreleased(key, scancode)
    gameDirector:getMainCharacter():keyreleased(key, scancode)
end

function ConfKeySceneAtack:reset()
    gameDirector:reset()
   
end





return ConfKeySceneAtack
