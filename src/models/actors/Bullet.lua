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
    this.fixture = love.physics.newFixture(this.body, this.shape, 1)
    this.fixture:setUserData("Bullet")
    
    return setmetatable(this, Bullet)
end

function Bullet:update(dt)
    if self.orientation == "right" then
        self.x = self.x + self.speed
        self.body:setX(self.x)
    elseif self.orientation == "left" then
        self.x = self.x - self.speed
        self.body:setX(self.x)
    elseif self.orientation == "up" then
        self.y = self.y - self.speed
        self.body:setY(self.y)
    else
        self.y = self.y + self.speed
        self.body:setY(self.y)
    end
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
