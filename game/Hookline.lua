Hookline = Class{}

function Hookline:init()
    self.image = love.graphics.newImage('sprites/hookline.png')
    
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    
    self.x = VIRTUAL_WIDTH + 50
    --determines how long it appears
    self.y = math.random(-550, -50)

    self.speed = math.random(30, 150)

    self.remove = false

end

function Hookline:update(dt)
    if self.x >= -50 then
        self.x = self.x - self.speed * dt
    else
        self.remove = true
    end   
end

function Hookline:render()
    love.graphics.draw(self.image, self.x, self.y)
end