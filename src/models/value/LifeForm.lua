local LifeForm = {}

LifeForm.__index = LifeForm

function LifeForm:new()
	local self = {
		life = {have = 3, total = 3},
		agility = 4,
		bullets = -1 --[[-1 means that have infinity--]]
	}

	return setmetatable(self, LifeForm)
end

function LifeForm:takeDamage(amountDamage)
	self.life.have = self.life.have - amountDamage
	return self.life.have <= 0
end

return LifeForm