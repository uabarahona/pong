Ball = Class{}

function Ball:init(position, width, height)
    self.position = position
    self.width = width
    self.height = height

    self.velocity = Velocity(0, 0)
end

function Ball:collides(paddle)
    if self.position.x > paddle.position.x + paddle.width or paddle.position.x > self.position.x + self.width then
        return false
    end

    if self.position.y > paddle.position.y + paddle.height or paddle.position.y > self.position.y + self.height then
        return false
    end 

    return true
end

function Ball:collidesBorder(border) 
    if border == 1 then 
        return self.position.y <= 0
    else
        return self.position.y >= VIRTUAL_HEIGHT - 4;
    end

end

function Ball:handlePaddleCollition(paddleNumber)
    if paddleNumber == 1 then
        self.position.x = playerOnePaddle.position.x + 5
    else 
        self.position.x = playerTwoPaddle.position.x - 4
    end

    self.velocity.x = -self.velocity.x * 1.03

    if self.velocity.y < 0 then
        self.velocity.y = -math.random(10, 150)
    else
        self.velocity.y = math.random(10, 150)
    end
end

function Ball:handleBorderCollition(border) 
    if border == 1 then 
        self.position.y = 0
        self.velocity.y = -self.velocity.y
    else 
        self.position.y = VIRTUAL_HEIGHT - 4
        self.velocity.y = -self.velocity.y
    end
end

function Ball:startMovement(servingPlayer) 
    self.velocity.y = math.random(-50, 50)
    if servingPlayer == 1 then
        self.velocity.x = math.random(140, 200)
    else
        self.velocity.x = -math.random(140, 200)
    end
end

function Ball:reset()
    self.position = Position(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2)
    self.velocity = Velocity(0, 0)
end

function Ball:update(deltaTime)
    self.position = self.position:updatePosition(self.velocity, deltaTime)
end

function Ball:render()
    love.graphics.rectangle('fill', self.position.x, self.position.y, self.width, self.height)
end