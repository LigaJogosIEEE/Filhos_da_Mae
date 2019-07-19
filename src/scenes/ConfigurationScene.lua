local ConfigurationScene = {}

ConfigurationScene.__index = ConfigurationScene

function ConfigurationScene:new()
    local this = setmetatable({
        buttonManager = gameDirector:getLibrary("ButtonManager"):new(),
        buttons = {parentName = "configurationScene"}, buttonsQuads = nil,
        buttonNames = {}
    }, ConfigurationScene)

    sceneDirector:addSubscene("configureKey", require "scenes.subscenes.ConfigureKey":new())

    local spriteSheet = gameDirector:getLibrary("Pixelurite").getSpritesheet():new("buttons", "assets/gui/", nil)
    local spriteQuads = spriteSheet:getQuads()
    this.buttonsQuads = {
        normal = spriteQuads["normal"], hover = spriteQuads["hover"],
        pressed = spriteQuads["pressed"], disabled = spriteQuads["disabled"]
    }
    this.buttonsImage = spriteSheet:getAtlas()

    local x, y, width, height = this.buttonsQuads["normal"]:getViewport()
    local originalSize = {width = width, height = height}
   
    gameDirector:addButton(this, this.buttons, 'Move Left', true, "left", {128, 60, 350, 90}, originalSize, function(self) sceneDirector:switchSubscene("configureKey", "left") end, false)
    gameDirector:addButton(this, this.buttons, 'Move Right', true, "right", {128, 60, 350, 160}, originalSize, function(self) sceneDirector:switchSubscene("configureKey", "right") end, false)
    gameDirector:addButton(this, this.buttons, 'Move Up', true, "up", {128, 60, 350, 230}, originalSize, function(self) sceneDirector:switchSubscene("configureKey", "up") end, false)
    gameDirector:addButton(this, this.buttons, 'Move Down', true, "down", {128, 60, 350, 300}, originalSize, function(self) sceneDirector:switchSubscene("configureKey", "down") end, false)
    gameDirector:addButton(this, this.buttons, 'Jump', true, "jump", {128, 60, 350, 370}, originalSize, function(self) sceneDirector:switchSubscene("configureKey", "jump") end, false)
    gameDirector:addButton(this, this.buttons, 'Attack', true, "shot", {128, 60, 350, 440}, originalSize, function(self) sceneDirector:switchSubscene("configureKey", "shot") end, false)
    this.buttons.parentName = nil

    for _, button in pairs(this.buttons) do this.buttonManager:addButton(button) end

    return this
end

function ConfigurationScene:keypressed(key, scancode, isrepeat)
    if key == "escape" then
        sceneDirector:previousScene()
    end
    self.buttonManager:keypressed(key, scancode, isrepeat)
end

function ConfigurationScene:keyreleased(key, scancode)
    self.buttonManager:keyreleased(key, scancode)
end

function ConfigurationScene:mousemoved(x, y, dx, dy, istouch)
    self.buttonManager:mousemoved(x, y, dx, dy, istouch)
end

function ConfigurationScene:mousepressed(x, y, button)
    self.buttonManager:mousepressed(x, y, button)
end

function ConfigurationScene:mousereleased(x, y, button)
    self.buttonManager:mousereleased(x, y, button)
end

function ConfigurationScene:wheelmoved(x, y)
end

function ConfigurationScene:update(dt)
    self.buttonManager:update(dt)
end

function ConfigurationScene:draw()
    self.buttonManager:draw()
end

function ConfigurationScene:resize(w, h)
    for index, value in pairs(self.buttonNames) do
        local scales = scaleDimension:getScale(index)
        value:setXY(scales.x, scales.y)
        value:setDimensions(scales.width, scales.height)
        value:setScale(scales.relative.x, scales.relative.y)
    end
end

return ConfigurationScene
