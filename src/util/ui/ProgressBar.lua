local ProgressBar = {}

ProgressBar.__index = ProgressBar

function ProgressBar:new(x, y, width, height, color, limit, startValue)
    assert(limit, "Progress Bar must needs a limit")
    assert(width and height, "Progress Bar must needs dimensions size")
    local this = {
        x = x or 0, y = y or 0, width = width, height = height, color = color or {1, 1, 1},
        limit = limit, value = startValue or 0, image = nil, quad = nil
    }

    return setmetatable(this, ProgressBar)
end

function ProgressBar:addImage(image, quad)
    self.image, self.quad = image, quad
end

function ProgressBar:increment(incrementalUnit)
    self.value = self.value + incrementalUnit
    if self.value > self.limit then
        self.value = self.limit
    end
end

function ProgressBar:decrement(decrementUnit)
    self.value = self.value - decrementUnit
    if self.value < 0 then
        self.value = 0
    end
end

function ProgressBar:getPercentage()
    return (self.value * 100) / self.limit
end

function ProgressBar:getValue()
    return self.value
end

function ProgressBar:fill()
    self.value = self.limit
end

function ProgressBar:draw()
    love.graphics.setColor(unpack(self.color))
    love.graphics.rectangle("fill", self.x, self.y, (self:getPercentage() * self.width) / 100, self.height)
    love.graphics.setColor(1, 1, 1)
    if self.image then
        if self.quad then
            love.graphics.draw(self.image, self.quad, self.x, self.y, 0)
        else
            love.graphics.draw(self.image, self.x, self.y)
        end
    end
end

return ProgressBar
