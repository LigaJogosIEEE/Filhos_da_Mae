local MainMenuScene = {}; MainMenuScene.__index = MainMenuScene

function MainMenuScene:new()
    local this = setmetatable({
        background = love.graphics.newImage("assets/background.png"),
        logo = love.graphics.newImage("assets/menuLogo.png"),
        buttonManager = gameDirector:getLibrary("ButtonManager"):new("right", "left"),
        buttonsImage = nil, buttonsQuads = nil,
        buttons = {parentName = "mainMenu"},
        elapsedTime = 0
    }, MainMenuScene)
    scaleDimension:calculeScales("menuLogo", this.logo:getWidth(), this.logo:getHeight(), 90, 40)
    scaleDimension:relativeScale("menuLogo", {width = this.logo:getWidth(), height = this.logo:getHeight()})

    local function loadSpriteSheet(filename)
        local spriteSheet = gameDirector:getLibrary("Pixelurite").getSpritesheet():new(filename, "assets/gui/", nil)
        local spriteQuads = spriteSheet:getQuads()
        this.buttonsQuads = {
            normal = spriteQuads["normal"], hover = spriteQuads["hover"],
            pressed = spriteQuads["pressed"], disabled = spriteQuads["disabled"]
        }
        this.buttonsImage = spriteSheet:getAtlas()
        local x, y, width, height = this.buttonsQuads["normal"]:getViewport()
        return {width = width, height = height}
    end
    local originalSize = loadSpriteSheet("play_button")
    gameDirector:addButton(this, this.buttons, 'Start Game', false, "inGame", {300, 70, 140, 550}, originalSize, nil, false)
    local originalSize = loadSpriteSheet("config_button")
    gameDirector:addButton(this, this.buttons, 'Configurations', false, "configurations", {300, 70, 490, 550}, originalSize, nil, false)
    local originalSize = loadSpriteSheet("credits_button")
    gameDirector:addButton(this, this.buttons, 'Credits', false, "credits", {300, 70, 840, 550}, originalSize, nil, false)
    this.buttons.parentName = nil
    local buttonOrder = {"mainMenuStart Game", "mainMenuConfigurations", "mainMenuCredits"}
    for _, buttonName in pairs(buttonOrder) do this.buttonManager:addButton(this.buttons[buttonName]) end

    return this
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
    self.elapsedTime = self.elapsedTime + dt
    if self.elapsedTime >= 10 then
        self.elapsedTime = 0
        sceneDirector:clearStack("waitStart")
    end
    self.buttonManager:update(dt)
end

function MainMenuScene:draw()
    local width, height = love.graphics.getDimensions()
    love.graphics.draw(self.background, 0, 0, 0, 1, 1)
    scales = scaleDimension:getScale("menuLogo")
    love.graphics.draw(self.logo, scales.x, scales.y, 0, scales.relative.x, scales.relative.y)
    self.buttonManager:draw()
end

function MainMenuScene:resize(w, h)
    for index, value in pairs(self.buttons) do
        local scales = scaleDimension:getScale(index)
        value:setXY(scales.x, scales.y)
        value:setDimensions(scales.width, scales.height)
        value:setScale(scales.relative.x, scales.relative.y)
    end
end

return MainMenuScene
