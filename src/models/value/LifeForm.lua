local Class = require "models.Class"
local LifeForm = Class:extends("LifeForm")

function LifeForm:new(name, money)
	local this = {
		name = name or "Generic LifeForm",
		life = {have = 15, total = 15},
		healthInsurance = nil,
		money = money or 10
	}

	return this
end

function LifeForm:takeDamage(amountDamage)
	self.life.have = self.life.have - amountDamage
	return self.life.have <= 0
end

function LifeForm:shot(shotValue)
	self.money = self.money - shotValue
	return self.money >= 0
end

return LifeForm
