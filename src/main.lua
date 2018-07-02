local MainMenuScene = require "scenes.MainMenuScene"

local World = require "models.business.World"
local Ground = require "models.business.Ground"

local SpriteSheet = require "util.SpriteSheet"
local CharacterController = require "controllers.CharacterController"

function configureSpriteSheet(jsonFile, imageFile, animationType)
    local newSprite = SpriteSheet:new()
    newSprite.loadSprite(jsonFile, imageFile)
    newSprite.splitFrame()
    newSprite.setType(animationType)
    return newSprite
end

function love.keypressed(key, isrepeat)
    if key == "escape" then
        love.event.quit()
    end
end

function love.load()
    love.window.setTitle("Jogo sem Nome do IEEE-UEFS")
    
    --physics configuration
    love.physics.setMeter(64)
    world = World:new()
    ground = Ground:new(world.world)
    mainMenu = MainMenuScene:new()
    
    local mainCharacterSpriteSheet = {}
    mainCharacterSpriteSheet.right = configureSpriteSheet("assets/sprites/Franjostei/Franjostei_Direita.json", "assets/sprites/Franjostei/Franjostei_Direita.png", "infinity")
    mainCharacterSpriteSheet.left = configureSpriteSheet("assets/sprites/Franjostei/Franjostei_Esquerda.json", "assets/sprites/Franjostei/Franjostei_Esquerda.png", "infinity")
    mainCharacterSpriteSheet.down = configureSpriteSheet("assets/sprites/Franjostei/Franjostei_Frente.json", "assets/sprites/Franjostei/Franjostei_Frente.png", "infinity")
    mainCharacterSpriteSheet.up = configureSpriteSheet("assets/sprites/Franjostei/Franjostei_Costas.json", "assets/sprites/Franjostei/Franjostei_Costas.png", "infinity")
    character = CharacterController:new(mainCharacterSpriteSheet, world.world)
end

function love.update(dt)
    character:update(dt)
    world:update(dt)
end

function love.draw()
    --mainMenu:draw()
    character:draw()
    ground:draw()
end
