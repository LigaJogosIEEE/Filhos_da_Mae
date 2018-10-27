local SceneDirector = require "controllers.SceneDirector"
local GameDirector = require "controllers.GameDirector"
local ScaleDimension = require "util.ScaleDimension"

function love.load()
    --set default constants
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setNewFont("assets/fonts/kirbyss.ttf", 18)
    --Creating Main Controllers
    scaleDimension = ScaleDimension:new()
    scaleDimension:setGameScreenScale(800, 600)
    gameDirector = GameDirector:new()
    gameDirector:getEnemiesController():startFactory()
    sceneDirector = SceneDirector:new(require "scenes.SplashScreen":new())
    --Adding Scenes to SceneDirector
    sceneDirector:addScene("mainMenu", require "scenes.MainMenuScene":new())
    sceneDirector:addScene("credits", require "scenes.CreditsScene":new())
    sceneDirector:addScene("configurations", require "scenes.ConfigurationScene":new())
    sceneDirector:addScene("inGame", require "scenes.InGameScene":new(gameDirector:getWorld().world))
        sceneDirector:addScene("ConfKeySceneLeft", require "scenes.ConfKeySceneLeft":new())
                sceneDirector:addScene("ConfKeySceneRight", require "scenes.ConfKeySceneRight":new())
        sceneDirector:addScene("ConfKeySceneUp", require "scenes.ConfKeySceneUp":new())
        sceneDirector:addScene("ConfKeySceneDown", require "scenes.ConfKeySceneDown":new())
        sceneDirector:addScene("ConfKeySceneJump", require "scenes.ConfKeySceneJump":new())
        sceneDirector:addScene("ConfKeySceneAtack", require "scenes.ConfKeySceneAtack":new())


end

function love.keypressed(key, scancode, isrepeat)
    sceneDirector:keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key, scancode)
    sceneDirector:keyreleased(key, scancode)
end

function love.mousemoved(x, y, dx, dy, istouch)
    sceneDirector:mousemoved(x, y, dx, dy, istouch)
end

function love.mousepressed(x, y, button)
    sceneDirector:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    sceneDirector:mousereleased(x, y, button)
end

function love.wheelmoved(x, y)
    sceneDirector:wheelmoved(x, y)
end

function love.update(dt)
    sceneDirector:update(dt)
end

function love.draw()
    sceneDirector:draw()
    --love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
end

function love.resize(w, h)
    scaleDimension:screenResize(w, h)
    sceneDirector:resize(w, h)
end
