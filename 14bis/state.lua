require('consts')

StateHold = {}

function StateHold:new(game)
    o = {game = game}
    setmetatable(o, self)
    self.__index = self
    return o
end

function StateHold:start()
end

function StateHold:draw()
end

function StateHold:movePlayer(direction)
end

function StateHold:movePlayerFires()
end

function StateHold:playerFire()
end

function StateHold:updateEnemies()
end

function StateHold:checkCollisions()
end

function StateHold:checkScore()
end


StateRun = StateHold:new()

function StateRun:start()
    self.game.sounds.background:setLooping(true)
    self.game.sounds.background:play()
end

function StateRun:draw()
    self.game.images.background:draw(0, 0)
    self.game.images.player:draw(self.game.player.x, self.game.player.y)

    for _, enemy in pairs(self.game.enemies) do
        self.game.images.enemy:draw(enemy.x, enemy.y)
    end

    for _, fire in pairs(self.game.player.fires) do
        self.game.images.playerFire:draw(fire.x, fire.y)
    end

    self.game.screen.print("Meteoros restantes: "..self.game:pointsLeft(), 0, 0)
end

function StateRun:movePlayer(direction)
    if (
        direction == DIRECTION.UP and
        (self.game.player.y + self.game.player.height/2) > 0
    ) then
        self.game.player.y = self.game.player.y - 1
    elseif (
        direction == DIRECTION.DOWN and
        (self.game.player.y + self.game.player.height/2) < self.game.screen.HEIGHT
    ) then
        self.game.player.y = self.game.player.y + 1
    elseif (
        direction == DIRECTION.LEFT and
        (self.game.player.x + self.game.player.width/2) > 0
    ) then
        self.game.player.x = self.game.player.x - 1
    elseif (
        direction == DIRECTION.RIGHT and
        (self.game.player.x + self.game.player.width/2) < self.game.screen.WIDTH
    ) then
        self.game.player.x = self.game.player.x + 1
    end
end

function StateRun:movePlayerFires()
    self.game.player:moveFires()
end

function StateRun:playerFire()
    self.game.sounds.airplaneFire:play()
    self.game.player:fire()
end

function StateRun:updateEnemies()
    self.game:removeUnreachableEnemies()
    if #self.game.enemies < self.game.max_enemies then
        self.game:addEnemy()
    end
    self.game:moveEnemies()
end

function StateRun:checkCollisions()
    self.game:checkPlayerFireCollisionAndDestroyEnemies()
    if self.game:playerHasCollided() then
        self.game.sounds.airplaneDestruction:play()
        self.game:setState(StateOver:new(self.game))
    end
end

function StateRun:checkScore()
    if self.game:playerWon() then
        self.game:setState(StateWin:new(self.game))
    end
end

StateOver = StateHold:new()

function StateOver:draw()
    self.game.images.playerDead:draw(self.game.player.x, self.game.player.y)
    self.game.images.gameOver:draw(
        self.game.screen.WIDTH/2 - self.game.images.gameOver:width()/2,
        self.game.screen.HEIGHT/2 - self.game.images.gameOver:height()/2
    )
end

function StateOver:checkScore()
    self.game.sounds.background:stop()
    if not self.game.sounds.airplaneDestruction:isPlaying() then
        self.game.sounds.gameOver:play()
        self.game.sleep(2)
        self.game:setState(StateHold:new(self))
    end
end

StateWin = StateHold:new()

function StateWin:draw()
    self.game.images.winner:draw(
        self.game.screen.WIDTH/2 - self.game.images.winner:width()/2,
        self.game.screen.HEIGHT/2 - self.game.images.winner:height()/2
    )
end

function StateWin:checkScore()
    self.game.sounds.background:stop()
    self.game.sounds.winner:play()
    self.game.sleep(3)
    self.game:setState(StateHold:new(self))
end
