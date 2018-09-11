--Models
local World = require "models.business.World"
local GameState = require "models.business.GameState"

--Actors
local Bullet = require "models.actors.Bullet"
local MainCharacter = require "models.actors.MainCharacter"

--Libs
local Json = require "libs.Json"

--Util
local SpriteSheet = require "util.SpriteSheet"
local SpriteAnimation = require "util.SpriteAnimation"
local Stack = require "util.Stack"
local TilemapLoader = require "util.TilemapLoader"

--Controllers
local CharacterController = require "controllers.CharacterController"
local EnemiesController = require "controllers.EnemiesController"
local CameraController = require "controllers.CameraController"

--Gui Components
local ProgressBar = require "util.ui.ProgressBar"

local GameDirector = {}

GameDirector.__index = GameDirector

function GameDirector:configureSpriteSheet(jsonFile, directory, looping, duration, scaleX, scaleY, centerOrigin)
    local newSprite = SpriteSheet:new(jsonFile, directory, Json.decode)
    local frameTable, frameStack = newSprite:getFrames()
    local newAnimation = SpriteAnimation:new(frameTable, newSprite:getAtlas(), duration)
    if centerOrigin then
        newAnimation:setOrigin(newSprite:getCenterOrigin())
    end
    newAnimation:setType(looping)
    newAnimation:setScale(scaleX, scaleY)
    return newAnimation
end

function GameDirector:new()
    
    local mainCharacterAnimation = {
        idle = GameDirector:configureSpriteSheet("Mother_1_idle.json", "assets/sprites/Player/", true, nil, 1, 1, true),
        running = GameDirector:configureSpriteSheet("Mother_1_Run.json", "assets/sprites/Player/", true, 0.1, 1, 1, true),
        runningDown = GameDirector:configureSpriteSheet("Mother_1_Run_Down.json", "assets/sprites/Player/", true, nil, 1, 1, true),
        runningUp = GameDirector:configureSpriteSheet("Mother_1_Run_Up.json", "assets/sprites/Player/", true, nil, 1, 1, true),
        down = GameDirector:configureSpriteSheet("Mother_1_Idle_Down.json", "assets/sprites/Player/", true, nil, 1, 1, true),
        up = GameDirector:configureSpriteSheet("Mother_1_Idle_Up.json", "assets/sprites/Player/", true, nil, 1, 1, true),
        jumping = GameDirector:configureSpriteSheet("Mother_1_Jump.json", "assets/sprites/Player/", true, nil, 1, 1, true)
    }

    local LifeForm = require "models.value.LifeForm"
    local world = World:new()
    local this = {
        elapsedTime = 0,
        bulletsInWorld = {},
        world = world,
        mainCharacter = MainCharacter:new(mainCharacterAnimation, world.world),
        lifeBar = ProgressBar:new(20, 20, 200, 40, {1, 0, 0}, 15, 15),
        characterController = CharacterController:new(LifeForm),
        enemiesController = EnemiesController:new(world),
        cameraController = CameraController:new(),
        gameState = GameState:new(),
        --Libraries
        libraries = {
            Json = Json, SpriteSheet = SpriteSheet, TilemapLoader = TilemapLoader,
            SpriteAnimation = SpriteAnimation, Stack = Stack, LifeForm = LifeForm,
            ProgressBar = ProgressBar, GameState = GameState
        }
    }

    this.gameState:save(this.characterController, "characterController")
    this.gameState:save(this.lifeBar, "lifebar")
    return setmetatable(this, GameDirector)
end

function GameDirector:reset()
    self.lifeBar = self.gameState:load("lifebar")
    self.characterController = self.gameState:load("characterController")
    self.mainCharacter:reset()
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
            self.bulletsInWorld[index]:destroy()
            table.remove(self.bulletsInWorld, index)
            return index
        end
    end
end

function GameDirector:updateLifebar(amount, decrease)
    if decrease then
        self.lifeBar:decrement(amount)
    else
        self.lifeBar:increment(amount)
    end
end

function GameDirector:getEntityByFixture(fixture)
    if fixture:getUserData() == "MainCharacter" then
        return self.characterController
    end
    return self.enemiesController:getEnemyByFixture(fixture)
end

function GameDirector:getMainCharacter()
    return self.mainCharacter, self.characterController
end

function GameDirector:getLifeBar()
    return self.lifeBar
end

function GameDirector:getCameraController()
    return self.cameraController
end

function GameDirector:getEnemiesController()
    return self.enemiesController
end

function GameDirector:getWorld()
    return self.world
end

function GameDirector:runGame()
    return self.elapsedTime > 0.01 and self.lifeBar:getValue() > 0
end

function GameDirector:update(dt)
    self.elapsedTime = self.elapsedTime + dt
    if self.elapsedTime > 0.01 then
        if self.lifeBar:getValue() > 0 then
            self.world:update(dt)
            self.mainCharacter:update(dt)
            self.enemiesController:update(dt)            
            for index, bullet in pairs(self.bulletsInWorld) do
                bullet:update(dt)
            end

            self.cameraController:update(dt)
        else
            --here will call gameOver scene
            sceneDirector:previousScene()
        end
    end
    self.elapsedTime = 0
end

function GameDirector:drawBullets()
    for index, bullet in pairs(self.bulletsInWorld) do
        bullet:draw()
    end
end

function GameDirector:draw()
    
end

return GameDirector
