local LevelLoader = {}

LevelLoader.__index = LevelLoader

function LevelLoader:new(path, world)
    assert(world, "Needs a World object")
    assert(path, "path required")
    local this = setmetatable({
        world = world, levelsPath = path, tilemap = nil, enemiesData = {}
    }, LevelLoader)

    return this
end

function LevelLoader:load(tilemapName)
    assert(tilemapName, "filename required")
    self.tilemap = gameDirector:getLibrary("sti")(string.format("%s/%s.lua", self.levelsPath, tilemapName), {"box2d"}, 0, 128)
    --[[ Here will get the enemies layer and add it to enemies controller --]]
    local billLayer = self.tilemap.layers["boleto"]
    --for _, __ in pairs(billLayer) do print(_, __) end
    --gameDirector:getEnemiesController()
    
    self.tilemap:box2d_init(self.world)
    return self
end

function LevelLoader:update(dt) self.tilemap:update(dt) end

function LevelLoader:draw()
    love.graphics.translate(-494, -400)
    self.tilemap:draw(-gameDirector:getPlayer():getBody():getPosition() + 188, -504)
    love.graphics.setColor(1, 0, 0)
	--self.tilemap:box2d_draw(0, 0)
    love.graphics.setColor(1, 1, 1)
end

function LevelLoader:resize(h, w) self.tilemap:resize(w, h) end

return LevelLoader
