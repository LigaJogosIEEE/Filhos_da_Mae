local MainCharacter = {}

MainCharacter.__index = MainCharacter

function MainCharacter:new(spriteAnimation, world)
    
    local this = {
        move = false,
        inGround = false,
        speed = 150,
        jumpForce = -320,
        orientation = "right",
        animation = "idle",
        previousAnimation = "idle",
        looking = nil,
        world = world or love.physics.newWorld(0, 9.81 * 64),
        spriteAnimation = spriteAnimation or nil
    }
    
    --aplying physics
    this.body = love.physics.newBody(this.world, 10, 700, "dynamic")
    this.body:setFixedRotation(true)
    this.shape = love.physics.newRectangleShape(58, 54)
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
        self.previousAnimation = self.animation
        self.animation = "jumping"
    end

    if not self.inGround then
        self.animation = "jumping"
    end
    
    if key == "z" then
        local verticalDirection = self.looking == "up" and - 20 or 0
        local horizontalDirection = verticalDirection == 0 and self.orientation == "right" and 20 or self.orientation == "left" and - 10 or 0
        
        local positionToDraw = self.looking == "up" and self.looking or self.orientation
        gameDirector:addBullet(self.body:getX() + horizontalDirection, self.body:getY() + verticalDirection, positionToDraw, 15, 2, true)
    end
end

function MainCharacter:keyreleased(key, scancode)
    if key == "left" or key == "right" then
        if key == self.orientation then
            self.move = false
            local xBodyVelocity, yBodyVelocity = self.body:getLinearVelocity()
            self.body:setLinearVelocity(0, yBodyVelocity)
            self.animation = self.inGround and (self.looking or "idle") or "jumping"
            if not self.inGround then
                self.previousAnimation = self.looking or "idle"
            end
        end
    end
    if key == "up" or key == "down" then
        self.looking = nil
        self.animation = self.inGround and (self.move and "running" or "idle") or "jumping"
        if not self.inGround then
            self.previousAnimation = self.move and "running" or "idle"
        end
    end
end

function MainCharacter:getPosition()
    return self.body:getX(), self.body:getY()
end

function MainCharacter:setPosition(x, y)
    self.body:setX(x); self.body:setY(y)
end

function MainCharacter:reset()
    self.move = false
    self.inGround = true
    self.looking = nil
    self.body:setLinearVelocity(0, 0)
    self.body:setX(10); self.body:setY(700)
    self.orientation = "right"
    self.animation = "idle"
    self.previousAnimation = "idle"
end

function MainCharacter:touchGround(isTouching)
    self.inGround = isTouching
    if self.animation == "jumping" and not self.move then
        if love.keyboard.isDown("right") or love.keyboard.isDown("left") then
            self.move = true
        end
    end
end

function MainCharacter:getOrientation()
    return self.orientation
end

function MainCharacter:compareFixture(fixture)
    return self.fixture == fixture
end

function MainCharacter:retreat()
    --local xBodyVelocity, yBodyVelocity = self.body:getLinearVelocity()
    self.body:setLinearVelocity(0, 0)
    self.body:applyLinearImpulse((self.orientation == "left" and 1 or -1) * self.speed, self.jumpForce)
    self.inGround = false
    self.move = false
    self.animation = "jumping"
end

function MainCharacter:update(dt)
    if self.spriteAnimation then
        if self.inGround and self.animation == "jumping" then
            self.animation = self.previousAnimation
        end
        if self.move then
            local xBodyVelocity, yBodyVelocity = self.body:getLinearVelocity()
            self.body:setLinearVelocity((self.orientation == "left" and -1 or 1) * self.speed, yBodyVelocity)
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
        --love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))
    end
end

return MainCharacter
