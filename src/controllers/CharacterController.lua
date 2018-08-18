local CharacterController = {}
CharacterController.__index = CharacterController

function CharacterController:new(LifeForm)
    local this = {stats = LifeForm()}
    return setmetatable(this, CharacterController)
end

function CharacterController:takeDamage()
    -- here will verify too damage type
	return self.stats:takeDamage(1)
end

function CharacterController:shot()
    -- here will verify bullet type for shot
	return self.stats:shot(1)
end

function CharacterController:update(dt)
end

function CharacterController:draw()
end

return CharacterController
