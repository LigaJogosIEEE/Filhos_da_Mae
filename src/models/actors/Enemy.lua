local Enemy = {}

Enemy.__index = Enemy

function Enemy:new(spriteAnimation, world, x, y, enemyType, colisorDimensions)
    assert(colisorDimensions and type(colisorDimensions) == "table", "Enemy needs a colisor dimension and its need to be a table")
    local this = {
        isMoving = false,
        inGround = false,
        speed = 100,
        jumpForce = 320,
        orientation = "left",
        animation = "idle",
        previousAnimation = "idle",
        looking = nil,
        world = world or love.physics.newWorld(0, 9.81 * 64),
        spriteAnimation = spriteAnimation or nil,
        lifeForm = gameDirector:getLibrary("LifeForm")(enemyType, 5, 2)
    }
    
    --aplying physics
    this.body = love.physics.newBody(this.world, x or 0, y or 0, "dynamic")
    this.body:setFixedRotation(true)
    this.shape = love.physics.newRectangleShape(unpack(colisorDimensions))
    this.fixture = love.physics.newFixture(this.body, this.shape, 1)
    this.fixture:setUserData(enemyType or "Enemy")
    this.fixture:setMask(3)
    
    return setmetatable(this, Enemy)
end

function Enemy:compareFixture(fixture)
    return self.fixture == fixture
end

function Enemy:reset()
    self.isMoving = false
    self.inGround = true
    self.looking = nil
    self.body:setLinearVelocity(0, 0)
    self.body:setX(10); self.body:setY(700)
    self.orientation = "left"
    self.animation = "idle"
    self.previousAnimation = "idle"
end

function Enemy:takeDamage(amount)
    local isDead = self.lifeForm:takeDamage(amount)
    if isDead then
        self.fixture:destroy()
        self.shape = nil
        self.body:destroy()
        gameDirector.enemiesController:remove(self)
    end
end

function Enemy:endContact()
    local xVelocity, yVelocity = self.body:getLinearVelocity()
    self.body:setLinearVelocity(0, 0)
end

function Enemy:move(key)
    if key == "up" then
        self.looking = "up"
    elseif key == "down" then
        self.looking = "down"
    elseif key == "left" then
        self.orientation = "left"
        self.isMoving = true
    elseif key == "right" then
        self.orientation = "right"
        self.isMoving = true
    end
    if self.isMoving then self.animation = "running" end
end

function Enemy:jump()
    self.body:applyLinearImpulse(0, -430)
    self.inGround = false
end

function Enemy:shot()
    local verticalDirection = self.looking == "up" and - 20 or self.looking == "down" and 70 or 0
    local horizontalDirection = verticalDirection ~= 0 and 0 or self.orientation == "right" and 10 or self.orientation == "left" and - 10 or 0
    
    local positionToDraw = self.looking == nil and self.orientation or self.looking
    gameDirector:addBullet(self.body:getX() + horizontalDirection, self.body:getY() + verticalDirection, positionToDraw, 300, 3)
end

function Enemy:stopMoving(key)
    if key == "left" or key == "right" then
        if key == self.orientation then
            self.isMoving = false
            local xBodyVelocity, yBodyVelocity = self.body:getLinearVelocity()
            self.body:setLinearVelocity(0, yBodyVelocity)
            self.animation = "idle"
        end
    end
    if key == "up" or key == "down" then
        self.looking = nil
    end
end

function Enemy:update(dt)
    if self.spriteAnimation then
        if self.inGround and self.animation == "jumping" then
            self.animation = self.previousAnimation
        end
        if self.isMoving then
            local xBodyVelocity, yBodyVelocity = self.body:getLinearVelocity()
            self.body:setLinearVelocity((self.orientation == "left" and -1 or 1) * self.speed, yBodyVelocity)
        end
        self.spriteAnimation[self.animation]:update(dt)
    end
end

function Enemy:draw()
    if self.spriteAnimation then
        local positionToDraw = self.animation
        local scaleX = self.orientation == "right" and -1 or 1
        self.spriteAnimation[positionToDraw]:draw(self.body:getX(), self.body:getY(), scaleX)
        --love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))
    end
end

return Enemy
