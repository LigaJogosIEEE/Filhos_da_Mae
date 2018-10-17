local Player = {}

Player.__index = Player

function Player:new(spriteAnimation, world)
    
    local this = {
        move = false,
        inGround = false,
        speed = 250,
        jumpForce = -200,
        orientation = "right",
        animation = "idle",
        previousAnimation = "idle",
        looking = nil,
        world = world or love.physics.newWorld(0, 9.81 * 64),
        spriteAnimation = spriteAnimation or nil
    }
    
    --aplying physics
    this.body = love.physics.newBody(this.world, 10, 700, "dynamic")
    this.shape = love.physics.newCircleShape(26)
    this.fixture = love.physics.newFixture(this.body, this.shape, 1)
    this.body:setFixedRotation(true)
    this.fixture:setUserData("Player")
    this.fixture:setCategory(1)
    this.fixture:setMask(2, 3)
    
    return setmetatable(this, Player)
end

function Player:keypressed(key, scancode, isrepeat)
    if key == "left" then
        self.orientation = "left"
        self.move = true
        self.animation = "running"
    elseif key == "right" then
        self.orientation = "right"
        self.move = true
        self.animation = "running"
    elseif key == "up" then
        self.looking = "up"
        self.animation = "up"
    elseif key == "down" then
        self.looking = "down"
        self.animation = "down"
    end

    if self.looking and self.move then
        self.animation = self.looking == "up" and "runningUp" or "runningDown"
    end
    self.previousAnimation = self.animation ~= "jumping" and self.animation or self.previousAnimation

    if key == "space" and self.inGround then
        self.body:applyLinearImpulse(0, self.jumpForce)
        self.inGround = false
        self.previousAnimation = self.animation ~= "jumping" and self.animation or self.previousAnimation
    end

    if not self.inGround then
        self.animation = "jumping"
    end
    
    if key == "z" then
        local verticalDirection = self.looking == "up" and - 20 or 0
        local horizontalDirection = verticalDirection == 0 and self.orientation == "right" and 20 or self.orientation == "left" and - 10 or 0
        
        local positionToDraw = self.looking == "up" and self.looking or self.orientation
        gameDirector:addBullet(self.body:getX() + horizontalDirection, self.body:getY() + verticalDirection, positionToDraw, 500, 2, true)
    end
end

function Player:keyreleased(key, scancode)
    if key == "left" or key == "right" then
        if key == self.orientation then
            self.move = false
            local xBodyVelocity, yBodyVelocity = self.body:getLinearVelocity()
            self.body:setLinearVelocity(0, yBodyVelocity)
            self.animation = self.inGround and (self.looking or "idle") or "jumping"
            self.previousAnimation = self.animation
            if not self.inGround then
                self.previousAnimation = self.looking or "idle"
            end
        end
    end
    if key == "up" or key == "down" then
        self.looking = nil
        self.animation = self.inGround and (self.move and "running" or "idle") or "jumping"
        self.previousAnimation = self.animation
        if not self.inGround then
            self.previousAnimation = self.move and "running" or "idle"
        end
    end
end

function Player:getPosition()
    return self.body:getX(), self.body:getY()
end

function Player:setPosition(x, y)
    self.body:setX(x); self.body:setY(y)
end

function Player:stopMoving()
    local xVelocity, yVelocity = self.body:getLinearVelocity()
    self.body:setLinearVelocity(0, yVelocity)
end

function Player:reset()
    self.move = false
    self.inGround = true
    self.looking = nil
    self.body:setLinearVelocity(0, 0)
    self.body:setX(540); self.body:setY(100)
    self.orientation = "right"
    self.animation = "idle"
    self.previousAnimation = "idle"
end

function Player:touchGround(isTouching)
    self.inGround = isTouching
    self.animation = self.previousAnimation
    if self.animation == "jumping" and not self.move then
        if love.keyboard.isDown("right") or love.keyboard.isDown("left") then
            self.move = true
        end
    end
end

function Player:getOrientation()
    return self.orientation
end

function Player:compareFixture(fixture)
    return self.fixture == fixture
end

function Player:retreat()
    --local xBodyVelocity, yBodyVelocity = self.body:getLinearVelocity()
    self.body:setLinearVelocity(0, 0)
    self.body:applyLinearImpulse((self.orientation == "left" and 1 or -1) * self.speed / 1.5, self.jumpForce)
    self.inGround = false
    self.move = false
    self.animation = "jumping"
    self.previousAnimation = "idle"
end

function Player:update(dt)
    if self.body:getX() <= 540 then
        self.body:setX(540)
    end
    if self.spriteAnimation then
        if self.move then
            local xBodyVelocity, yBodyVelocity = self.body:getLinearVelocity()
            if self.body:getX() >= 540 then
                self.body:setLinearVelocity((self.orientation == "left" and -1 or 1) * self.speed, yBodyVelocity)
            end
        end
        self.spriteAnimation[self.animation]:update(dt)
    end
end

function Player:draw()
    if self.spriteAnimation then
        local positionToDraw = self.animation
        local scaleX = self.orientation == "right" and 1 or -1
        self.spriteAnimation[positionToDraw]:draw(self.body:getX(), self.body:getY(), scaleX)
        --love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))
        --love.graphics.circle("line", self.body:getX(), self.body:getY(), self.shape:getRadius())
    end
end

return Player
