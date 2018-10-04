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

function SpriteSheet:new(jsonSprite, assetsDirectory, jsonDecoder)
    local this = {atlas = nil, quads = {}, origin = nil, filename = (assetsDirectory or "./") .. jsonSprite}
    local file = love.filesystem.read(this.filename)
    local spriteConfigurations = nil
    local atlasInfo = {}
    if file and jsonDecoder then
        assert(type(jsonDecoder) == "function", "Needs a json decoder funtion to work properly")
        atlasInfo = jsonDecoder(file)
    else
        atlasInfo = require(this.filename:gsub("/", "%."):gsub("%.json", ""))
    end
    local imageSize = atlasInfo.meta.size
    local framesInfo = atlasInfo.frames
    local lastKey = nil
    for key, value in pairs(framesInfo) do
        this.quads[key] = love.graphics.newQuad(value.frame.x, value.frame.y, value.frame.w, value.frame.h, imageSize.w, imageSize.h)
        lastKey = key
    end
    local imagePath = (assetsDirectory or "assets/sprites/") .. atlasInfo.meta.image
    local imageData = atlasInfo.meta.image:match("%.dds") and love.image.newCompressedData(imagePath) or imagePath
    this.atlas = love.graphics.newImage(imageData)
    this.atlas:setFilter("nearest")
    this.origin = {w = framesInfo[lastKey].frame.w, h = framesInfo[lastKey].frame.h}
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

function SpriteSheet:getCenterOrigin()
    return self.origin.w / 2, self.origin.h / 2
end

function SpriteSheet:getQuads()
    return self.quads
end

function SpriteSheet:getAtlas()
    return self.atlas
end

return SpriteSheet
