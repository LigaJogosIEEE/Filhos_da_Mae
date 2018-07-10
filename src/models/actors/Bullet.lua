local Bullet = {}

Bullet.__index = Bullet

function Bullet:new(world, x, y, orientation, speed, texture)
    local this = {
        world = world or love.physics.newWorld(0, 9.81 * 64),
        x = x or 0,
        y = y or 0,
        orientation = orientation or "right",
        speed = speed or 100,
        texture = texture
    }
    
    --aplying physics
    this.body = love.physics.newBody(this.world, this.x, this.y, "kinematic")
    this.shape = love.physics.newRectangleShape(16, 10)
    this.fixture = love.physics.newFixture(this.body, this.shape, 0)
    this.fixture:setUserData("Bullet")
    
    if this.orientation == "right" then
        this.update = function(dt)
            this.x = this.x + this.speed
            this.body:setX(this.x)
        end
    elseif this.orientation == "left" then
        this.update = function(dt)
            this.x = this.x - this.speed
            this.body:setX(this.x)
        end
    elseif this.orientation == "up" then
        this.update = function(dt)
            this.y = this.y - this.speed
            this.body:setY(this.y)
        end
    else
        this.update = function(dt)
            this.y = this.y + this.speed
            this.body:setY(this.y)
        end
    end
    
    return setmetatable(this, Bullet)
end

function Bullet:update(dt)
    self.update(dt)
end

function Bullet:draw()
    if self.texture then
        love.graphics.draw(self.texture, self.x, self.y)
    else
        love.graphics.setColor(72, 160, 14)
        love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
    end
end

return Bullet
