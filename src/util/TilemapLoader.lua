local TilemapLoader = {}

TilemapLoader.__index = TilemapLoader

function TilemapLoader:new(tilemapName, path)
    assert(tilemapName and path, "filename and path required")
    local this = setmetatable({
        tilemap = require(string.format("%s/%s", path, tilemapName)),
        tilesetBatch = {},
        tilesetsImages = {},
        filePath = path
    }, TilemapLoader)

    return this
end

function TilemapLoader:loadRequiredTiles(tileObject)
    self.tilesetsImages[tileObject.name] = love.graphics.newImage(string.format("%s/%s", self.filePath, tileObject.image))
    
end

function TilemapLoader:parse(tileObject)

end

function TilemapLoader:load()
end

return TilemapLoader
