local World = {}

World.__index = World

function World:BulletEntity(a, b, coll)
    local bulletFixture = a:getUserData() == "Bullet" and a or b:getUserData() == "Bullet" and b or nil
    if bulletFixture then
        local entity = nil
        if bulletFixture == a then
            entity = gameDirector:getEntityByFixture(b)
        else
            entity = gameDirector:getEntityByFixture(a)
        end
        return entity, bulletFixture
    end
    return nil
end

function World:getUserData(fixture)
    local userdata = fixture:getUserData()
    return type(userdata) == "table" and userdata.name or userdata
end

local beginContact = function(a, b, coll)
    local mainCharacterFixture = a:getUserData() == "Player" and a or b:getUserData() == "Player" and b or nil
    local otherFixture = mainCharacterFixture == a and b or a
    if mainCharacterFixture then
        if World:getUserData(b) == "platforms" or World:getUserData(a) == "platforms" then
            gameDirector:getMainCharacter():touchGround(true)
        elseif gameDirector:getEntityByFixture(otherFixture) then
            local entityFixture = (otherFixture)
            gameDirector:getEntityByFixture(mainCharacterFixture):takeDamage(
                gameDirector:getEnemiesController():getDamage(World:getUserData(entityFixture))
            )
            gameDirector:getMainCharacter():retreat()
        elseif World:getUserData(otherFixture) == "death-sensor" then
            gameDirector:getEntityByFixture(mainCharacterFixture):instantDeath()
        end
    end
    local entity, bulletFixture = World:BulletEntity(a, b, coll)
    if bulletFixture then
        if entity then
            entity:takeDamage(1)
        end
        gameDirector:removeBullet(nil, bulletFixture)
    end
end

local endContact = function(a, b, coll)
    local entity, bulletFixture = World:BulletEntity(a, b, coll)
    if bulletFixture then
        if entity and entity.endContact then
            entity:endContact()
        end
    end
end

function World:new()
    love.physics.setMeter(64)
    world = love.physics.newWorld(0, 9.81 * 128)
    
    world:setCallbacks(beginContact, endContact)
    
    return setmetatable({world = world}, World)
end

function World:update(dt)
    self.world:update(dt)
end

return World
