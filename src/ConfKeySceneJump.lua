local ConfKeySceneJump = {}

ConfKeySceneJump.__index = ConfKeySceneJump

function ConfKeySceneJump:new()
    local this = {


    }

    
    return setmetatable(this, ConfKeySceneJump)
end

function ConfKeySceneJump:keypressed(key, scancode, isrepeat)
    if key == "escape" then
        sceneDirector:previousScene()
    
    end

    gameDirector:getMainCharacter():configKey_jump(key)
    sceneDirector:previousScene()

end

function ConfKeySceneJump:draw()

    
    love.graphics.print("Pressione uma tecla.", 10, 200)
    
   

end


function ConfKeySceneJump:keyreleased(key, scancode)
    gameDirector:getMainCharacter():keyreleased(key, scancode)
end

function ConfKeySceneJump:reset()
    gameDirector:reset()
   
end





return ConfKeySceneJump
