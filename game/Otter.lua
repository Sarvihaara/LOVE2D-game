Otter = Class{}

function Otter:init()
    self.image = love.graphics.newImage('sprites/otter.png')
    
    self.width = self.image:getWidth() / 1.5
    self.height = self.image:getHeight() / 1.5
    
    self.x = VIRTUAL_WIDTH
    self.y = math.random(0, VIRTUAL_HEIGHT - 35)

    self.speed = math.random(110 + GAME_DIFFICULTY_SPEED, 130 + GAME_DIFFICULTY_SPEED)

    self.remove = false

end

function Otter:update(dt)
    if self.x >= -200 then
        self.x = self.x - self.speed * dt
    else
        self.remove = true
    end   
end

function Otter:render()
    love.graphics.draw(self.image, self.x, self.y)
end