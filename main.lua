push = require 'push'
Class = require 'class'

require 'Paddle'
require 'Ball'
require 'Position'
require 'Velocity'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Pong')

    math.randomseed(os.time())

    smallFont = love.graphics.newFont('font.ttf', 8)
    largeFont = love.graphics.newFont('font.ttf', 16)
    scoreFont = love.graphics.newFont('font.ttf', 32)
    love.graphics.setFont(smallFont)

    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
    }
    
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true,
        canvas = false
    })

    playerOnePaddle = Paddle(Position(10, 30), 5, 20)
    playerTwoPaddle = Paddle(Position(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30), 5, 20)
    ball = Ball(Position(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2), 4, 4)

    player1Score = 0
    player2Score = 0

    servingPlayer = 1
    winningPlayer = 0

    gameState = 'start'
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(deltaTime)
    if gameState == 'serve' then
        ball:startMovement(servingPlayer);
    elseif gameState == 'play' then
        if ball:collides(playerOnePaddle) then
            ball:handlePaddleCollition(1)
            sounds['paddle_hit']:play()
        end

        if ball:collides(playerTwoPaddle) then
            ball:handlePaddleCollition(2)
            sounds['paddle_hit']:play()
        end

        if ball:collidesBorder(1) then
            ball:handleBorderCollition(1)
            sounds['wall_hit']:play()
        end

        if ball:collidesBorder(2)  then
            ball:handleBorderCollition(2)
            sounds['wall_hit']:play()
        end

        if ball.position.x < 0 then
            servingPlayer = 1
            player2Score = player2Score + 1
            sounds['score']:play()

            if player2Score == 10 then
                winningPlayer = 2
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end
        end

        if ball.position.x > VIRTUAL_WIDTH then
            servingPlayer = 2
            player1Score = player1Score + 1
            sounds['score']:play()

            if player1Score == 10 then
                winningPlayer = 1
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end
        end
    end

    playerOnePaddle:handleMovement('w', 's')
    playerTwoPaddle:handleMovement('up', 'down')

    if gameState == 'play' then
        ball:update(deltaTime)
    end

    playerOnePaddle:update(deltaTime)
    playerTwoPaddle:update(deltaTime)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'done' then
            gameState = 'serve'

            ball:reset()

            player1Score = 0
            player2Score = 0

            if winningPlayer == 1 then
                servingPlayer = 2
            else
                servingPlayer = 1
            end
        end
    end
end

function love.draw()
    push:start()

    if gameState == 'start' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Welcome to Pong!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to begin!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s serve!", 
            0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'done' then
        love.graphics.setFont(largeFont)
        love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' wins!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to restart!', 0, 30, VIRTUAL_WIDTH, 'center')
    end
  
    playerOnePaddle:render()
    playerTwoPaddle:render()
    ball:render()

    displayScore()
    displayFPS()

    push:finish()
end


function displayScore()
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
end

function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
    love.graphics.setColor(255, 255, 255, 255)
end
