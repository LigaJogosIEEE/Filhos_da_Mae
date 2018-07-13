local World = {}

World.__index = World

local beginContact = function(a, b, coll)
    if (a:getUserData() == "MainCharacter" and b:getUserData() == "Ground") or (a:getUserData() == "Ground" and b:getUserData() == "MainCharacter") then
        gameDirector:getMainCharacter().inGround = true
    end
    local bulletFixture = a:getUserData() == "Bullet" and a or b:getUserData() == "Bullet" and b or nil
    if bulletFixture then
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
