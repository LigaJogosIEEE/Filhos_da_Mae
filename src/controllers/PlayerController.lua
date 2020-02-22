local PlayerController = {}; PlayerController.__index = PlayerController

function PlayerController:new(LifeForm, Player, spriteAnimation, world)
    local this = setmetatable({
        stats = LifeForm(), player = Player:new(spriteAnimation, world)
    }, PlayerController)

    local playerEvents = {"keypressed", "keyreleased", "retreat", "configureKeys", "draw", "touchGround", "touchWall"}
    for _, eventName in pairs(playerEvents) do
        this[eventName] = function(self, ...) return self.player[eventName](self.player, ...) end
    end

    return this
end

function PlayerController:reset() self.player:reset(); self.stats:reset() end

function PlayerController:isInGround() return self.player.inGround end

function PlayerController:getBody() return self.player:getBody() end

function PlayerController:takeDamage(damageAmount)
    if self.stats:isDead() then return true end
    if damageAmount and damageAmount <= 0 then return false end
    -- here will verify how many damage are received
    local damageAmount = damageAmount or 1; local previousLife = self.stats:getLife()
    local isDead = self.stats:takeDamage(damageAmount)
    if previousLife > self.stats:getLife() then gameDirector:getLifebar():decrement(damageAmount)
    else gameDirector:getLifebar():fill()
    end
    self.player:retreat()
    gameDirector:getCameraController():shake()
	return isDead
end

function PlayerController:instantDeath()
    repeat until self:takeDamage(5000) --can be optmized?
end

function PlayerController:isDead() return self.stats:isDead() end

function PlayerController:shot()
    -- here will verify bullet type for shot
	return self.stats:shot(1)
end

function PlayerController:getMoney() return self.stats:getMoney() end

function PlayerController:getLives() return self.stats:getLives() end

function PlayerController:update(dt)
    self.player:update(dt)
    local x, y = self.player:getPosition()
    if x >= 10691 then self:instantDeath()
    elseif y >= 1350 then self:instantDeath() end
end

return PlayerController
