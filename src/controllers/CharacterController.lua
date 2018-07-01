local CharacterController = {}

CharacterController.__index = CharacterController

function CharacterController:new(spriteSheet)
    
    local this = {
        x = 0,
        y = 0,
        move = false,
        speed = 1,
        orientation = "right",
        spriteSheet = spriteSheet or nil
    }
    
    return setmetatable(this, CharacterController)
end

function CharacterController:update(dt)
    local pressedKey = false
    if love.keyboard.isDown("up") then
        self.y = self.y - self.speed
        self.orientation = "up"
        pressedKey = true
    elseif love.keyboard.isDown("down") then
        self.y = self.y + self.speed
        self.orientation = "down"
        pressedKey = true
    end
    if love.keyboard.isDown("left") then
        self.x = self.x - self.speed
        self.orientation = "left"
        pressedKey = true
    elseif love.keyboard.isDown("right") then
        self.x = self.x + self.speed
        self.orientation = "right"
        pressedKey = true
    end
    
    if love.keyboard.isDown("space") then
        
    end
    
    if pressedKey then
        self.move = true
    else
        self.move = false
    end
    
    if self.spriteSheet then
        if self.move then
            self.spriteSheet[self.orientation].update(dt)
        else
            self.spriteSheet[self.orientation].resetCurrent()
        end
    end
end

function CharacterController:draw()
    if self.spriteSheet then
        self.spriteSheet[self.orientation].draw(self.x, self.y)
    end
end

return CharacterController
