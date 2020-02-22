local World = {}; World.__index = World

local function getUserDataName(userData)
    if type(userData) ~= "table" then return nil end
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
    if enemy and enemy:getUserData().object:isDead() then return end
    if playerFixture and gameDirector:getPlayer():isDead() then return end
    if playerFixture and enemy then
        gameDirector:getEntityByFixture(playerFixture):takeDamage(
            gameDirector:getEnemiesController():getDamage(enemy:getUserData().type)
        )
    elseif playerFixture and death_sensor then
        gameDirector:getEntityByFixture(playerFixture):instantDeath()
    elseif bullet and (enemy or playerFixture) then
        local entity = (enemy and enemy:getUserData().object) or (playerFixture and gameDirector:getPlayer())
        if bullet:getUserData().object:explode() then entity:takeDamage(1) end
    end
end

local function hasSupport(body) --[[ Only floor contacts support the actor --]]
    local _, velocityY = body:getLinearVelocity()
    if velocityY < -0.01 then return false end
    for _, contact in ipairs(body:getContacts()) do
        if contact:isTouching() then
            local first, second = contact:getFixtures()
            local _, normalY = contact:getNormal()
            if first:getBody() == body then
                if getUserDataName(second:getUserData()) == "platforms" and normalY > 0.5 then return true end
            elseif getUserDataName(first:getUserData()) == "platforms" and normalY < -0.5 then
                return true
            end
        end
    end
    return false
end

local function touchesWall(body)
    for _, contact in ipairs(body:getContacts()) do
        if contact:isTouching() then
            local first, second = contact:getFixtures()
            local normalX = contact:getNormal()
            local other = first:getBody() == body and second or first
            if getUserDataName(other:getUserData()) == "platforms" and math.abs(normalX) > 0.5 then return true end
        end
    end
    return false
end

local function preSolve(a, b, contact)
    for _, fixture in ipairs({a, b}) do
        if getUserDataName(fixture:getUserData()) == "Enemy" and fixture:getUserData().object:isDead() then
            contact:setEnabled(false)
            return
        end
    end
end

function World:new()
    love.physics.setMeter(64)
    --[[ Keep original gravity after setting the physics meter --]]
    local gravity = 512 / 30 * 64
    local world = love.physics.newWorld(0, gravity)
    world:setCallbacks(beginContact, nil, preSolve)
    return setmetatable({world = world}, World)
end

function World:update(dt)
    self.world:update(dt)
    local player = gameDirector:getPlayer()
    player:touchGround(hasSupport(player:getBody()))
    player:touchWall(touchesWall(player:getBody()))
    gameDirector:getEnemiesController():touchGround(hasSupport)
end

return World
