require("airplane")
require("meteor")
require("game")
require("state")
require("consts")
require("image")

SCREEN = {
    WIDTH = 320,
    HEIGHT = 480,
    TITLE = "14bis Adventure",
    BACKGROUND = "images/background.png",
    print = function(msg, x, y)
        love.graphics.print(msg, x, y)
    end
}

enemy_factory = function(screen)
    return Meteor:new(screen)
end

game = Game:new(
    MAX_ENEMIES,
    Airplane:new(SCREEN),
    SCREEN,
    enemy_factory,
    love.timer.sleep,
    love.event.quit
)

function movePlayer()
    for key, direction in pairs(KEY_DOWN_MAP) do
        if love.keyboard.isDown(key) then
            game:movePlayer(direction)
        end
    end
end

function love.load()
    math.randomseed(os.time())

    love.window.setMode(SCREEN.WIDTH, SCREEN.HEIGHT, {resizable = false})
    love.window.setTitle(SCREEN.TITLE)

    sounds = {
        background = love.audio.newSource("audios/background.wav", "static"),
        gameOver = love.audio.newSource("audios/game_over.wav", "static"),
        airplaneDestruction = love.audio.newSource("audios/destruction.wav", "static"),
        airplaneFire = love.audio.newSource("audios/airplaneFire.wav", "static"),
        winner = love.audio.newSource("audios/winner.wav", "static")
    }

    images = {
        background = Image:new(love.graphics.newImage(SCREEN.BACKGROUND)),
        player = Image:new(love.graphics.newImage(game.player.src)),
        playerDead = Image:new(love.graphics.newImage(game.player.srcDead)),
        enemy = Image:new(love.graphics.newImage(Meteor.src)),
        playerFire = Image:new(love.graphics.newImage(AirplaneFire.src)),
        gameOver = Image:new(love.graphics.newImage("images/gameover.png")),
        winner = Image:new(love.graphics.newImage("images/winner.png"))
    }

    game:setState(StateRun:new(game))
    game:start(sounds, images)
end

function love.update(dt)
    movePlayer()
    game:update()
end

function love.keypressed(key)
    game:keypressed(key)
end

function love.draw()
    game:draw()
end
