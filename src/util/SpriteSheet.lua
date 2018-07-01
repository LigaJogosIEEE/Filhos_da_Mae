local Json = require "libs.Json";
local Stack = require "util.Stack";

local SpriteSheet = {}
SpriteSheet.__index = SpriteSheet

function SpriteSheet:new(duration)
    local duration = duration or 0.2
    local execution = "infinity"
    
    local self = {spriteFrames = {}, firstFrame = nil, currentFrame = nil, amountFrames = 0, completeSpriteSheet = nil, currentTime = 0, duration = duration, execution = execution}
    
    local __genOrderedIndex = function(tableToOrder)
        local orderedIndex = {}
        for key in pairs(tableToOrder) do
            table.insert(orderedIndex, key)
        end
        table.sort(orderedIndex)
        return orderedIndex
    end
    
    local loadSprite = function(jsonSprite, imageSprite)
        local file = love.filesystem.read(jsonSprite)
        local spriteConfigurations = nil
        if file then
            local frameStack = Stack:new()
            spriteConfigurations = Json.decode(file)
            local frames = spriteConfigurations.frames
            local orderedIndex = __genOrderedIndex(frames)
            for index = 1, #orderedIndex, 1 do
                frameName = orderedIndex[index]
                frameInfo = frames[frameName]
                self.spriteFrames[frameName] = {name = frameName, nextFrame = nil, frameInfo = frameInfo.frame, quad = nil}
                frameStack.push(self.spriteFrames[frameName])
            end
            self.amountFrames = frameStack.size()
            --[[Here will start the circle list for the frames--]]
            local firstFrame = frameStack.pop()
            local currentFrame = firstFrame
            local frameAfter = frameStack.pop()
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
        self.completeSpriteSheet = love.graphics.newImage(imageSprite)
    end
    
    local splitFrame = function()
        local currentFrame = self.currentFrame
        for count = 1, self.amountFrames + 1, 1 do
            local frameInfo = currentFrame.frameInfo
            local x, y, width, height = frameInfo.x, frameInfo.y, frameInfo.w, frameInfo.h
            currentFrame.quad = love.graphics.newQuad(x, y, width, height, self.completeSpriteSheet:getDimensions())
            currentFrame = currentFrame.nextFrame
        end
    end
    
    local setFirst = function(frameName)
        local frameSelected = self.spriteFrames[frameName]
        if frameSelected then
            self.firstFrame = frameSelected
        end
    end
    
    local setDuration = function(newDuration)
        self.duration = newDuration
    end
    
    local setType = function(execution)
        if execution == "infinity" or "once" then
            self.execution = execution
        end
    end
    
    local resetCurrent = function()
        self.currentFrame = self.firstFrame
    end
    
    local nextFrame = function()
        local frameReturned = self.currentFrame
        self.currentFrame = self.currentFrame.nextFrame
        return frameReturned.quad
    end
    
    local update = function(dt)
        if self.currentFrame.nextFrame ~= self.firstFrame or self.execution == "infinity" then
            self.currentTime = self.currentTime + dt
            if self.currentTime >= self.duration then
                self.currentTime = self.currentTime - self.duration
                nextFrame()
            end
        else
            self.currentTime = 0
        end
    end
    
    local draw = function(x, y)
        if self.currentFrame.nextFrame ~= self.firstFrame or self.execution == "infinity" then
            x = x or 300
            y = y or 300
            if self.currentFrame.quad then
                love.graphics.draw(self.completeSpriteSheet, self.currentFrame.quad, x, y)
            end
        end
    end
    
    return {
        loadSprite = loadSprite;
        splitFrame = splitFrame;
        setFirst = setFirst;
        setDuration = setDuration;
        setType = setType;
        resetCurrent = resetCurrent;
        nextFrame = nextFrame;
        update = update;
        draw = draw;
    }
    
end

return SpriteSheet
