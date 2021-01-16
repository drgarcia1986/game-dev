Image = {}

function Image:new(img)
    o = {
        img = img
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

function Image:draw(x, y)
    love.graphics.draw(self.img, x, y)
end

function Image:width()
    return self.img:getWidth()
end

function Image:height()
    return self.img:getHeight()
end
