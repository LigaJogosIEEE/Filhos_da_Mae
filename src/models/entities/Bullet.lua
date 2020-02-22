local Bullet = {}

Bullet.__index = Bullet

function Bullet:new(world, x, y, orientation, speed, texture, category, shotName)
    local shotName = shotName or {}
    local this = setmetatable({
        world = world,
        orientation = orientation or "right",
        speed = speed or 800, elapsedTime = 0, lifeTime = 1, exploding = false,
        texture = texture, body = nil, shape = nil, fixture = nil,
        spriteExplode = gameDirector:getLibrary("Pixelurite").configureSpriteSheet(shotName.hit or "shot", "assets/elements/", false, 0.07, 1, 1, true),
        sprite = gameDirector:getLibrary("Pixelurite").configureSpriteSheet(shotName.normal or "shot", "assets/elements/", true, nil, 1, 1, true)
    }, Bullet)
    
    --aplying physics
    this.body = love.physics.newBody(this.world, x or 0, y or 0, "kinematic")
    this.shape = love.physics.newCircleShape(16)
    this.fixture = love.physics.newFixture(this.body, this.shape, 0)
    this.fixture:setUserData({name = "Bullet", object = this})
    this.fixture:setCategory(category or 2)
    
    if this.orientation == "right" then
        this.updateFunction = function(dt) this.body:setLinearVelocity(this.speed, 0) end
    elseif this.orientation == "left" then
        this.updateFunction = function(dt) this.body:setLinearVelocity(-this.speed, 0) end
    elseif this.orientation == "up" then
        this.updateFunction = function(dt) this.body:setLinearVelocity(0, -this.speed) end
    elseif this.orientation == "down" then
        this.updateFunction = function(dt) this.body:setLinearVelocity(0, this.speed) end
    end
    
    return this
end

function Bullet:destroy() self.fixture:destroy(); self.shape = nil; self.body:destroy() end

function Bullet:explode()
    self.sprite = self.spriteExplode
    self.exploding = true
    self.fixture:setCategory(4) --always set category as same of enemies
    self.body:setLinearVelocity(0, 0)
end

function Bullet:update(dt)
    self.sprite:update(dt)
    if self.exploding then
        if self.sprite:isOver() then self.elapsedTime = self.lifeTime end
    else
        self.updateFunction(dt)
    end
    self.elapsedTime = self.elapsedTime + dt
    if self.elapsedTime >= self.lifeTime then
        gameDirector:removeBullet(self)
    end
end

function Bullet:draw()
    if self.texture then
        love.graphics.draw(self.texture, self.body:getX(), self.body:getY())
    else
        local rotation = 0
        local offsetX, offsetY = 0, -2
        if self.orientation == "up" then
            rotation = math.pi / 2
            offsetX, offsetY = 6, -20
        end
        self.sprite:draw(self.body:getX() + offsetX, self.body:getY() + offsetY, 2 * (self.orientation == "right" and 1 or -1), 2, nil, nil, rotation)
    end
end

return Bullet
