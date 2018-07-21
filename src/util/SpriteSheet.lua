local Json = require "libs.Json";
local Stack = require "util.Stack";

local SpriteSheet = {}

SpriteSheet.__index = SpriteSheet

function SpriteSheet:__genOrderedIndex(tableToOrder)
    local orderedIndex = {}
    for key in pairs(tableToOrder) do
        table.insert(orderedIndex, key)
    end
    table.sort(orderedIndex)
    return orderedIndex
end

function SpriteSheet:new(jsonSprite, assetsDirectory)
    local this = {atlas = nil, quads = {}}
    local file = love.filesystem.read((assetsDirectory or "./") .. jsonSprite)
    local spriteConfigurations = nil
    if file then
        local atlasInfo = Json.decode(file)
        local imageSize = atlasInfo.meta.size
        local framesInfo = atlasInfo.frames
        for key, value in pairs(framesInfo) do
            this.quads[key] = love.graphics.newQuad(value.frame.x, value.frame.y, value.frame.w, value.frame.h, imageSize.w, imageSize.h)
        end
        this.atlas = love.graphics.newImage((assetsDirectory or "assets/sprites/") .. atlasInfo.meta.image)
    end
    return setmetatable(this, SpriteSheet)
end

function SpriteSheet:getFrames(frameNames)
    local frameOrder = frameNames or self:__genOrderedIndex(self.quads)
    local frameStack = Stack:new()
    local frameList = {}
    for index = 1, #frameOrder, 1 do
        frameName = frameOrder[index]
        local frameInfo = {name = frameName, quad = self.quads[frameName]}
        table.insert(frameList, frameInfo)
        frameStack.push(frameInfo)
    end
    return frameList, frameStack
end

function SpriteSheet:getQuads()
    return self.quads
end

function SpriteSheet:getAtlas()
    return self.atlas
end

return SpriteSheet
