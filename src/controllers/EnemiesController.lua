local Enemy = require "models.actors.Enemy"

local EnemiesController = {}

EnemiesController.__index = EnemiesController

function EnemiesController:new(world)
    local this = {
        enemies = {},
        world = world.world,
        timeForShot = 1
    }
    
    return setmetatable(this, EnemiesController)
end

function EnemiesController:createEnemies()
    local seuBarrigaSprite = {}
    seuBarrigaSprite.left = gameDirector:configureSpriteSheet("assets/sprites/Seu_Barriga/Seu_Barriga.json", "assets/sprites/Seu_Barriga/Seu_Barriga.png", "infinity", 0.3);
    seuBarrigaSprite.right = gameDirector:configureSpriteSheet("assets/sprites/Seu_Barriga/Seu_Barriga.json", "assets/sprites/Seu_Barriga/Seu_Barriga.png", "infinity", 0.3);
    seuBarrigaSprite.up = gameDirector:configureSpriteSheet("assets/sprites/Seu_Barriga/Seu_Barriga.json", "assets/sprites/Seu_Barriga/Seu_Barriga.png", "infinity", 0.3);
    seuBarrigaSprite.down = gameDirector:configureSpriteSheet("assets/sprites/Seu_Barriga/Seu_Barriga.json", "assets/sprites/Seu_Barriga/Seu_Barriga.png", "infinity", 0.3);
    table.insert(self.enemies, Enemy:new(seuBarrigaSprite, self.world, 600, 0, "Seu_Barriga"))
end

function EnemiesController:update(dt)
    for index, enemy in pairs(self.enemies) do
        enemy:update(dt)
    end
end

function EnemiesController:draw()
    for index, enemy in pairs(self.enemies) do
        enemy:draw()
    end
end

return EnemiesController
