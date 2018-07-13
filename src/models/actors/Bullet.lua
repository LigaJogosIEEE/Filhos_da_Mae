local Bullet = {}

Bullet.__index = Bullet

function Bullet:new(world, x, y, orientation, speed, texture, category)
    local this = {
        world = world or love.physics.newWorld(0, 9.81 * 64),
        orientation = orientation or "right",
        speed = speed or 100,
        elapsedTime = 0,
        lifeTime = 1,
        texture = texture,
        body = nil,
        shape = nil,
        fixture = nil
    }
    
    --aplying physics
    this.body = love.physics.newBody(this.world, x or 0, y or 0, "kinematic")
    this.shape = love.physics.newRectangleShape(16, 10)
    this.fixture = love.physics.newFixture(this.body, this.shape, 0)
    this.fixture:setUserData("Bullet")
    this.fixture:setCategory(category or 2)
    
    if this.orientation == "right" then
        this.updateFunction = function(dt)
            this.body:setX(this.body:getX() + this.speed)
        end
    elseif this.orientation == "left" then
        this.updateFunction = function(dt)
            this.body:setX(this.body:getX() - this.speed)
        end
    elseif this.orientation == "up" then
        this.updateFunction = function(dt)
            this.body:setY(this.body:getY() - this.speed)
        end
    elseif this.orientation == "down" then
        this.updateFunction = function(dt)
            this.body:setY(this.body:getY() + this.speed)
        end
    end
    
    return setmetatable(this, Bullet)
end

function Bullet:update(dt)
    self.updateFunction(dt)
    self.speed = self.speed + 1
    self.elapsedTime = self.elapsedTime + dt
    if self.elapsedTime >= self.lifeTime then
        gameDirector:removeBullet(self)
    end
end

function Bullet:draw()
    if self.texture then
        love.graphics.draw(self.texture, self.body:getX(), self.body:getY())
    else
        love.graphics.setColor(72 / 255, 160 / 255, 140 / 255)
        love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
        love.graphics.setColor(255 / 255, 255 / 255, 255 / 255)
    end
end

return Bullet
