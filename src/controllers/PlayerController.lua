local PlayerController = {}; PlayerController.__index = PlayerController

function PlayerController:new(LifeForm, Player, spriteAnimation, world)
    local this = setmetatable({
        stats = LifeForm(), player = Player:new(spriteAnimation, world)
    }, PlayerController)

    local playerEvents = {"keypressed", "keyreleased", "retreat", "instantDeath", "configureKeys", "update", "draw"}
    for _, eventName in pairs(playerEvents) do
        this[eventName] = function(self, ...) return self.player[eventName](self.player, ...) end
    end

    return this
end

function PlayerController:reset() self.player:reset(); self.stats:reset() end

function PlayerController:isInGround() return self.player.inGround end

function PlayerController:getBody() return self.player end

function PlayerController:takeDamage(damageAmount)
    -- here will verify how many damage are received
    local damageAmount = damageAmount or 1; local previousLife = self.stats:getLife()
    local isDead = self.stats:takeDamage(damageAmount)
    if previousLife > self.stats:getLife() then gameDirector:getLifebar():decrement(damageAmount)
    else gameDirector:getLifebar():fill()
    end
	return isDead
end

function PlayerController:instantDeath()
    repeat until self:takeDamage(5000) --can be optmized?
end

function PlayerController:isDead() return self.stats:isDead() end

function PlayerController:endContact() self.player:stopMoving() end

function PlayerController:shot()
    -- here will verify bullet type for shot
	return self.stats:shot(1)
end

function PlayerController:getMoney() return self.stats:getMoney() end

function PlayerController:getLives() return self.stats:getLives() end

return PlayerController
