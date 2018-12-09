local WaitStartScene = {}
WaitStartScene.__index = WaitStartScene

function WaitStartScene:new()
    local this = {
        background = love.graphics.newImage("assets/background.png"),
        elapsedTime = 0
    }

    scaleDimension:calculeScales("menuBackground", this.background:getWidth(), this.background:getHeight(), 0, 0)
    return setmetatable(this, WaitStartScene)
end

function WaitStartScene:keypressed(key, scancode, isrepeat)
    self.elapsedTime = 0
    sceneDirector:clearStack("mainMenu")
end

function WaitStartScene:update(dt)
    self.elapsedTime = self.elapsedTime + dt
end

function WaitStartScene:draw()
    local scales = scaleDimension:getScale("menuBackground")
    love.graphics.draw(self.background, 0, 0, 0, scales.scaleX, scales.scaleY)
    love.graphics.print("Pressione qualquer tecla para continuar", 100, love.graphics.getHeight() - 100, 0, 2, 2)
end

return WaitStartScene
