local LevelLoader = {}

LevelLoader.__index = LevelLoader

function LevelLoader:new(tilemapName, path, world)
    assert(world, "Needs a World object")
    assert(tilemapName and path, "filename and path required")
    local this = setmetatable({
        tilemap = gameDirector:getLibrary("sti")(string.format("%s/%s.lua", path, tilemapName), {"box2d"}, 0, 128)
    }, LevelLoader)

    this.tilemap:box2d_init(world)
    return this
end

function LevelLoader:update(dt)
    self.tilemap:update(dt)
end

function LevelLoader:draw()
    love.graphics.translate(-170, -128)
    self.tilemap:draw(-gameDirector:getMainCharacter():getPosition() + 512, 0)
    love.graphics.setColor(1, 0, 0)
	self.tilemap:box2d_draw(0, 0)
    love.graphics.setColor(1, 1, 1)
end

function LevelLoader:resize(h, w)
    self.tilemap:resize(w, h)
end

return LevelLoader
