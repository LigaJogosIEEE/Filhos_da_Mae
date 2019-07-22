local TwoGuysInMotorcycleAi = {}; TwoGuysInMotorcycleAi.__index = TwoGuysInMotorcycleAi

function TwoGuysInMotorcycleAi:new(actor)
    assert(actor, "Is needed a actor to manipulate")
    local this = {
        actor = actor,
        elapsedTime = 0
    }

    return setmetatable(this, TwoGuysInMotorcycleAi)
end

function TwoGuysInMotorcycleAi:moveToPlayer(xPlayer, yPlayer, xDistance, yDistance)
    local x, y = self.actor.body:getX(), self.actor.body:getY()
    if xDistance >= 80 then
        self.actor:move(xPlayer > x and "right" or "left")
    end
end

function TwoGuysInMotorcycleAi:update(dt)
    self.elapsedTime = self.elapsedTime + dt
    local x, y = gameDirector:getPlayer():getBody():getPosition()
    local xDistance = math.abs(self.actor.body:getX() - x)
    local yDistance = math.abs(self.actor.body:getY() - y)
    local distance = math.sqrt(yDistance ^ 2 + xDistance ^ 2)
    if distance <= 185 and self.elapsedTime >= 0.7 then
        self.actor:shot() -- Command to enemy shot
        self.elapsedTime = 0
    elseif distance <= 300 then self:moveToPlayer(x, y, xDistance, yDistance)
    else self.actor:stopMoving("right")
    end
end

return TwoGuysInMotorcycleAi
