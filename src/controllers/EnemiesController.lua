local Enemy = require "models.actors.Enemy"

local EnemiesController = {}

EnemiesController.__index = EnemiesController

function EnemiesController:new(world)
    local this = {
        enemies = {},
        world = world.world,
        timeForShot = 1,
        enemiesUserData = {["Seu_Barriga"] = true}
    }
    
    return setmetatable(this, EnemiesController)
end

function EnemiesController:artificialInteligence(actor)
    
end

function EnemiesController:createEnemies()
    local seuBarrigaSprite = {}
    seuBarrigaSprite.left = gameDirector:configureSpriteSheet("Seu_Barriga.json", "assets/sprites/Seu_Barriga/", true, 0.3, nil, nil, true);
    seuBarrigaSprite.right = gameDirector:configureSpriteSheet("Seu_Barriga.json", "assets/sprites/Seu_Barriga/", true, 0.3, nil, nil, true);
    seuBarrigaSprite.up = gameDirector:configureSpriteSheet("Seu_Barriga.json", "assets/sprites/Seu_Barriga/", true, 0.3, nil, nil, true);
    seuBarrigaSprite.down = gameDirector:configureSpriteSheet("Seu_Barriga.json", "assets/sprites/Seu_Barriga/", true, 0.3, nil, nil, true);
    table.insert(self.enemies, Enemy:new(seuBarrigaSprite, self.world, 600, 0, "Seu_Barriga"))
end

function EnemiesController:getEnemyByFixture(fixture)
    if self.enemiesUserData[fixture:getUserData()] then
        for _, enemy in pairs(self.enemies) do
            if enemy:compareFixture(fixture) then
                return enemy
            end
        end
    end
    return nil
end

function EnemiesController:remove(enemy)
    for index = 1, #self.enemies do
        if self.enemies[index] == enemy then
            table.remove(self.enemies, index)
            return true
        end
    end
end

function EnemiesController:update(dt)
    for index, enemy in pairs(self.enemies) do
        self:artificialInteligence(enemy)
        enemy:update(dt)
    end
end

function EnemiesController:draw()
    for index, enemy in pairs(self.enemies) do
        enemy:draw()
    end
end

return EnemiesController
