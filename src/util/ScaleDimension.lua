local ScaleDimension = {}

ScaleDimension.__index = ScaleDimension

function ScaleDimension:new()
    local this = {
        scaleItems = {},
        graphicsDimensions = {width = love.graphics.getWidth(), height = love.graphics.getHeight()},
        gameScreenScale = {width = 800, height = 600}
    }

    return setmetatable(this, ScaleDimension)
end

function ScaleDimension:setGameScreenScale(width, height)
    self.gameScreenScale.width, self.gameScreenScale.height = width, height
end

function ScaleDimension:calculeScales(itemName, width, height, x, y, originalScale)
    local originalScale = originalScale or self.gameScreenScale
    if not self.scaleItems[itemName] then
        self.scaleItems[itemName] = {scaleX = 1, scaleY = 1, x = x, y = y, width = width, height = height, originalInfo = {width, height, x, y, originalScale}}
    end
    local item = self.scaleItems[itemName]
    item.scaleX, item.scaleY = self.graphicsDimensions.width / width, self.graphicsDimensions.height / height
    if x and y and originalScale then
        item.x = (x * self.graphicsDimensions.width) / originalScale.width
        item.y = (y * self.graphicsDimensions.height) / originalScale.height
    end
    item.width = (width * self.graphicsDimensions.width) / originalScale.width
    item.height = (height * self.graphicsDimensions.height) / originalScale.height
end

function ScaleDimension:directScale(width, height)
    return self.graphicsDimensions.width / width, self.graphicsDimensions.height / height
end

function ScaleDimension:centralize(itemName, x, y, isImage)
    if self.scaleItems[itemName] then
        local item = self.scaleItems[itemName]
        if x then
            item.x = (self.graphicsDimensions.width / 2) - ((isImage and item.originalInfo[1] or item.width) / 2)
        end
        if y then
            item.y = (self.graphicsDimensions.height / 2) - ((isImage and item.originalInfo[2] or item.height) / 2)
        end
    end
end

function ScaleDimension:getScale(itemName)
    return self.scaleItems[itemName]
end

function ScaleDimension:screenResize()
    for itemName, item in ipairs(self.scaleItems) do
        self:calculeScales(itemName, unpack(item.originalInfo))
    end
end

return ScaleDimension
