local SeuBarrigaAi = {}

SeuBarrigaAi.__index = SeuBarrigaAi

function SeuBarrigaAi:new(actor)
    assert(actor, "Is needed a actor to manipulate")
    local this = {
        actor = actor,
        elapsedTime = 0,
        speedToggle = false
    }

    return setmetatable(this, SeuBarrigaAi)
end

function SeuBarrigaAi:moveToPlayer(xPlayer, yPlayer, xDistance, yDistance)
    local x, y = self.actor.body:getX(), self.actor.body:getY()
    if xDistance >= 300 then
        self.actor:move(xPlayer > x and "right" or "left")
    end
end

function SeuBarrigaAi:update(dt)
    self.elapsedTime = self.elapsedTime + dt
    local x, y = gameDirector:getPlayer():getBody():getPosition()
    local xDistance = math.abs(self.actor.body:getX() - x)
    local yDistance = math.abs(self.actor.body:getY() - y)
    local distance = math.sqrt(yDistance ^ 2 + xDistance ^ 2)
    if distance <= 185 and self.elapsedTime >= 0.7 then
        self.actor:setSpeed(getSpeed() * self.speedToggle and 0.5 or 2)
        self.elapsedTime = 0
    elseif distance <= 300 then
        self:moveToPlayer(x, y, xDistance, yDistance)
    else
        self.actor:stopMoving("right")
    end
end

return SeuBarrigaAi
