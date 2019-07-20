--Models
local World = require "models.business.World"
local LevelLoader = require "models.business.LevelLoader"
local LifeForm = require "models.value.LifeForm"

--Entities
local Bullet = require "models.entities.Bullet"
local Player = require "models.entities.Player"

--Libs
local STI = require "libs.Simple-Tiled-Implementation.sti"
local MoonJohn = require "libs.MoonJohn"
local Pixelurite = require "libs.Pixelurite"
local Sanghost = require "libs.Sanghost.Sanghost"

--Controllers
local PlayerController = require "controllers.PlayerController"
local EnemiesController = require "controllers.EnemiesController"
local CameraController = require "controllers.CameraController"

--Gui Components
local Button = require "util.ui.Button"
local ButtonManager = require "util.ui.ButtonManager"
local ProgressBar = require "util.ui.ProgressBar"

local GameDirector = {}; GameDirector.__index = GameDirector

function GameDirector:new()
    local playerAnimation = {}
    for number = 1, 2 do
        local path = string.format("assets/sprites/Player_%d/", number)
        table.insert(playerAnimation, {
            idle = Pixelurite.configureSpriteSheet("Mother_Idle", path, true, nil, 1, 1, true),
            running = Pixelurite.configureSpriteSheet("Mother_Run", path, true, 0.1, 1, 1, true),
            runningDown = Pixelurite.configureSpriteSheet("Mother_Run_Down", path, true, nil, 1, 1, true),
            runningUp = Pixelurite.configureSpriteSheet("Mother_Run_Up", path, true, nil, 1, 1, true),
            down = Pixelurite.configureSpriteSheet("Mother_Idle_Down", path, true, nil, 1, 1, true),
            up = Pixelurite.configureSpriteSheet("Mother_Idle_Up", path, true, nil, 1, 1, true),
            jumping = Pixelurite.configureSpriteSheet("Mother_Jump", path, true, nil, 1, 1, true)
        })
    end

    local world = World:new()
    local this = {
        bulletsInWorld = {}, world = world, lifeBar = ProgressBar:new(20, 20, 200, 40, {1, 0, 0}, 15, 15),
        playerController = PlayerController:new(LifeForm, Player, playerAnimation, world.world), enemiesController = EnemiesController:new(world),
        cameraController = CameraController:new(), sanghost = Sanghost:new(),
        --Libraries
        libraries = {
            LevelLoader = LevelLoader, sti = STI, LifeForm = LifeForm, Button = Button,
            ProgressBar = ProgressBar, Sanghost = Sanghost, ButtonManager = ButtonManager,
            MoonJohn = MoonJohn, Pixelurite = Pixelurite
        },
        fonts = {
            default = love.graphics.getFont(),
            kirbyss = love.graphics.newFont("assets/fonts/kirbyss.ttf", 18),
            tovariSans = love.graphics.newFont("assets/fonts/TovariSans.ttf", 36)
        }
    }

    this.sanghost:save(this.lifeBar, "lifebar")
    return setmetatable(this, GameDirector)
end

function GameDirector:reset()
    self.lifeBar = self.sanghost:load("lifebar"); self.playerController:reset()
end

function GameDirector:addButton(this, buttonList, buttonName, showText, sceneName, buttonDimensions, originalSize, callback, disableButton)
    local scaleButtonName = buttonList.parentName .. buttonName
    scaleDimension:calculeScales(scaleButtonName, unpack(buttonDimensions))
    scaleDimension:relativeScale(scaleButtonName, originalSize)
    local scales = scaleDimension:getScale(scaleButtonName)

    --buttonName, x, y, width, height, image, originalImage, animation, 70
    local button = self.libraries["Button"]:new(showText and buttonName or "", scales.x, scales.y, scales.width, scales.height, this.buttonsQuads, this.buttonsImage)
    button.callback = callback or function(self) sceneDirector:switchScene(sceneName); sceneDirector:reset(sceneName); if this.music then this.music:pause() end; if disableButton then self:disableButton() end end
    button:setScale(scales.relative.x, scales.relative.y)
    
    buttonList[scaleButtonName] = button
end

function GameDirector:loadScene(sceneName, requiredFile)
    sceneDirector:addScene(sceneName, require (requiredFile):new()) --[[ Added sceneName Scene --]]
end

function GameDirector:getLibrary(library) return self.libraries[library] end

function GameDirector:getFonts() return self.fonts end

function GameDirector:addBullet(x, y, orientation, speed, category, fromPlayer)
    if not fromPlayer or (fromPlayer and self.playerController:shot()) then
        table.insert(self.bulletsInWorld, Bullet:new(self.world.world, x, y, orientation, speed, nil, category))
    end
end

function GameDirector:removeBullet(bullet, fixture)
    for index = 1, #self.bulletsInWorld do
        if (bullet and self.bulletsInWorld[index] == bullet) or (fixture and self.bulletsInWorld[index].fixture == fixture) then
            self.bulletsInWorld[index]:destroy(); table.remove(self.bulletsInWorld, index)
            return index
        end
    end
end

function GameDirector:getLifebar() return self.lifeBar end

function GameDirector:getEntityByFixture(fixture)
    if "Player" == fixture:getUserData().name then return self.playerController end
    return self.enemiesController:getEnemyByFixture(fixture)
end

function GameDirector:getPlayer() return self.playerController end
function GameDirector:getLifeBar() return self.lifeBar end
function GameDirector:getCameraController() return self.cameraController end
function GameDirector:getEnemiesController() return self.enemiesController end
function GameDirector:getWorld() return self.world end
function GameDirector:runGame() return self.lifeBar:getValue() > 0 end

function GameDirector:update(dt)
    if not self.playerController:isDead() then
        self.world:update(dt); self.playerController:update(dt); self.enemiesController:update(dt)            
        for index, bullet in pairs(self.bulletsInWorld) do bullet:update(dt) end

        self.cameraController:update(dt)
    else
        --here will call gameOver scene
        sceneDirector:previousScene()
    end
end

function GameDirector:drawBullets()
    for index, bullet in pairs(self.bulletsInWorld) do bullet:draw() end
end

return GameDirector
