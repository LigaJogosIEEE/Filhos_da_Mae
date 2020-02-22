local World = {}; World.__index = World

local function getUserDataName(userData)
    return userData.name or (userData.properties and userData.properties.name)
end

local function verifyUserData(a, b, firstType, secondType)
    if getUserDataName(a:getUserData()) == firstType and getUserDataName(b:getUserData()) == secondType then return a, b
    elseif getUserDataName(b:getUserData()) == firstType and getUserDataName(a:getUserData()) == secondType then return b, a
    else return false, false
    end
end

local beginContact = function(a, b, coll)
    local bullet, enemy, death_sensor, playerFixture, platforms = nil, nil, nil, nil, nil
    playerFixture, platforms = verifyUserData(a, b, "Player", "platforms")
    if not playerFixture then playerFixture, enemy = verifyUserData(a, b, "Player", "Enemy") end
    if not playerFixture then playerFixture, death_sensor = verifyUserData(a, b, "Player", "death-sensor") end
    if not playerFixture then playerFixture, bullet = verifyUserData(a, b, "Player", "Bullet") end
    if not bullet and not enemy then enemy, bullet = verifyUserData(a, b, "Enemy", "Bullet") end
    if not enemy and not platforms then enemy, platforms = verifyUserData(a, b, "Enemy", "platforms") end
    if platforms and (playerFixture or enemy) then
        local entity = (playerFixture and gameDirector:getPlayer():getBody()) or (enemy and enemy:getUserData().object)
        entity:touchGround(true)
    elseif playerFixture and enemy then
        gameDirector:getEntityByFixture(playerFixture):takeDamage(
            gameDirector:getEnemiesController():getDamage(enemy:getUserData().type)
        )
        gameDirector:getPlayer():retreat()
    elseif playerFixture and death_sensor then
        gameDirector:getEntityByFixture(playerFixture):instantDeath()
    elseif bullet and (enemy or playerFixture) then
        local entity = (enemy and enemy:getUserData().object) or (playerFixture and gameDirector:getPlayer())
        entity:takeDamage(1); bullet:getUserData().object:explode()--gameDirector:removeBullet(nil, bullet)
    end
end

local endContact = function(a, b, coll)
    local entity, bullet = verifyUserData(a, b, "Player", "Bullet")
    if entity then entity = gameDirector:getPlayer()
    else entity, bullet = verifyUserData(a, b, "Enemy", "Bullet"); if entity then entity = entity:getUserData().object end end
    if entity and bullet then
        if entity.endContact then entity:endContact() end
    end
end

function World:new()
    world = love.physics.newWorld(0, 512); love.physics.setMeter(64)
    world:setCallbacks(beginContact, endContact)
    return setmetatable({world = world}, World)
end

function World:update(dt) self.world:update(dt) end

return World
