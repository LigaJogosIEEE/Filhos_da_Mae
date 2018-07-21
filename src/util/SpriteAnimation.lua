local SpriteAnimation = {}

SpriteAnimation.__index = SpriteAnimation

function SpriteAnimation:new(frameStack, atlas, duration, execution)
    local this = {
        firstFrame = nil, currentFrame = nil, amountFrames = 0,
        atlas = atlas, currentTime = 0, duration = duration or 0.2,
        execution = execution or "infinity", scaleX = 1, scaleY = 1
    }

    this = setmetatable(this, SpriteAnimation)
    this:load(frameStack)
    return this
end

function SpriteAnimation:load(frameStack)
    self.amountFrames = frameStack.size()
    --[[Here will start the circle list for the frames--]]
    local firstFrame = frameStack.pop()
    local currentFrame = firstFrame
    local frameAfter = frameStack.pop() or firstFrame
    while not frameStack.isEmpty() do
        currentFrame.nextFrame = frameAfter
        currentFrame = currentFrame.nextFrame
        frameAfter = frameStack.pop()
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
        self.scaleX = scaleX
        self.scaleY = scaleY
    end
end

function SpriteAnimation:setType(type)
    if type == "infinity" or "once" then
        self.type = type
    end
end
    
function SpriteAnimation:setDuration(newDuration)
    self.duration = newDuration
end

function SpriteAnimation:nextFrame()
    local frameReturned = self.currentFrame
    self.currentFrame = self.currentFrame.nextFrame
    return frameReturned.quad
end

function SpriteAnimation:update(dt)
    if self.currentFrame.nextFrame ~= self.firstFrame or self.execution == "infinity" then
        self.currentTime = self.currentTime + dt
        if self.currentTime >= self.duration then
            self.currentTime = self.currentTime - self.duration
            self:nextFrame()
        end
    else
        self.currentTime = 0
    end
end

function SpriteAnimation:draw(x, y, scaleX, scaleY)
    if self.currentFrame.nextFrame ~= self.firstFrame or self.execution == "infinity" then
        local x = x or 300
        local y = y or 300
        if self.currentFrame.quad then
            love.graphics.draw(self.atlas, self.currentFrame.quad, x, y, 0, scaleX or self.scaleX, scaleY or self.scaleY)
        end
    end
end

return SpriteAnimation
