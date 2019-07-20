local Bullet = {}

Bullet.__index = Bullet

function Bullet:new(world, x, y, orientation, speed, texture, category)
    local this = setmetatable({
        world = world or love.physics.newWorld(0, 9.81 * 64),
        orientation = orientation or "right",
        speed = speed or 800, elapsedTime = 0, lifeTime = 1,
        texture = texture, body = nil, shape = nil, fixture = nil,
        image = love.graphics.newImage("assets/elements/" .. (category and (category == 1 and "1_real" or category == 2 and "50_centavos") or "25_centavos") .. ".png")
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
    self.speed = self.speed + 10
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
        --[[love.graphics.setColor(72 / 255, 160 / 255, 140 / 255)
        love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
        love.graphics.setColor(1, 1, 1)--]]
        love.graphics.draw(self.image, self.body:getX(), self.body:getY(), 0, 3, 3)
        --love.graphics.circle("line", self.body:getX(), self.body:getY(), 16)
    end
end

return Bullet
