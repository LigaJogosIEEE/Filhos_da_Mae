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
    --[[ Here will get the enemies layer and add it to enemies controller --]]
    self:getTilePosition(self.tilemap.layers["enemies"].objects); self.tilemap:removeLayer("enemies")
    self:generateEnemies(); self.tilemap:box2d_init(self.world)
    return self
end

function LevelLoader:update(dt) self.tilemap:update(dt) end

function LevelLoader:draw()
    love.graphics.translate(-128, 0)
    local x, y = gameDirector:getCameraController():getPosition()
    local defaultY = (-1064 + 320)
    y = (y < 580 and -260 or (y < 1064 and (-y + 320) or defaultY))
    self.tilemap:draw(-x < -130 and (-x > -10400 and (-x + 218) or -10400) or -130, y, 2, 2)
    --[[love.graphics.setColor(1, 0, 0); self.tilemap:box2d_draw(0, 0); love.graphics.setColor(1, 1, 1) --]]
end

function LevelLoader:resize(h, w) self.tilemap:resize(w, h) end

return LevelLoader
