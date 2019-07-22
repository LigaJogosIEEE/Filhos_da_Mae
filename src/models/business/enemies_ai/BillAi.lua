local BillAi = {}; BillAi.__index = BillAi

function BillAi:new(actor)
    assert(actor, "Is needed a actor to manipulate")
    local this = {
        actor = actor,
        elapsedTime = 0
    }

    return setmetatable(this, BillAi)
end

function BillAi:lookToPlayer(xPlayer, yPlayer)
    local x, y = self.actor.body:getX(), self.actor.body:getY()
    local orientation = xPlayer > x and "right" or "left"
    self.actor:move(orientation); self.actor:stopMoving(orientation)
end

function BillAi:update(dt)
    self.elapsedTime = self.elapsedTime + dt
    local x, y = gameDirector:getPlayer():getBody():getPosition()
    local xDistance = math.abs(self.actor.body:getX() - x)
    local yDistance = math.abs(self.actor.body:getY() - y)
    local distance = math.sqrt(yDistance ^ 2 + xDistance ^ 2)
    if distance <= 185 and self.elapsedTime >= 0.7 then
        self.actor:shot() -- Command to enemy shot
        self.elapsedTime = 0
    elseif distance <= 300 then self.actor:jump(); self:lookToPlayer(x, y)
    end
end

return BillAi
