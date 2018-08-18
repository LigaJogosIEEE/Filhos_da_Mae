--Models
local World = require "models.business.World"
local Ground = require "models.business.Ground"

--Actors
local Bullet = require "models.actors.Bullet"
local MainCharacter = require "models.actors.MainCharacter"

--Util
local SpriteSheet = require "util.SpriteSheet"
local SpriteAnimation = require "util.SpriteAnimation"
local Stack = require "util.Stack"

--Controllers
local CharacterController = require "controllers.CharacterController"
local EnemiesController = require "controllers.EnemiesController"

--Gui Components
local ProgressBar = require "util.ui.ProgressBar"

local GameDirector = {}

GameDirector.__index = GameDirector

function GameDirector:configureSpriteSheet(jsonFile, directory, looping, duration, scaleX, scaleY, centerOrigin)
    local newSprite = SpriteSheet:new(jsonFile, directory)
    local frameTable, frameStack = newSprite:getFrames()
    local newAnimation = SpriteAnimation:new(frameStack, newSprite:getAtlas(), duration)
    if centerOrigin then
        newAnimation:setOrigin(newSprite:getCenterOrigin())
    end
    newAnimation:setType(looping)
    newAnimation:setScale(scaleX, scaleY)
    return newAnimation
end

function GameDirector:new()
    love.physics.setMeter(64)
    
    local mainCharacterAnimation = {}
    mainCharacterAnimation.idle = GameDirector:configureSpriteSheet("Mother_1.json", "assets/sprites/Player/", true, nil, 1, 1, true)
    mainCharacterAnimation.running = GameDirector:configureSpriteSheet("Mother_1.json", "assets/sprites/Player/", true, nil, 1, 1, true)
    mainCharacterAnimation.down = GameDirector:configureSpriteSheet("Mother_1.json", "assets/sprites/Player/", true, nil, 1, 1, true)
    mainCharacterAnimation.up = GameDirector:configureSpriteSheet("Mother_1.json", "assets/sprites/Player/", true, nil, 1, 1, true)
    mainCharacterAnimation.jumping = GameDirector:configureSpriteSheet("Mother_1.json", "assets/sprites/Player/", true, nil, 1, 1, true)

    local LifeForm = require "models.value.LifeForm"
    local world = World:new()
    local this = {
        bulletsInWorld = {},
        world = world,
        ground = Ground:new(world.world, nil, 800, 30, 400, 570),
        mainCharacter = MainCharacter:new(mainCharacterAnimation, world.world),
        characterController = CharacterController:new(LifeForm),
        enemiesController = EnemiesController:new(world),
        gameStatus = "run",
        --Libraries
        libraries = {Json = require "libs.Json", SpriteSheet = SpriteSheet, SpriteAnimation = SpriteAnimation, Stack = Stack, LifeForm = LifeForm}
    }

    return setmetatable(this, GameDirector)
end

function GameDirector:getLibrary(library)
    return self.libraries[library]
end

function GameDirector:keypressed(key, scancode, isrepeat)
    self.mainCharacter:keypressed(key, scancode, isrepeat)
end

function GameDirector:keyreleased(key, scancode)
    self.mainCharacter:keyreleased(key, scancode)
end

function GameDirector:addBullet(x, y, orientation, speed, category, fromPlayer)
    if not fromPlayer or (fromPlayer and self.characterController:shot()) then
        table.insert(self.bulletsInWorld, Bullet:new(self.world.world, x, y, orientation, speed, nil, category))
    end
end

function GameDirector:removeBullet(bullet, fixture)
    for index = 1, #self.bulletsInWorld do
        if (bullet and self.bulletsInWorld[index] == bullet) or (fixture and self.bulletsInWorld[index].fixture == fixture) then
            table.remove(self.bulletsInWorld, index)
            return index
        end
    end
end

function GameDirector:getEntityByFixture(fixture)
    if fixture:getUserData() == "MainCharacter" then
        return self.characterController
    end
    return self.enemiesController:getEnemyByFixture(fixture)
end

function GameDirector:getMainCharacter()
    return self.mainCharacter
end

function GameDirector:update(dt)
    self.mainCharacter:update(dt)
    self.world:update(dt)
    self.enemiesController:update(dt)
    
    for index, bullet in pairs(self.bulletsInWorld) do
        bullet:update(dt)
    end
end

function GameDirector:draw()
    self.mainCharacter:draw()
    self.ground:draw()
    self.enemiesController:draw()
    
    for index, bullet in pairs(self.bulletsInWorld) do
        bullet:draw()
    end
end

return GameDirector
