Rock = Class{}

local rock = love.graphics.newImage('sprites/rock.png')

function Rock:init()

    self.image = rock

    self.width = self.image:getWidth() / 1.5
    self.height = self.image:getHeight()  / 1.5

    --create a bit outside the above of the screen so they can slide in
    self.x = math.random(VIRTUAL_WIDTH / 3, VIRTUAL_WIDTH - 5)
    self.y = -50

    --randomise set speed for a given spawn
    self.speed = math.random(50 + GAME_DIFFICULTY_SPEED, 70 + GAME_DIFFICULTY_SPEED)

    self.remove = false
end


function Rock:update(dt)
    if self.y <= VIRTUAL_HEIGHT + 50 then
        self.y = self.y + self.speed * dt
    else
        self.remove = true
    end   
end


function Rock:render()
    --the image to draw, x, y, rotation, x-scale, y-scale
    love.graphics.draw(self.image, self.x, self.y)
end