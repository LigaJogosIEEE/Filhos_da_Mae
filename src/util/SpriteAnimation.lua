local SpriteAnimation = {}

SpriteAnimation.__index = SpriteAnimation

function SpriteAnimation:new(frameList, atlas, duration, looping)
    local this = {
        firstFrame = nil, currentFrame = nil, amountFrames = 0,
        atlas = atlas, currentTime = 0, duration = duration or 0.2,
        looping = looping or false, scaleX = 1, scaleY = 1, originX = 0, originY = 0
    }

    this = setmetatable(this, SpriteAnimation)
    this:load(frameList)
    return this
end

function SpriteAnimation:load(frameList)
    self.amountFrames = #frameList
    --[[Here will start the circle list for the frames--]]
    local firstFrame = frameList[1]
    local currentFrame = firstFrame
    local frameAfter = frameList[2] or firstFrame
    for index = 3, #frameList, 1 do
        currentFrame.nextFrame = frameAfter
        currentFrame = currentFrame.nextFrame
        frameAfter = frameList[index]
    end
    currentFrame.nextFrame = frameAfter
    frameAfter.nextFrame = firstFrame

    self.firstFrame = firstFrame
    self.currentFrame = firstFrame
end

function SpriteAnimation:resetCurrent()
    self.currentFrame = self.firstFrame
end

function SpriteAnimation:setScale(scaleX, scaleY)
    if scaleX and scaleY then
        self.scaleX, self.scaleY = scaleX, scaleY
    end
end

function SpriteAnimation:setOrigin(originX, originY)
    if originX and originY then
        self.originX, self.originY = originX, originY
    end
end

function SpriteAnimation:setType(looping)
    self.looping = looping or false
end
    
function SpriteAnimation:setDuration(newDuration)
    self.duration = newDuration
end

function SpriteAnimation:isOver()
    return self.currentFrame.nextFrame == self.firstFrame and not self.looping
end

function SpriteAnimation:nextFrame()
    local frameReturned = self.currentFrame
    self.currentFrame = self.currentFrame.nextFrame
    return frameReturned.quad
end

function SpriteAnimation:update(dt)
    if self.currentFrame.nextFrame ~= self.firstFrame or self.looping then
        self.currentTime = self.currentTime + dt
        if self.currentTime >= self.duration then
            self.currentTime = self.currentTime - self.duration
            self:nextFrame()
        end
    else
        self.currentTime = 0
    end
end

function SpriteAnimation:draw(x, y, scaleX, scaleY, originX, originY)
    if self.currentFrame.nextFrame ~= self.firstFrame or self.looping then
        local x = x or 300
        local y = y or 300
        if self.currentFrame.quad then
            love.graphics.draw(self.atlas, self.currentFrame.quad, x, y, 0, scaleX or self.scaleX, scaleY or self.scaleY, originX or self.originX, originY or self.originY)
        end
    end
end

return SpriteAnimation
