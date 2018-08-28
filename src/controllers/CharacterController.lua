local CharacterController = {}
CharacterController.__index = CharacterController

function CharacterController:new(LifeForm)
    local this = {stats = LifeForm()}
    return setmetatable(this, CharacterController)
end

function CharacterController:takeDamage()
    -- here will verify too damage type
    local damageAmount = 1
    local isDead = self.stats:takeDamage(damageAmount)
    gameDirector:updateLifebar(damageAmount, true)
	return isDead
end

function CharacterController:shot()
    -- here will verify bullet type for shot
	return self.stats:shot(1)
end

function CharacterController:getMoney()
    return self.stats:getMoney()
end

return CharacterController
