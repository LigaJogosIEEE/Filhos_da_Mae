local Enemy = {}

Enemy.__index = Enemy

function Enemy:new(spriteSheet, world, x, y, enemyType)
    
    local this = {
        move = false,
        inGround = false,
        speed = 10,
        jumpForce = 10,
        orientation = "left",
        looking = nil,
        world = world or love.physics.newWorld(0, 9.81 * 64),
        spriteSheet = spriteSheet or nil
    }
    
    --aplying physics
    this.body = love.physics.newBody(this.world, x or 0, y or 0, "dynamic")
    this.shape = love.physics.newPolygonShape({16, 0, 16, 64, 64, 64, 64, 0})
    this.fixture = love.physics.newFixture(this.body, this.shape, 1)
    this.fixture:setUserData(enemyType or "Enemy")
    this.fixture:setMask(3)
    
    return setmetatable(this, Enemy)
end

function Enemy:move(key)
    if key == "up" then
        self.looking = "up"
    elseif key == "down" then
        self.looking = "down"
    end
    if key == "left" then
        self.orientation = "left"
        self.move = true
    elseif key == "right" then
        self.orientation = "right"
        self.move = true
    end
end

function Enemy:jump()
    self.body:applyLinearImpulse(0, -430)
    self.inGround = false
end

function Enemy:shot()
    local verticalDirection = self.looking == "up" and - 20 or self.looking == "down" and 70 or 0
    local horizontalDirection = verticalDirection ~= 0 and 30 or self.orientation == "right" and 75 or self.orientation == "left" and - 10 or 0
    
    local positionToDraw = self.looking == nil and self.orientation or self.looking
    gameDirector:addBullet(self.body:getX() + horizontalDirection, self.body:getY() + verticalDirection, positionToDraw, 15, 3)
end

function Enemy:stopMoving(key)
    if key == "left" or key == "right" then
        if key == self.orientation then
            self.move = false
            local xBodyVelocity, yBodyVelocity = self.body:getLinearVelocity()
            self.body:setLinearVelocity(0, yBodyVelocity)
        end
    end
    if key == "up" or key == "down" then
        self.looking = nil
    end
end

function Enemy:update(dt)
    if self.spriteSheet then
        if self.move then
            if self.orientation == "left" then
                self.body:applyLinearImpulse(-1 * self.speed, 0)
            elseif self.orientation == "right" then
                self.body:applyLinearImpulse(self.speed, 0)
            end
        end
        self.spriteSheet[self.orientation].update(dt)
        if self.looking then
            self.spriteSheet[self.looking].update(dt)
        end
    end
end

function Enemy:draw()
    if self.spriteSheet then
        local positionToDraw = self.looking == nil and self.orientation or self.looking
        self.spriteSheet[positionToDraw].draw(self.body:getX(), self.body:getY())
    end
end

return Enemy
