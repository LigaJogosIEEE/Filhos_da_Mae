function love.load()
    --set default constants
    love.graphics.setDefaultFilter('linear', 'linear')
    --Creating Main Controllers
    scaleDimension = require "util.ScaleDimension":new(); scaleDimension:setGameScreenScale(1280, 720)
    gameDirector = require "controllers.GameDirector":new()
    love.graphics.setFont(gameDirector:getFonts().kirbyss)

    local function rescaleImage(image)
        local imageDimension = {width = image:getWidth(), height = image:getHeight()}
        local item = {x = 0, y = 0, scaleX = 1, scaleY = 1, image = image}
        item.x = (love.graphics.getWidth() / 2) - imageDimension.width / 2
        item.y = (love.graphics.getHeight() / 2) - imageDimension.height / 2
        return item
    end
    
    local splashLove2dLogo = rescaleImage(love.graphics.newImage("assets/engine_logo.png"))
    local splashCompany = rescaleImage(love.graphics.newImage("assets/company_logo.png"))

    sceneDirector = gameDirector:getLibrary("MoonJohn").MoonJohn:new(require "scenes.SplashScreen":new(splashCompany, splashLove2dLogo))
    --Adding Scenes to SceneDirector
    local inGame = require "scenes.InGameScene":new(gameDirector:getWorld().world, gameDirector:getAudioController():getSound("music", "game_music"))
    sceneDirector:setDefaultTransition(function() return gameDirector:getLibrary("MoonJohn").Transitions:FadeOut() end)

    --Adding Scenes to SceneDirector
    sceneDirector:addScene("waitStart", require "scenes.WaitStartScene":new())
    sceneDirector:addScene("mainMenu", require "scenes.MainMenuScene":new())
    sceneDirector:addScene("credits", require "scenes.CreditsScene":new(splashCompany))
    sceneDirector:addScene("configurations", require "scenes.ConfigurationScene":new())
    sceneDirector:addScene("inGame", inGame)
    sceneDirector:addSubscene("gameOver", require "scenes.subscenes.GameOver":new())

    local gameWidth, gameHeight = 1280, 720 --fixed game resolution
    local windowWidth, windowHeight = love.window.getDesktopDimensions()
    gameDirector:getLibrary("push"):setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = true, pixelperfect = true})

    local mouseEvents = {mousepressed = true, mousereleased = true}
    local events = {"keypressed", "keyreleased", "mousepressed", "mousereleased", "wheelmoved", "update"}
    for _, event in pairs(events) do
        if mouseEvents[event] then
            love[event] = function(x, y, button)
                local new_x, new_y = gameDirector:getLibrary("push"):toGame(x, y)
                sceneDirector[event](sceneDirector, new_x or -x, new_y or -y, button)
            end
        else
            love[event] = function(...) sceneDirector[event](sceneDirector, ...) end
        end
    end
end

function love.mousemoved(x, y, dx, dy, istouch)
    local new_x, new_y = gameDirector:getLibrary("push"):toGame(x, y)
    new_dx, new_dy = gameDirector:getLibrary("push"):toGame(dx, dy)
    sceneDirector:mousemoved(new_x or -x, new_y or -y, new_dx or -dx, new_dy or -dy, istouch)
end

function love.draw()
    gameDirector:getLibrary("push"):start()
    sceneDirector:draw()
    gameDirector:getLibrary("push"):finish()
end

function love.resize(w, h)
    scaleDimension:screenResize(w, h)
    sceneDirector:resize(w, h)
end
