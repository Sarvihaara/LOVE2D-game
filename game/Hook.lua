Hook = Class{}

function Hook:init(hookline)
    self.image = love.graphics.newImage('sprites/hook.png')
    
    self.xscale = 0.3
    self.yscale = 1
    self.width = self.image:getWidth() * self.xscale
    self.height = self.image:getHeight() * self.yscale
    
    self.x = hookline.x + 8
    self.y = hookline.y + hookline.height

    self.speed = hookline.speed

    self.remove = false

end

function Hook:update(dt)
    if self.x >= -50 then
        self.x = self.x - self.speed * dt
    else
        self.remove = true
    end   
end

function Hook:render()
    love.graphics.draw(self.image, self.x, self.y, 0, self.xscale, self.yscale)
end