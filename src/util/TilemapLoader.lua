local TilemapLoader = {}

TilemapLoader.__index = TilemapLoader

function TilemapLoader:new(tilemapName, path)
    assert(tilemapName and path, "filename and path required")
    local this = setmetatable({
        tilemap = require(string.format("%s.%s", path:gsub("/", "%."), tilemapName)),
        tileBatch = {},
        tilesets = {},
        quads = {},
        filePath = path
    }, TilemapLoader)

    return this
end

function TilemapLoader:generateQuads(currentId, imageWidth, imageHeight, tilewidth, tileheight)
    local quads = {}
    for vertical = 0, imageHeight, tileheight do
        for horizontal = 0, imageWidth, tilewidth do
            quads[currentId] = love.graphics.newQuad(horizontal, vertical, tilewidth, tileheight, imageWidth, imageHeight)
            self.quads = quads[currentId]
            currentId = currentId + 1
        end
    end
    return quads
end

function TilemapLoader:loadRequiredTiles(tileObject)
    local tileInfo = {
        tilewidth = tileObject.tilewidth,
        tileheight = tileObject.tileheight,
        atlas = love.graphics.newImage(string.format("%s/%s", self.filePath, tileObject.image)),
        quads = self:generateQuads(tileObject.firstgid, tileObject.imagewidth, tileObject.imageheight, tileObject.tilewidth, tileObject.tileheight)
    }
    self.tilesets[tileObject.name] = tileInfo
end

function TilemapLoader:spriteBatchConstruct(sequence)
    for _, layerInfo in pairs(self.tilemap.layers) do
        local completeFrame = {}
        for __, quadIndex in pairs(layerInfo.data) do
            table.insert(completeFrame, self.quads[quadIndex])
        end
        --self.tileBatch[layerInfo.name] = love.graphics.newSpriteBatch(image,maxsprites) --needs to search the specific image
    end
end

function TilemapLoader:parse(renderingLayerSequence)
    for _, tileset in pairs(self.tilemap.tilesets) do
        self:loadRequiredTiles(tileset)
    end
    self:spriteBatchConstruct(renderingLayerSequence)
end

function TilemapLoader:draw()
end

return TilemapLoader
