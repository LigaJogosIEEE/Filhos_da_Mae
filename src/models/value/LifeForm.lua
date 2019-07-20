local Class = require "models.Class"
local LifeForm = Class:extends("LifeForm")

function LifeForm:new(name, money, life)
	local this = {
		name = name or "Generic LifeForm", lives = 1,
		life = {have = life or 15, total = life or 15},
		healthInsurance = nil, money = money or 10, initialMoney = money or 10
	}

	return this
end

function LifeForm:reset()
	self.life.have = self.life.total; self.lives = 1; self.money = self.initialMoney; self.healthInsurance = nil
end

function LifeForm:getMoney() return self.money end

function LifeForm:getLives() return self.lives end

function LifeForm:getLife() return self.life.have, self.life.total end

function LifeForm:isDead() return self.life.have <= 0 end

function LifeForm:increaseLives(amount) self.lives = self.lives + amount end

function LifeForm:increaseLife(amount)
	self.life.total = self.life.total + amount; self.life.have = self.life.have + amount
end

function LifeForm:increaseSalary(amount) self.money = self.money + amount end

function LifeForm:takeDamage(amountDamage)
	self.life.have = self.life.have - amountDamage
	if self.life.have <= 0 and self.lives > 0 then
		self.life.have = self.life.total; self.lives = self.lives - 1
	end
	return self.life.have <= 0
end

function LifeForm:shot(shotValue)
	local previousMoney = self.money
	local newMoneyValue = self.money - shotValue
	self.money = self.money > 0 and (newMoneyValue >= 0 and newMoneyValue or self.money) or self.money
	return self.money ~= previousMoney
end

return LifeForm
