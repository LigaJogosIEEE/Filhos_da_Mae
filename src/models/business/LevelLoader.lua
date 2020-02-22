local LevelLoader = {}

LevelLoader.__index = LevelLoader

function LevelLoader:new(path, world)
    assert(world, "Needs a World object")
    assert(path, "path required")
    local this = setmetatable({
        world = world, levelsPath = path, tilemap = nil, enemiesData = {
            bill = {}, seuBarriga = {}, motocycle = {}
        }
    }, LevelLoader)

    return this
end

function LevelLoader:getTilePosition(objects)
    self.enemiesData.bill = {}; self.enemiesData.seuBarriga = {}; self.enemiesData.motocycle = {}
    for _, object in pairs(objects) do
        if "bill" == object.properties.name then table.insert(self.enemiesData.bill, {x = object.x, y = object.y})
        elseif "Seu_Barriga" == object.properties.name then table.insert(self.enemiesData.seuBarriga, {x = object.x, y = object.y})
        elseif "motocycle" == object.properties.name then table.insert(self.enemiesData.motocycle, {x = object.x, y = object.y})
        end
    end
end

function LevelLoader:generateEnemiesByType(enemyName, enemyType)
    for _, position in pairs(self.enemiesData[enemyName]) do
        gameDirector:getEnemiesController():createEnemy(enemyType, position.x, position.y - 80)
    end
end

function LevelLoader:generateEnemies()
    self:generateEnemiesByType("bill", "Bill")
    self:generateEnemiesByType("seuBarriga", "Seu_Barriga")
    self:generateEnemiesByType("motocycle", "Two_Guys_In_a_Bike")
end

function LevelLoader:load(tilemapName)
    assert(tilemapName, "filename required")
    self.tilemap = gameDirector:getLibrary("sti")(string.format("%s/%s.lua", self.levelsPath, tilemapName), {"box2d"}, 0, 128)
    for _, tileset in ipairs(self.tilemap.tilesets) do tileset.image:setFilter("nearest", "nearest") end
    --[[ Here will get the enemies layer and add it to enemies controller --]]
    self:getTilePosition(self.tilemap.layers["enemies"].objects); self.tilemap:removeLayer("enemies")
    self:generateEnemies(); self.tilemap:box2d_init(self.world)
    return self
end

function LevelLoader:update(dt) self.tilemap:update(dt) end

function LevelLoader:draw()
    --[[ Draw layers directly to keep STI offsets and the camera transform --]]
    love.graphics.push()
    love.graphics.translate(0, 128)
    for _, layer in ipairs(self.tilemap.layers) do
        if layer.visible and layer.opacity > 0 then self.tilemap:drawLayer(layer) end
    end
    love.graphics.pop()
    if self.isDebug then
        love.graphics.setColor(1, 0, 0, 0.6)
        self.tilemap:box2d_draw(0, 0)
        love.graphics.setColor(1, 1, 1, 1)
    end
end

function LevelLoader:resize(h, w) self.tilemap:resize(w, h) end

return LevelLoader
