Spawn = Class{}

local spawn1 = love.graphics.newImage('sprites/golden.png')
local spawn2 = love.graphics.newImage('sprites/white_black.png')
local spawn3 = love.graphics.newImage('sprites/red_white.png')
local spawn4 = love.graphics.newImage('sprites/black.png')
local spawn5 = love.graphics.newImage('sprites/orange.png')
local spawn6 = love.graphics.newImage('sprites/white.png')

function Spawn:init()
    --generates numbers between 1 and the inserted number, both inclusive
    --here: 1, 2, 3, 4, 5, or 6
    self.colour = math.random(6)

    if self.colour == 1 then
        self.image = spawn1
    elseif self.colour == 2 then
        self.image = spawn2
    elseif self.colour == 3 then
        self.image = spawn3
    elseif self.colour == 4 then
        self.image = spawn4
    elseif self.colour == 5 then
        self.image = spawn5
    else 
        self.image = spawn6
    end

    self.xscale = math.random(5, 15 + GAME_DIFFICULTY_SIZE) / 10.0
    self.yscale = self.xscale

    self.width = (self.image:getWidth() * self.xscale) / 1.5
    self.height = (self.image:getHeight() * self.yscale) / 1.5

    --create a bit outside the right of the screen so they can slide in
    self.x = VIRTUAL_WIDTH
    self.y = math.random(0, VIRTUAL_HEIGHT - 35)

    --randomise set speed for a given spawn
    self.speed = math.random(50 + GAME_DIFFICULTY_SPEED, 120 + GAME_DIFFICULTY_SPEED)

    self.remove = false
end


function Spawn:update(dt)
    if self.x >= -200 then
        self.x = self.x - self.speed * dt
    else
        self.remove = true
    end   
end


function Spawn:render()
    --the image to draw, x, y, rotation, x-scale, y-scale
    love.graphics.draw(self.image, self.x, self.y, 0, self.xscale, self.yscale)
end
