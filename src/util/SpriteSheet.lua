local Json = require "util.Json";
local Stack = require "util.Stack";

local SpriteSheet = {}

function SpriteSheet:new()
    
    local self = {spriteFrames = {}, firstFrame = nil, currentFrame = nil}
    
    local loadSprite = function(jsonSprite, imageSprite)
        local file = love.filesystem.read(jsonSprite)
        local spriteConfigurations = nil
        if file then
            local frameStack = Stack:new()
            spriteConfigurations = Json.decode(file)
            local frames = spriteConfigurations.frames
            for frameName, frameInfo in pairs(frames) do
                self.spriteFrames[frameName] = {name = frameName, nextFrame = nil, frame = frameInfo.frame}
                frameStack.push(self.spriteFrames[frameName])
            end
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
        return love.graphics.newImage("assets/sprites/Franjostei/Franjostei_Direita.png")
    end
    
    local splitFrame = function()
    end
    
    local setFirst = function(frameName)
        local frameSelected = self.spriteFrames[frameName]
        if frameSelected then
            self.firstFrame = frameSelected
        end
    end
    
    local resetCurrent = function()
        self.currentFrame = self.firstFrame
    end
    
    local nextFrame = function()
    end
    
    return {
        loadSprite = loadSprite;
        setFirst = setFirst;
        resetCurrent = resetCurrent;
        nextFrame = nextFrame;
    }
    
end

return SpriteSheet
