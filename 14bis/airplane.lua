require("collision")
require("consts")

AirplaneFire = {
    src = "images/player_fire.png"
}

function AirplaneFire:new(airplane)
    o = {
        x = airplane.x + airplane.width/2,
        y = airplane.y,
        width = 16,
        height = 16,
        speed = AIRPLANE_FIRE_SPEED,
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

Airplane = {}

function Airplane:new(screen)
    o = {
        src = "images/14bis.png",
        srcDead = "images/dead_airplane.png",
        width = 55,
        height = 63,
        x = screen.WIDTH/2 - 64/2,
        y = screen.HEIGHT - 64/2,
        fires = {}
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

function Airplane:destroy()
    self.width = 67
    self.height = 77
end

function Airplane:hasCollided(enemy)
    return objsHasCollided(self, enemy)
end

function Airplane:fire()
    table.insert(self.fires, AirplaneFire:new(self))
end

function Airplane:moveFires()
    for i = #self.fires, 1, -1 do
        if self.fires[i].y > 0 then
            self.fires[i].y = self.fires[i].y - self.fires[i].speed
        else
            table.remove(self.fires, i)
        end
    end
end
