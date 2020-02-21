local Bullet = {}

Bullet.__index = Bullet

function Bullet:new(world, x, y, orientation, speed, texture, category)
    local this = setmetatable({
        world = world or love.physics.newWorld(0, 9.81 * 64),
        orientation = orientation or "right",
        speed = speed or 800, elapsedTime = 0, lifeTime = 1,
        texture = texture, body = nil, shape = nil, fixture = nil,
        sprite = gameDirector:getLibrary("Pixelurite").configureSpriteSheet("shot", "assets/elements/", true, nil, 1, 1, true)
    }, Bullet)
    
    --aplying physics
    this.body = love.physics.newBody(this.world, x or 0, y or 0, "kinematic")
    this.shape = love.physics.newCircleShape(16)
    this.fixture = love.physics.newFixture(this.body, this.shape, 0)
    this.fixture:setUserData({name = "Bullet", objetic = this})
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

function Bullet:update(dt)
    self.sprite:update(dt)
    self.updateFunction(dt)
    self.elapsedTime = self.elapsedTime + dt
    if self.elapsedTime >= self.lifeTime then
        gameDirector:removeBullet(self)
    end
end

function Bullet:draw()
    if self.texture then
        love.graphics.draw(self.texture, self.body:getX(), self.body:getY())
    else
        self.sprite:draw(self.body:getX(), self.body:getY() - 2, 2 * (self.orientation == "right" and 1 or -1), 2)
    end
end

return Bullet
