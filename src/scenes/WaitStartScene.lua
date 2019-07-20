local WaitStartScene = {}
WaitStartScene.__index = WaitStartScene

function WaitStartScene:new()
    local this = {
        background = love.graphics.newImage("assets/background.png"),
        elapsedTime = 0; alpha = 1; inOut = false
    }

    scaleDimension:calculeScales("menuBackground", this.background:getWidth(), this.background:getHeight(), 0, 0, {width = this.background:getWidth(), height = this.background:getHeight()})
    return setmetatable(this, WaitStartScene)
end

function WaitStartScene:keypressed(key, scancode, isrepeat)
    sceneDirector:clearStack("mainMenu")
end

function WaitStartScene:update(dt)
    self.elapsedTime = self.elapsedTime + dt
    if self.elapsedTime >= 0.08 then
        self.elapsedTime = 0
        self.alpha = self.alpha + (0.1 * (self.inOut and 1 or -1))
        if self.alpha <= 0 then self.inOut = true elseif self.alpha >= 1 then self.inOut = false end
    end
end

function WaitStartScene:draw()
    local scales = scaleDimension:getScale("menuBackground")
    love.graphics.draw(self.background, 0, 0, 0, scales.scaleX, scales.scaleY)
    local red, green, blue, alpha = love.graphics.getColor(); love.graphics.setColor(red, green, blue, self.alpha)
    love.graphics.print("Pressione qualquer tecla para continuar", 100, love.graphics.getHeight() - 100, 0, 2, 2)
    love.graphics.setColor(red, green, blue, alpha)
end

return WaitStartScene
