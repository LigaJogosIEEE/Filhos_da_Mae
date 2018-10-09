local Enemy = require "models.actors.Enemy"

local EnemiesController = {}

EnemiesController.__index = EnemiesController

function EnemiesController:new(world)
    local this = {
        enemies = {},
        ai = {types = {
            Bill = require "models.business.enemies_ai.BillAi",
            Seu_Barriga = require "models.business.enemies_ai.SeuBarrigaAi"
        }},
        world = world.world,
        enemiesUserData = {
            Bill = true,
            --Seu_Barriga = true
        },
        enemiesFactory = {
            Seu_Barriga = {colisor = {36, 54}, sprite = nil, category = {body = 4, bullet = 4}},
            Bill = {colisor = {16}, sprite = nil, category = {body = 3, bullet = 4}}
        }
    }
    
    return setmetatable(this, EnemiesController)
end

function EnemiesController:factory(enemyName)
    local enemyAnimation = {
        idle = gameDirector:configureSpriteSheet(enemyName .. "_Idle.json", "assets/sprites/" .. enemyName .. "/", true, 0.3, nil, nil, true),
        running = gameDirector:configureSpriteSheet(enemyName .. "_Running.json", "assets/sprites/" .. enemyName .. "/", true, 0.2, nil, nil, true),
        up = gameDirector:configureSpriteSheet(enemyName .. "_Idle.json", "assets/sprites/" .. enemyName .. "/", true, 0.3, nil, nil, true),
        down = gameDirector:configureSpriteSheet(enemyName .. "_Idle.json", "assets/sprites/" .. enemyName .. "/", true, 0.3, nil, nil, true)    
    }
    return enemyAnimation
end

function EnemiesController:startFactory()
    for key, _ in pairs(self.enemiesUserData) do
        self.enemiesFactory[key].sprite = self:factory(key)
    end
end

function EnemiesController:clearEnemies()
    for _, enemy in pairs(self.enemies) do
        enemy:destroy()
    end
    self.enemies = {}
end

function EnemiesController:createEnemy(enemyType, x, y)
    assert(enemyType, "Needs to receive enemyType Parameter")
    local enemyConfig = self.enemiesFactory[enemyType]
    local enemy = Enemy:new(enemyConfig.sprite, self.world, x or 600, y or 500, enemyType, enemyConfig.colisor, enemyConfig.category.body, enemyConfig.category.bullet)
    table.insert(self.enemies, enemy)
    self.ai[enemy] = self.ai.types[enemyType]:new(enemy)
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
            self.ai[enemy] = nil
            return true
        end
    end
end

function EnemiesController:update(dt)
    for index, enemy in pairs(self.enemies) do
        self.ai[enemy]:update(dt)
        enemy:update(dt)
    end
end

function EnemiesController:draw()
    for index, enemy in pairs(self.enemies) do
        enemy:draw()
    end
end

return EnemiesController
