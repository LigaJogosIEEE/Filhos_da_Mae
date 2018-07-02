local CharacterController = {}

CharacterController.__index = CharacterController

function CharacterController:new(spriteSheet, world)
    
    local this = {
        x = 0,
        y = 0,
        move = false,
        speed = 2.5,
        jumpForce = 10,
        orientation = "right",
        spriteSheet = spriteSheet or nil,
        world = world or love.physics.newWorld(0, 9.81 * 64)
    }

    --aplying physics
    this.body = love.physics.newBody(this.world, 0, 0, "dynamic")
    this.shape = love.physics.newPolygonShape({0,0, 0,64, 64,64, 64,0})
    this.fixture = love.physics.newFixture(this.body, this.shape, 1)
    
    return setmetatable(this, CharacterController)
end

function CharacterController:update(dt)
    local pressedKey = false
    if love.keyboard.isDown("up") then
        --[[self.y = self.y - self.speed
        self.body:setY(self.y)--]]
        self.orientation = "up"
        pressedKey = true
    elseif love.keyboard.isDown("down") then
        --[[self.y = self.y + self.speed
        self.body:setY(self.y)--]]
        self.orientation = "down"
        pressedKey = true
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
    
    if pressedKey then
        self.move = true
    else
        self.move = false
    end
    
    if self.spriteSheet then
        if self.move then
            self.spriteSheet[self.orientation].update(dt)
        else
            self.spriteSheet[self.orientation].resetCurrent()
        end
    end
end

function CharacterController:draw()
    if self.spriteSheet then
        self.spriteSheet[self.orientation].draw(self.body:getX(), self.body:getY())
    end
end

return CharacterController
