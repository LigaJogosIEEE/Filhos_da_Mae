local ButtonManager = require "util/GUI/ButtonManager"

local MainMenuScene = {}

MainMenuScene.__index = MainMenuScene

local addButton = function(this, buttonName, sceneName, buttonDimensions)
    scaleDimension:calculeScales("menu" .. buttonName, unpack(buttonDimensions))
    scaleDimension:centralize("menu" .. buttonName, true, false, false)
    local scales = scaleDimension:getScale("menu" .. buttonName)

    --buttonName, x, y, width, height, image, originalImage, animation, 70
    local button = this.buttonManager:addButton(buttonName, scales.x, scales.y, scales.width, scales.height, this.buttonsQuads, this.buttonsImage)
    button.callback = function(this) sceneDirector:setCurrentScene(sceneName) end
end

function MainMenuScene:new()
    local this = {
        background = love.graphics.newImage("assets/background.png"),
        logo = love.graphics.newImage("assets/menuLogo.png"),
        buttonManager = ButtonManager:new(),
        actualScene = "MainMenu",
        buttonsImage = nil,
        buttonsQuads = nil
    }
    scaleDimension:calculeScales("menuBackground", this.background:getWidth(), this.background:getHeight(), 0, 0)
    scaleDimension:calculeScales("menuLogo", 260, 150, 0, 50)
    scaleDimension:centralize("menuLogo", true, false, true)

    local Json = gameDirector:getLibraries("Json")
    local file = love.filesystem.read("assets/gui/buttons.json")
    local buttonSprite = nil
    if file then
        buttonSprite = Json.decode(file)
    end
    local imageSize = buttonSprite.meta.size
    local framesInfo = buttonSprite.frames
    this.buttonsQuads = {
        normal = love.graphics.newQuad(framesInfo.normal.frame.x, framesInfo.normal.frame.y, framesInfo.normal.frame.w, framesInfo.normal.frame.h, imageSize.w, imageSize.h),
        hover = love.graphics.newQuad(framesInfo.hover.frame.x, framesInfo.hover.frame.y, framesInfo.hover.frame.w, framesInfo.hover.frame.h, imageSize.w, imageSize.h),
        pressed = love.graphics.newQuad(framesInfo.pressed.frame.x, framesInfo.pressed.frame.y, framesInfo.pressed.frame.w, framesInfo.pressed.frame.h, imageSize.w, imageSize.h),
        disabled = love.graphics.newQuad(framesInfo.disabled.frame.x, framesInfo.disabled.frame.y, framesInfo.disabled.frame.w, framesInfo.disabled.frame.h, imageSize.w, imageSize.h)
    }
    this.buttonsImage = love.graphics.newImage("assets/gui/" .. buttonSprite.meta.image)

    addButton(this, 'Start Game', "inGame", {128, 60, 350, 320})
    addButton(this, 'Configurations', "configurations", {128, 60, 350, 390})
    addButton(this, 'Credits', "credits", {128, 60, 350, 460})

    return setmetatable(this, MainMenuScene)
end

function MainMenuScene:keypressed(key, scancode, isrepeat)
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
    local directScaleX, directScaleY = scaleDimension:directScale(self.logo:getDimensions()) 
    love.graphics.draw(self.logo, scales.x, scales.y, 0, directScaleX / scales.scaleX, directScaleY / scales.scaleY)
    self.buttonManager:draw()
end

return MainMenuScene
