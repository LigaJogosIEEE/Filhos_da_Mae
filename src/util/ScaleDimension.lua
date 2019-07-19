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
        self.scaleItems[itemName] = {
            scaleX = 1, scaleY = 1, x = x, y = y, width = width, height = height, originalInfo = {width, height, x, y, originalScale},
            centralizeOptions = {x = false, y = false, isImage = false , centerOffset = false}, relative = nil,
            aspectRatio = {active = false, centralizeOptions = nil}
        }
    end
    local item = self.scaleItems[itemName]
    item.scaleX, item.scaleY = self.graphicsDimensions.width / originalScale.width, self.graphicsDimensions.height / originalScale.height
    if x and y and originalScale then
        item.x = (x * self.graphicsDimensions.width) / originalScale.width
        item.y = (y * self.graphicsDimensions.height) / originalScale.height
    end
    item.width = (width * self.graphicsDimensions.width) / originalScale.width
    item.height = (height * self.graphicsDimensions.height) / originalScale.height
end

function ScaleDimension:relativeScale(itemName, originalSize)
    local scales = self.scaleItems[itemName]
    local newScale = {x = scales.width / originalSize.width, y = scales.height / originalSize.height, originalSize = originalSize}
    scales.relative = newScale
end

function ScaleDimension:directScale(width, height)
    return self.graphicsDimensions.width / width, self.graphicsDimensions.height / height
end

function ScaleDimension:generateAspectRatio(itemName, centralizeOptions)
    if self.scaleItems[itemName] then
        local item = self.scaleItems[itemName]
        item.aspectRatio.active = true
        local x, y = false, false
        if item.scaleX < item.scaleY then
            item.scaleY = item.scaleX
            y = true
            if item.relative then
                item.relative.y = item.relative.x
            end
        else
            item.scaleX = item.scaleY
            x = true
            if item.relative then
                item.relative.x = item.relative.y
            end
        end
        if centralizeOptions then
            item.aspectRatio.centralizeOptions = centralizeOptions
            self:centralize(itemName, x, y, centralizeOptions.isImage, centralizeOptions.centerOffset)
        end
    end
end

function ScaleDimension:centralize(itemName, x, y, isImage, centerOffset)
    if self.scaleItems[itemName] then
        local item = self.scaleItems[itemName]
        item.centralizeOptions.x = x or item.centralizeOptions.x
        item.centralizeOptions.y = y or item.centralizeOptions.y
        item.centralizeOptions.isImage = isImage or item.centralizeOptions.isImage
        item.centralizeOptions.centerOffset = centerOffset or item.centralizeOptions.centerOffset
        if x then
            item.x = (self.graphicsDimensions.width / 2) - ((isImage and (type(isImage) == "table" and isImage.width or item.originalInfo[1]) * (item.relative and item.relative.x or item.scaleX) or centerOffset and 0 or item.width) / 2)
        end
        if y then
            item.y = (self.graphicsDimensions.height / 2) - ((isImage and (type(isImage) == "table" and isImage.height or item.originalInfo[2]) * (item.relative and item.relative.y or item.scaleY) or centerOffset and 0 or item.height) / 2)
        end
    end
end

function ScaleDimension:getScale(itemName)
    return self.scaleItems[itemName]
end

function ScaleDimension:screenResize(width, height)
    self.graphicsDimensions.width, self.graphicsDimensions.height = width, height
    for itemName, item in pairs(self.scaleItems) do
        self:calculeScales(itemName, unpack(item.originalInfo))
        if item.relative then
            self:relativeScale(itemName, item.relative.originalSize)
        end
        if item.aspectRatio.active then
            self:generateAspectRatio(itemName, item.aspectRatio.centralizeOptions)
        end
        self:centralize(itemName, item.centralizeOptions.x, item.centralizeOptions.y, item.centralizeOptions.isImage, item.centralizeOptions.centerOffset)
    end
end

return ScaleDimension
