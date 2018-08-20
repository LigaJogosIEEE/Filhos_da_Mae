local CharacterController = {}
CharacterController.__index = CharacterController

function CharacterController:new(LifeForm)
    local this = {stats = LifeForm()}
    return setmetatable(this, CharacterController)
end

function CharacterController:takeDamage()
    -- here will verify too damage type
    local damageAmount = 1
    local takenDamage = self.stats:takeDamage(damageAmount)
    if takenDamage then
        gameDirector:updateLifebar(damageAmount, true)
    end
	return 
end

function CharacterController:shot()
    -- here will verify bullet type for shot
	return self.stats:shot(1)
end

function CharacterController:getMoney()
    return self.stats:getMoney()
end


return CharacterController
