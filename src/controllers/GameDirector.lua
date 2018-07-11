local MainMenuScene = require "scenes.MainMenuScene"

--Models
local World = require "models.business.World"
local Ground = require "models.business.Ground"

--Actors
local Bullet = require "models.actors.Bullet"

--Util
local SpriteSheet = require "util.SpriteSheet"

--Controllers
local CharacterController = require "controllers.CharacterController"

local GameDirector = {}

GameDirector.__index = GameDirector

local configureSpriteSheet = function(jsonFile, imageFile, animationType)
    local newSprite = SpriteSheet:new()
    newSprite.loadSprite(jsonFile, imageFile)
    newSprite.splitFrame()
    newSprite.setType(animationType)
    return newSprite
end

function GameDirector:new()
    love.physics.setMeter(64)
    
    local mainCharacterSpriteSheet = {}
    mainCharacterSpriteSheet.right = configureSpriteSheet("assets/sprites/Franjostei/Franjostei_Direita.json", "assets/sprites/Franjostei/Franjostei_Direita.png", "infinity")
    mainCharacterSpriteSheet.left = configureSpriteSheet("assets/sprites/Franjostei/Franjostei_Esquerda.json", "assets/sprites/Franjostei/Franjostei_Esquerda.png", "infinity")
    mainCharacterSpriteSheet.down = configureSpriteSheet("assets/sprites/Franjostei/Franjostei_Frente.json", "assets/sprites/Franjostei/Franjostei_Frente.png", "infinity")
    mainCharacterSpriteSheet.up = configureSpriteSheet("assets/sprites/Franjostei/Franjostei_Costas.json", "assets/sprites/Franjostei/Franjostei_Costas.png", "infinity")
    
    local world = World:new()
    this = {
        bulletsInWorld = {},
        world = world,
        ground = Ground:new(world.world),
        mainMenu = MainMenuScene:new(),
        mainCharacter = CharacterController:new(mainCharacterSpriteSheet, world.world),
        gameStatus = "paused"
    }
    
    return setmetatable(this, GameDirector)
end

function GameDirector:keypressed(key, scancode, isrepeat)
    self.mainCharacter:keypressed(key, scancode, isrepeat)
end

function GameDirector:keyreleased(key, scancode)
    self.mainCharacter:keyreleased(key, scancode)
end

function GameDirector:addBullet(x, y, orientation, speed)
    table.insert(self.bulletsInWorld, Bullet:new(self.world.world, x, y, orientation, speed))
end

function GameDirector:getMainCharacter()
    return self.mainCharacter
end

function GameDirector:update(dt)
    self.mainCharacter:update(dt)
    self.world:update(dt)
    
    for index, bullet in pairs(self.bulletsInWorld) do
        bullet:update(dt)
    end
end

function GameDirector:draw()
    self.mainCharacter:draw()
    self.ground:draw()
    
    for index, bullet in pairs(self.bulletsInWorld) do
        bullet:draw(dt)
    end
end

return GameDirector
