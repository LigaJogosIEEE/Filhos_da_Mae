local Ground = {}

Ground.__index = Ground

function Ground:new(world, groundTexture)
    local this = {
        world = world or love.physics.newWorld(0, 9.81 * 64),
        body = nil,
        shape = love.physics.newRectangleShape(800, 30),
        fixture = nil,
        texture = groundTexture
    }
    
    this.body = love.physics.newBody(this.world, 400, 450, "static")
    this.fixture = love.physics.newFixture(this.body, this.shape)
    this.fixture:setUserData("Ground")
    this.fixture:setCategory(1)
    return setmetatable(this, Ground)
end

function Ground:draw()
    if not self.groundTexture then
        love.graphics.setColor(255, 255, 255)
        love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
    end
end

return Ground
