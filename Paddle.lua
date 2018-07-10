Paddle = Class{}

function Paddle:init(position, width, height)
    self.position = position
    self.width = width
    self.height = height
    self.velocity = Velocity(0, 0);
end

function Paddle:update(deltaTime)
    if self.velocity.y < 0 then
        self.position.y = math.max(0, self.position.y + self.velocity.y * deltaTime)
    else
        self.position.y = math.min(VIRTUAL_HEIGHT - self.height, self.position.y + self.velocity.y * deltaTime)
    end
end

function Paddle:handleMovement(upButton, downButton) 
    if love.keyboard.isDown(upButton) then
        self.velocity.y = -PADDLE_SPEED
    elseif love.keyboard.isDown(downButton) then
        self.velocity.y = PADDLE_SPEED
    else
        self.velocity.y = 0
    end
end

function Paddle:render()
    love.graphics.rectangle('fill', self.position.x, self.position.y, self.width, self.height)
end