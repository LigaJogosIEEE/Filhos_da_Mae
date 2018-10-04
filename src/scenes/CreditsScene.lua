local CreditsScene = {}
CreditsScene.__index = CreditsScene

function CreditsScene:new()
    local this = {
        mechanics = {"Jictyvoo - João Victor Oliveira Couto"},
        enemyAi = {"Atônio Crispin", "João Victor Oliveira Couto"},
        gameDesign = {"João Victor Oliveira Couto"},
        designers = {enemies = "Lucas Silva Lima", player = "Manuella Vieira", gui = "Lokisley"},
        levelDesign = {"João Victor Oliveira Couto", "Lokisley Oliveira", "Manuella Vieira"},
        companyImage = love.graphics.newImage("assets/company_logo.png"),
        y = love.graphics.getHeight(),
        elapsedTime = 0,
        speed = 1,
        finalY = love.graphics.getHeight()
    }

    return setmetatable(this, CreditsScene)
end

function CreditsScene:reset()
    self.y = love.graphics.getHeight(); self.elapsedTime = 0; self.finalY = self.y
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
    self.elapsedTime = self.elapsedTime + dt
    if self.elapsedTime >= 0.01 then
        self.y = self.y - self.speed
        self.elapsedTime = 0
    end
    if self.finalY <= 0 then
        sceneDirector:previousScene()
    end
end

function CreditsScene:draw()
    local y = self.y
    local x = (love.graphics.getWidth() / 2) - 200
    love.graphics.printf("Mechanics Programmers", x, y, 400, "left")
    y = y + 20
    for _, mechanics in pairs(self.mechanics) do
        love.graphics.printf(mechanics, x, y, 400, "center")
        y = y + 20
    end
    y = y + 15
    love.graphics.printf("Enemies AI Programmers", x, y, 400, "left")
    y = y + 20
    for _, enemyAi in pairs(self.enemyAi) do
        love.graphics.printf(enemyAi, x, y, 400, "center")
        y = y + 20
    end
    y = y + 15
    love.graphics.printf("Game Designers", x, y, 400, "left")
    y = y + 20
    for _, gameDesign in pairs(self.gameDesign) do
        love.graphics.printf(gameDesign, x, y, 400, "center")
        y = y + 20
    end
    y = y + 15
    love.graphics.printf("Sprite Designers", x, y, 400, "left")
    y = y + 20
    for _, designers in pairs(self.designers) do
        love.graphics.printf(designers, x, y, 400, "center")
        y = y + 20
    end
    y = y + 15
    love.graphics.printf("Level Design", x, y, 400, "left")
    y = y + 20
    for _, levelDesign in pairs(self.levelDesign) do
        love.graphics.printf(levelDesign, x, y, 400, "center")
        y = y + 20
    end
    y = y + 30
    local scales = scaleDimension:getScale("splash_company")
    love.graphics.draw(self.companyImage, scales.x, y, 0, scales.relative.x, scales.relative.y)
    self.finalY = y + self.companyImage:getHeight() * scales.relative.y
end

return CreditsScene
