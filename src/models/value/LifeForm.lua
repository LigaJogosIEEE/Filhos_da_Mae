local Class = require "models.Class"
local LifeForm = Class:extends("LifeForm")

function LifeForm:new(name, money, life)
	local this = {
		name = name or "Generic LifeForm",
		life = {have = life or 15, total = life or 15},
		healthInsurance = nil,
		money = money or 10
	}

	return this
end

function LifeForm:getMoney()
	return self.money
end

function LifeForm:salaryIncrease(amount)
	self.money = self.money + amount
end

function LifeForm:takeDamage(amountDamage)
	self.life.have = self.life.have - amountDamage
	return self.life.have <= 0
end

function LifeForm:shot(shotValue)
	local previousMoney = self.money
	local newMoneyValue = self.money - shotValue
	self.money = self.money > 0 and (newMoneyValue >= 0 and newMoneyValue or self.money) or self.money
	return self.money ~= previousMoney
end

return LifeForm
