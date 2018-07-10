local CharacterController = {}

CharacterController.__index = CharacterController

function CharacterController:new(spriteSheet, world)
    
    local this = {
        x = 0,
        y = 0,
        move = false,
        speed = 2,
        jumpForce = 10,
        orientation = "right",
        looking = nil,
        world = world or love.physics.newWorld(0, 9.81 * 64),
        spriteSheet = spriteSheet or nil
    }
    
    --aplying physics
    this.body = love.physics.newBody(this.world, 0, 0, "dynamic")
    this.shape = love.physics.newPolygonShape({0, 0, 0, 64, 64, 64, 64, 0})
    this.fixture = love.physics.newFixture(this.body, this.shape, 1)
    this.fixture:setUserData("MainCharacter")
    
    return setmetatable(this, CharacterController)
end

function CharacterController:update(dt)
    local pressedKey = false
    local lookingUpDown = false
    if love.keyboard.isDown("up") then
        self.looking = "up"
        lookingUpDown = true
    elseif love.keyboard.isDown("down") then
        self.looking = "down"
        lookingUpDown = true
    end
    if love.keyboard.isDown("left") then
        self.x = self.x - self.speed
        self.body:setX(self.x)
        self.orientation = "left"
        pressedKey = true
    elseif love.keyboard.isDown("right") then
        self.x = self.x + self.speed
        self.body:setX(self.x)
        self.orientation = "right"
        pressedKey = true
    end
    
    if love.keyboard.isDown("space") and inGround then
        self.y = self.y + self.jumpForce
        self.body:applyLinearImpulse(0, -430)
        inGround = false
    end
    
    if love.keyboard.isDown("z") then
        local verticalDirection = self.looking == "up" and - 20 or self.looking == "down" and 70 or 0
        local horizontalDirection = verticalDirection ~= 0 and 30 or self.orientation == "right" and 75 or self.orientation == "left" and - 10 or 0
        
        local positionToDraw = self.looking == nil and self.orientation or self.looking
        gameDirector:addBullet(self.body:getX() + horizontalDirection, self.body:getY() + verticalDirection, positionToDraw, 10)
    end
    
    if pressedKey then
        self.move = true
    else
        self.move = false
    end
    if not lookingUpDown then
        self.looking = nil
    end
    
    if self.spriteSheet then
        if self.move then
            self.spriteSheet[self.orientation].update(dt)
        else
            self.spriteSheet[self.orientation].resetCurrent()
        end
        if self.looking then
            self.spriteSheet[self.looking].update(dt)
        end
    end
end

function CharacterController:draw()
    if self.spriteSheet then
        local positionToDraw = self.looking == nil and self.orientation or self.looking
        self.spriteSheet[positionToDraw].draw(self.body:getX(), self.body:getY())
    end
end

return CharacterController
