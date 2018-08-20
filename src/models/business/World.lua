local World = {}

World.__index = World

local beginContact = function(a, b, coll)
    local mainCharacterFixture = a:getUserData() == "MainCharacter" and a or b:getUserData() == "MainCharacter" and b or nil
    if mainCharacterFixture then
        if b:getUserData() == "Ground" or a:getUserData() == "Ground" then
            gameDirector:getMainCharacter().inGround = true
        elseif gameDirector:getEntityByFixture(mainCharacterFixture == a and b or a) then
            gameDirector:getEntityByFixture(mainCharacterFixture):takeDamage(1)
            gameDirector:getMainCharacter():retreat()
        end
    end
    local bulletFixture = a:getUserData() == "Bullet" and a or b:getUserData() == "Bullet" and b or nil
    if bulletFixture then
        local entity = nil
        if bulletFixture == a then
            entity = gameDirector:getEntityByFixture(b)
        else
            entity = gameDirector:getEntityByFixture(a)
        end
        if entity then
            entity:takeDamage(1)
        end
    	gameDirector:removeBullet(nil, bulletFixture)
    end
end

function World:new()
    love.physics.setMeter(64)
    world = love.physics.newWorld(0, 9.81 * 128)
    
    world:setCallbacks(beginContact)
    
    return setmetatable({world = world}, World)
end

function World:update(dt)
    self.world:update(dt)
end

return World
