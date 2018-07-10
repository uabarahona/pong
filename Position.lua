Position = Class{}

function Position:init(x, y) 
    self.x = x
    self.y = y
end

function Position:updatePosition(velocity, deltaTime) 
    return Position(self.x + velocity.x * deltaTime, self.y + velocity.y * deltaTime)
end