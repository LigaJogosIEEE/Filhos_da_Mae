local CharacterController = {}

CharacterController.__index = CharacterController

function CharacterController:new(spriteSheet, world)
    
    local this = {
        move = false,
        inGround = false,
        speed = 10,
        jumpForce = 10,
        orientation = "right",
        looking = nil,
        world = world or love.physics.newWorld(0, 9.81 * 64),
        spriteSheet = spriteSheet or nil
    }
    
    --aplying physics
    this.body = love.physics.newBody(this.world, 0, 0, "dynamic")
    this.body:setFixedRotation(true)
    this.shape = love.physics.newPolygonShape({0, 0, 0, 64, 64, 64, 64, 0})
    this.fixture = love.physics.newFixture(this.body, this.shape, 1)
    this.fixture:setUserData("MainCharacter")
    this.fixture:setMask(2)
    
    return setmetatable(this, CharacterController)
end

function CharacterController:keypressed(key, scancode, isrepeat)
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
    
    if key == "space" and self.inGround then
        self.body:applyLinearImpulse(0, -430)
        self.inGround = false
    end
    
    if key == "z" then
        local verticalDirection = self.looking == "up" and - 20 or self.looking == "down" and 70 or 25
        local horizontalDirection = verticalDirection ~= 0 and 30 or self.orientation == "right" and 75 or self.orientation == "left" and - 10 or 0
        
        local positionToDraw = self.looking == nil and self.orientation or self.looking
        gameDirector:addBullet(self.body:getX() + horizontalDirection, self.body:getY() + verticalDirection, positionToDraw, 15, 2)
    end
end

function CharacterController:keyreleased(key, scancode)
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

function CharacterController:update(dt)
    if self.spriteSheet then
        if self.move then
            if self.orientation == "left" then
                self.body:applyLinearImpulse(-1 * self.speed, 0)
            elseif self.orientation == "right" then
                self.body:applyLinearImpulse(self.speed, 0)
            end
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
        --love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
    end
end

return CharacterController
