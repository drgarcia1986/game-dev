Meteor = {
    src = "images/meteor.png"
}

function Meteor:new(screen)
    o = {
        x = math.random(screen.WIDTH),
        y = -70,
        width = 50,
        height = 44,
        weight = math.random(3),
        horizontal_displacement = math.random(-1, 1)
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

function Meteor:move()
    self.y = self.y + self.weight
    self.x = self.x + self.horizontal_displacement
end

return Meteor
