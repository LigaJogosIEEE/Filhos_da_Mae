local Ground = {}

Ground.__index = Ground

function Ground:new(world, groundTexture, width, height, x, y)
    scaleDimension:calculeScales("gameGround", width, height, x, y)
    scaleDimension:centralize("gameGround", true, false, false, true)
    local scales = scaleDimension:getScale("gameGround")

    local this = {
        world = world or love.physics.newWorld(0, 9.81 * 64),
        body = nil,
        shape = love.physics.newRectangleShape(scales.width, scales.height),
        fixture = nil,
        texture = groundTexture
    }
    
    this.body = love.physics.newBody(this.world, scales.x, scales.y, "static")
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
