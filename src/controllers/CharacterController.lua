local CharacterController = {}
CharacterController.__index = CharacterController

function CharacterController:new(LifeForm)
    local this = {stats = LifeForm()}
    return setmetatable(this, CharacterController)
end

function CharacterController:takeDamage(damageAmount)
    -- here will verify how many damage are received
    local damageAmount = damageAmount or 1
    local previousLife = self.stats:getLife()
    local isDead = self.stats:takeDamage(damageAmount)
    if previousLife > self.stats:getLife() then
        gameDirector:getLifebar():decrement(damageAmount)
    else
        gameDirector:getLifebar():fill()
    end
	return isDead
end

function CharacterController:isDead()
    return self.stats:isDead()
end

function CharacterController:endContact()
    gameDirector:getMainCharacter():stopMoving()
end

function CharacterController:shot()
    -- here will verify bullet type for shot
	return self.stats:shot(1)
end

function CharacterController:getMoney()
    return self.stats:getMoney()
end

function CharacterController:getLives()
    return self.stats:getLives()
end

return CharacterController
