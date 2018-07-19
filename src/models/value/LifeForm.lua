local LifeForm = {}

LifeForm.__index = LifeForm

function LifeForm:new()
	local self = {
		life = {have = 3, total = 3},
		agility = 4,
		havingBullets = 300,
		healthInsurance = nil,
		money = 0
	}

	return setmetatable(self, LifeForm)
end

function LifeForm:takeDamage(amountDamage)
	self.life.have = self.life.have - amountDamage
	return self.life.have <= 0
end

function LifeForm:shot()
	self.havingBullets = self.havingBullets - 1
end

return LifeForm