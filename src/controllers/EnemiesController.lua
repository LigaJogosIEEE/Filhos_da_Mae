local Enemy = require "models.actors.Enemy"

local EnemiesController = {}

EnemiesController.__index = EnemiesController

function EnemiesController:new(world)
    local this = {
        enemies = {},
        world = world.world,
        timeForShot = 1,
        enemiesUserData = {Seu_Barriga = true},
        enemiesFactory = {Seu_Barriga = {colisor = {36, 54}, sprite = nil}}
    }
    
    return setmetatable(this, EnemiesController)
end

function EnemiesController:factory(enemyName)
    local enemyAnimation = {
        left = gameDirector:configureSpriteSheet(enemyName .. ".json", "assets/sprites/" .. enemyName .. "/", true, 0.3, nil, nil, true),
        right = gameDirector:configureSpriteSheet(enemyName .. ".json", "assets/sprites/" .. enemyName .. "/", true, 0.3, nil, nil, true),
        up = gameDirector:configureSpriteSheet(enemyName .. ".json", "assets/sprites/" .. enemyName .. "/", true, 0.3, nil, nil, true),
        down = gameDirector:configureSpriteSheet(enemyName .. ".json", "assets/sprites/" .. enemyName .. "/", true, 0.3, nil, nil, true)    
    }
    return enemyAnimation
end

function EnemiesController:artificialInteligence(actor)
    
end

function EnemiesController:startFactory()
    for key, _ in pairs(self.enemiesUserData) do
        self.enemiesFactory[key].sprite = self:factory(key)
    end
end

function EnemiesController:createEnemy(enemyType, x, y)
    assert(enemyType, "Needs to receive enemyType Parameter")
    local enemy = self.enemiesFactory[enemyType]
    table.insert(self.enemies, Enemy:new(enemy.sprite, self.world, x or 600, y or 500, enemyType, enemy.colisor))
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
