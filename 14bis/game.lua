require("collision")
require('consts')
require("state")

Game = {}

function Game:new(max_enemies, player, screen, enemy_factory, sleep, quit)
    o = {
        enemies = {},
        max_enemies = max_enemies,
        player = player,
        screen = screen,
        enemy_factory = enemy_factory,
        sleep = sleep,
        score = 0,
        quit = quit,
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

function Game:start(sounds, images)
    self.sounds = sounds
    self.images = images
    self.state:start()
end

function Game:draw()
    self.state:draw()
end

function Game:setState(state)
    self.state = state
end

function Game:movePlayer(direction)
    self.state:movePlayer(direction)
end

function Game:update()
    self:movePlayerFires()
    self:updateEnemies()
    self:checkCollisions()
    self:checkScore()
end

function Game:playerFire()
    self.state:playerFire()
end

function Game:movePlayerFires()
    self.state:movePlayerFires()
end

function Game:updateEnemies()
    self.state:updateEnemies()
end

function Game:checkCollisions()
    self.state:checkCollisions()
end

function Game:checkScore()
    self.state:checkScore()
end

function Game:keypressed(key)
    if key == "escape" then
        self.quit()
    elseif key == "space" then
        self:playerFire()
    end
end

function Game:removeUnreachableEnemies()
    for i = #self.enemies, 1, -1 do
        if self.enemies[i].y > self.screen.HEIGHT then
            table.remove(self.enemies, i)
        end
    end
end

function Game:addEnemy()
    table.insert(self.enemies, self.enemy_factory(self.screen))
end

function Game:moveEnemies()
    for _, enemy in pairs(self.enemies) do
        enemy:move()
    end
end

function Game:playerHasCollided()
    for _, enemy in ipairs(self.enemies) do
        if self.player:hasCollided(enemy) then
            self.player:destroy()
            return true
        end
    end
    return false
end

function Game:checkPlayerFireCollisionAndDestroyEnemies()
    for i = #self.player.fires, 1, -1 do
        for j = #self.enemies, 1, -1 do
            if objsHasCollided(self.player.fires[i], self.enemies[j]) then
                self.score = self.score + 1
                table.remove(self.player.fires, i)
                table.remove(self.enemies, j)
                break
            end
        end
    end
end

function Game:playerWon()
    return self.score >= MAX_SCORE
end

function Game:pointsLeft()
    return MAX_SCORE - self.score
end

return Game
