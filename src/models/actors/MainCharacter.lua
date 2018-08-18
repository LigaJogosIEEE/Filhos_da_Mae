local MainCharacter = {}

MainCharacter.__index = MainCharacter

function MainCharacter:new(spriteAnimation, world)
    
    local this = {
        move = false,
        inGround = false,
        speed = 10,
        jumpForce = 10,
        orientation = "right",
        animation = "idle",
        looking = nil,
        world = world or love.physics.newWorld(0, 9.81 * 64),
        spriteAnimation = spriteAnimation or nil
    }
    
    --aplying physics
    this.body = love.physics.newBody(this.world, 0, 0, "dynamic")
    this.body:setFixedRotation(true)
    this.shape = love.physics.newRectangleShape(64, 64)
    this.fixture = love.physics.newFixture(this.body, this.shape, 1)
    this.fixture:setUserData("MainCharacter")
    this.fixture:setMask(2)
    
    return setmetatable(this, MainCharacter)
end

function MainCharacter:keypressed(key, scancode, isrepeat)
    if key == "left" then
        self.orientation = "left"
        self.move = true
        self.animation = "running"
    elseif key == "right" then
        self.orientation = "right"
        self.move = true
        self.animation = "running"
    end
    if key == "up" then
        self.looking = "up"
        self.animation = "up"
    elseif key == "down" then
        self.looking = "down"
        self.animation = "down"
    end
    
    if key == "space" and self.inGround then
        self.body:applyLinearImpulse(0, -430)
        self.inGround = false
        self.animation = "jumping"
    end
    
    if key == "z" then
        local verticalDirection = self.looking == "up" and - 20 or self.looking == "down" and 70 or 0
        local horizontalDirection = verticalDirection ~= 0 and 30 or self.orientation == "right" and 75 or self.orientation == "left" and - 10 or 0
        
        local positionToDraw = self.looking == nil and self.orientation or self.looking
        gameDirector:addBullet(self.body:getX() + horizontalDirection, self.body:getY() + verticalDirection, positionToDraw, 15, 2, true)
    end
end

function MainCharacter:keyreleased(key, scancode)
    if key == "left" or key == "right" then
        if key == self.orientation then
            self.move = false
            local xBodyVelocity, yBodyVelocity = self.body:getLinearVelocity()
            self.body:setLinearVelocity(0, yBodyVelocity)
            if self.looking then
                self.animation = "idle"
            end
        end
    end
    if key == "up" or key == "down" then
        self.looking = nil
        if self.move then
            self.animation = "running"
        else
            self.animation = "idle"
        end
    end
end

function MainCharacter:getPosition()
    return self.body:getX(), self.body.getY()
end

function MainCharacter:setPosition(x, y)
    self.body:setX(x); self.body:setY(y)
end

function MainCharacter:getOrientation()
    return self.orientation
end

function MainCharacter:compareFixture(fixture)
    return self.fixture == fixture
end

function MainCharacter:takeDamage(amount)
end

function MainCharacter:update(dt)
    if self.spriteAnimation then
        if self.move then
            if self.orientation == "left" then
                self.body:applyLinearImpulse(-1 * self.speed, 0)
            elseif self.orientation == "right" then
                self.body:applyLinearImpulse(self.speed, 0)
            end
            self.spriteAnimation[self.animation]:update(dt)
        else
            self.spriteAnimation[self.animation]:resetCurrent()
        end
        if self.looking then
            self.spriteAnimation[self.looking]:update(dt)
        end
    end
end

function MainCharacter:draw()
    if self.spriteAnimation then
        local positionToDraw = self.animation
        local scaleX = self.orientation == "right" and 1 or -1
        self.spriteAnimation[positionToDraw]:draw(self.body:getX(), self.body:getY(), scaleX)
        --love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
    end
end

return MainCharacter
