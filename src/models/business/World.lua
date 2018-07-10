local World = {}

World.__index = World

local beginContact = function()
    inGround = true
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
