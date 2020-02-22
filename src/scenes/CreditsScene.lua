local CreditsScene = {}
CreditsScene.__index = CreditsScene

function CreditsScene:new(splashCompany)
    local this = {
        variableNames = {mechanics = "Mechanics Programmers", gameDesign = "Game Designers",
        graphicalDesigners = "Graphical Designers", levelDesign = "Level Designers", enemyAi = "Enemies AI"},
        mechanics = {"Jictyvoo - João Victor Oliveira Couto"},
        enemyAi = {"Antônio Crispin", "João Victor Oliveira Couto"},
        gameDesign = {"João Victor Oliveira Couto"},
        graphicalDesigners = {enemies = "Lucas Silva Lima", player = "Manuella Vieira", gui = "Lokisley"},
        levelDesign = {"João Victor Oliveira Couto", "Lokisley Oliveira", "Manuella Vieira"},
        splashCompany = splashCompany,
        y = scaleDimension.gameScreenScale.height,
        lineHeight = 20, groupSpacing = 15, logoSpacing = 30,
        speed = 1,
        finalY = scaleDimension.gameScreenScale.height
    }

    this.groupOrder = {"mechanics", "enemyAi", "gameDesign", "graphicalDesigners", "levelDesign"}
    this.graphicalOrder = {"enemies", "player", "gui"}
    this.height = this.logoSpacing + this.splashCompany.image:getHeight() * this.splashCompany.scaleY
    for _, name in ipairs(this.groupOrder) do
        local count = name == "graphicalDesigners" and #this.graphicalOrder or #this[name]
        this.height = this.height + this.lineHeight + count * this.lineHeight + this.groupSpacing
    end
    this.finalY = this.y + this.height
    return setmetatable(this, CreditsScene)
end

function CreditsScene:reset()
    self.y = scaleDimension.gameScreenScale.height; self.finalY = self.y + self.height; self.speed = 1
end

function CreditsScene:keypressed(key, scancode, isrepeat)
    if key == "escape" then
        sceneDirector:previousScene()
    elseif key == "space" then
        self.speed = 4
    end
end

function CreditsScene:keyreleased(key, scancode)
    if key == "space" then
        self.speed = 1
    end
end

function CreditsScene:update(dt)
    self.y = self.y - self.speed * 60 * dt
    self.finalY = self.y + self.height
    if self.finalY <= 0 then
        sceneDirector:previousScene()
    end
end

function CreditsScene:draw()
    local y = self.y
    local x = (scaleDimension.gameScreenScale.width / 2) - 200
    for _, index in ipairs(self.groupOrder) do
        local value = self.variableNames[index]
        love.graphics.printf(value, x, y, 400, "left")
        y = y + self.lineHeight
        local order = index == "graphicalDesigners" and self.graphicalOrder or self[index]
        for _, entry in ipairs(order) do
            local name = index == "graphicalDesigners" and self[index][entry] or entry
            love.graphics.printf(name, x, y, 400, "center")
            y = y + self.lineHeight
        end
        y = y + self.groupSpacing
    end
    y = y + self.logoSpacing
    love.graphics.draw(self.splashCompany.image, self.splashCompany.x, y, 0, self.splashCompany.scaleX, self.splashCompany.scaleY)
end

return CreditsScene
