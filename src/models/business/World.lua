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
    local playerFixture, platforms = verifyUserData(a, b, "Player", "platforms")
    local bullet, enemy, death_sensor = nil, nil, nil
    if not playerFixture then playerFixture, bullet = verifyUserData(a, b, "Player", "Bullet") end
    if not bullet then enemy, bullet = verifyUserData(a, b, "Enemy", "Bullet") end
    if not playerFixture then playerFixture, enemy = verifyUserData(a, b, "Player", "Enemy") end
    if not playerFixture then playerFixture, death_sensor = verifyUserData(a, b, "Player", "death-sensor") end
    if playerFixture and platforms then gameDirector:getPlayer():getBody():touchGround(true)
    elseif playerFixture and enemy then
        gameDirector:getEntityByFixture(playerFixture):takeDamage(
            gameDirector:getEnemiesController():getDamage(getUserDataName(enemy))
        )
        gameDirector:getPlayer():retreat()
    elseif playerFixture and death_sensor then
        gameDirector:getEntityByFixture(playerFixture):instantDeath()
    elseif bullet and (enemy or playerFixture) then
        local entity = playerFixture or enemy
        entity:takeDamage(1); gameDirector:removeBullet(nil, bullet)
    end
end

local endContact = function(a, b, coll)
    local entity, bullet = verifyUserData(a, b, "Player", "Bullet")
    if not entity then entity, bullet = verifyUserData(a, b, "Enemy", "Bullet") end
    if entity and bullet then
        if entity.endContact then entity:endContact() end
    end
end

function World:new()
    love.physics.setMeter(64); world = love.physics.newWorld(0, 9.81 * 128)
    world:setCallbacks(beginContact, endContact)
    return setmetatable({world = world}, World)
end

function World:update(dt) self.world:update(dt) end

return World
