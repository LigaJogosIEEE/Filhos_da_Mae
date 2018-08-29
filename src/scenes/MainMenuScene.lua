local ButtonManager = require "util/ui/ButtonManager"

local MainMenuScene = {}

MainMenuScene.__index = MainMenuScene

local addButton = function(this, buttonName, sceneName, buttonDimensions, originalSize, callback)
    local scaleButtonName = "menu" .. buttonName
    scaleDimension:calculeScales(scaleButtonName, unpack(buttonDimensions))
    scaleDimension:centralize(scaleButtonName, true, false, false)
    scaleDimension:relativeScale(scaleButtonName, originalSize)
    local scales = scaleDimension:getScale(scaleButtonName)

    --buttonName, x, y, width, height, image, originalImage, animation, 70
    local button = this.buttonManager:addButton(buttonName, scales.x, scales.y, scales.width, scales.height, this.buttonsQuads, this.buttonsImage)
    button.callback = callback or function(this) sceneDirector:reset(sceneName); sceneDirector:switchScene(sceneName) end
    button:setScale(scales.relative.x, scales.relative.y)
    
    this.buttonNames[scaleButtonName] = button
end

function MainMenuScene:new()
    local this = {
        background = love.graphics.newImage("assets/background.png"),
        logo = love.graphics.newImage("assets/menuLogo.png"),
        buttonManager = ButtonManager:new(),
        actualScene = "MainMenu",
        buttonsImage = nil,
        buttonsQuads = nil,
        buttonNames = {}
    }
    scaleDimension:calculeScales("menuBackground", this.background:getWidth(), this.background:getHeight(), 0, 0)
    scaleDimension:calculeScales("menuLogo", 150, 110, 0, 50)
    scaleDimension:relativeScale("menuLogo", {width = this.logo:getWidth(), height = this.logo:getHeight()})
    scaleDimension:centralize("menuLogo", true, false, false, false)

    local spriteSheet = gameDirector:getLibrary("SpriteSheet"):new("buttons.json", "assets/gui/")
    local spriteQuads = spriteSheet:getQuads()
    this.buttonsQuads = {
        normal = spriteQuads["normal"],
        hover = spriteQuads["hover"],
        pressed = spriteQuads["pressed"],
        disabled = spriteQuads["disabled"]
    }
    this.buttonsImage = spriteSheet:getAtlas()

    local x, y, width, height = this.buttonsQuads["normal"]:getViewport()
    local originalSize = {width = width, height = height}
    addButton(this, 'Start Game', "inGame", {128, 60, 350, 320}, originalSize)
    addButton(this, 'Configurations', "configurations", {128, 60, 350, 390}, originalSize)
    addButton(this, 'Credits', "credits", {128, 60, 350, 460}, originalSize)

    return setmetatable(this, MainMenuScene)
end

function MainMenuScene:keypressed(key, scancode, isrepeat)
    if key == "escape" then
        love.event.quit()
    end
    self.buttonManager:keypressed(key, scancode, isrepeat)
end

function MainMenuScene:keyreleased(key, scancode)
    self.buttonManager:keyreleased(key, scancode)
end

function MainMenuScene:mousemoved(x, y, dx, dy, istouch)
    self.buttonManager:mousemoved(x, y, dx, dy, istouch)
end

function MainMenuScene:mousepressed(x, y, button)
    self.buttonManager:mousepressed(x, y, button)
end

function MainMenuScene:mousereleased(x, y, button)
    self.buttonManager:mousereleased(x, y, button)
end

function MainMenuScene:wheelmoved(x, y)
end

function MainMenuScene:update(dt)
    self.buttonManager:update(dt)
end

function MainMenuScene:draw()
    local width, height = love.graphics.getDimensions()
    local scales = scaleDimension:getScale("menuBackground")
    love.graphics.draw(self.background, 0, 0, 0, scales.scaleX, scales.scaleY)
    scales = scaleDimension:getScale("menuLogo")
    love.graphics.draw(self.logo, scales.x, scales.y, 0, scales.relative.x, scales.relative.y)
    self.buttonManager:draw()
end

function MainMenuScene:resize(w, h)
    for index, value in pairs(self.buttonNames) do
        local scales = scaleDimension:getScale(index)
        value:setXY(scales.x, scales.y)
        value:setDimensions(scales.width, scales.height)
        value:setScale(scales.relative.x, scales.relative.y)
    end
end

return MainMenuScene
