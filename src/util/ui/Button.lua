local Button = {}

Button.__index = Button

function Button:new(buttonName, x, y, width, height, image, originalImage, animation)
    local this = {
        name = buttonName, x = x or 0, y = y or 0, width = width or 100, height = height or 50,
        image = type(image) == "table" and image or {normal = image, pressed = image, hover = image, disabled = image},
        state = "normal", pressed = false, callback = function() return "Clicked" end,
        animation = animation or {normal = nil, pressed = nil, hover = nil}, scaleX = 1, scaleY = 1,
        originalImage = originalImage, visible = true, rotation = 0, offsetX = 0, offsetY = 0
    }

    return setmetatable(this, Button)
end

function Button:isMouseOnButton(x, y)
    return (x >= self.x - self.offsetX and x <= self.x + self.width - self.offsetX) and (y >= self.y - self.offsetY and y <= self.y + self.height - self.offsetY)
end

function Button:setCallback(callback) self.callback = callback end

function Button:executeCallback(...) self.callback(self, ...) end

function Button:disableButton() self.state = "disabled" end

function Button:enableButton() self.state = "normal" end

function Button:setVisible(isVisible) self.visible = isVisible end

function Button:getName() return self.name end

function Button:setName(name) self.name = name or self.name end

function Button:setXY(x, y) self.x, self.y = x, y end

function Button:setScale(scaleX, scaleY) self.scaleX, self.scaleY = scaleX, scaleY end

function Button:setDimensions(width, height) self.width, self.height = width, height end

function Button:setRotation(rotation) self.rotation = rotation end

function Button:setOffset(offsetX, offsetY)
    self.offsetX, self.offsetY = offsetX, offsetY
end

function Button:getState() return self.state end

function Button:isEnabled() return self.state ~= "disabled" end

function Button:setState(newState) self.state = newState end

function Button:setButtonImage(image, type)
    if not self.image then
        self.image = {normal = image, pressed = image, hover = image, disabled = image}
    end
    self.image[type or "normal"] = image
end

function Button:mousemoved(x, y, dx, dy, istouch)
    if self:isMouseOnButton(x, y) and (not self.pressed) and self.state ~= "disabled" then
        self.state = "hover"
        return self.name
    elseif not self.pressed and self.state ~= "disabled" then
        self.state = "normal"
    end
    return nil
end

function Button:mousepressed(x, y, button, istouch)
    if self:isMouseOnButton(x, y) and self.state ~= "disabled" then
        self.pressed = true
        self.state = "pressed"
        return self.name
    end
end

function Button:mousereleased(x, y, button, istouch)
    if self:isMouseOnButton(x, y) and self.pressed and self.state ~= "disabled" then
        self.callback(self)
    end
    self.pressed = false
    self.state = self.state == "disabled" and self.state or "normal"
end

function Button:update(dt)
    if self.animation[self.state] then
        self.animation[self.state].update(dt)
    end
end

function Button:draw()
    if self.visible then
        if self.animation[self.state] then
            self.animation[self.state].draw(self.x, self.y)
        elseif self.image[self.state] then
            if self.originalImage then
                --love.graphics.rectangle("line", self.x - self.offsetX, self.y - self.offsetY, self.width, self.height)
                love.graphics.draw(self.originalImage, self.image[self.state], self.x, self.y, self.rotation, self.scaleX, self.scaleY, self.offsetX, self.offsetY)
            else
                love.graphics.draw(self.image[self.state], self.x, self.y, self.rotation, self.scaleX, self.scaleY, self.offsetX, self.offsetY)
            end
            if self.name then
                local currentFont = love.graphics.getFont()
                local _, lines = currentFont:getWrap(self.name, self.width)
                local fontHeight = currentFont:getHeight()
                love.graphics.printf(self.name, self.x, self.y + self.offsetY --[[- (fontHeight / 2 * #lines)--]], self.width, "center", self.rotation, 1, 1)
            end
        end
        
        love.graphics.rectangle("line", self.x - self.offsetX, self.y - self.offsetY, self.width, self.height)
    end
end

return Button
