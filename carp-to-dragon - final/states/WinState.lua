WinState = Class{__includes = BaseState}

function WinState:init()
    -- images loaded into memory from files to later draw onto the screen
    self.background1 = love.graphics.newImage('pictures/carp_background.png')
    self.background2 = love.graphics.newImage('pictures/dragon_background.png')
    self.carp = love.graphics.newImage('pictures/carp_drawing.png')
    self.dragon = love.graphics.newImage('pictures/dragon_drawing.png')
    self.counter = 0
    self.timer = 0
    --at first, pics invisible so that it can fade in
    self.opacity = 0
end

function WinState:update(dt)

    self.timer = self.timer + dt
    
   if love.keyboard.wasPressed('space') then
        self.counter = self.counter + 1
        if self.counter ==  4 then
            --go to start game
            gStateMachine:change('title', {
                counter = 5
            })
        end
    end

    --for fade in effect, tween:
    Timer.tween(1, {
        [self] = {opacity = 255}
    })

    --update timer for transition effect
    Timer.update(dt) 
end

function WinState:render()

    -- draw the background starting at top left (0, 0)
    love.graphics.setColor(255, 255, 255, self.opacity)
    love.graphics.draw(self.background1, 0, 0)
    love.graphics.draw(self.carp, VIRTUAL_WIDTH / 3, 0)
    
    if self.timer > 4 then
        love.graphics.draw(self.background2, 0, 0)
        love.graphics.draw(self.dragon, VIRTUAL_WIDTH / 3, 0)
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Spacebar To Continue', 0, 210, VIRTUAL_WIDTH, 'center')
    end
    

    love.graphics.setColor(1, 1, 1)
    
    love.graphics.setFont(narrationFont)
    if self.counter == 1 then
        love.graphics.printf('Like the koi from the legend, you swam up the waterfall through sheer perseverance.', 0, 50, VIRTUAL_WIDTH, 'center')
    elseif self.counter == 2 then
        love.graphics.printf('The gods recognised your spirit and turned you into a dragon...', 0, 50, VIRTUAL_WIDTH, 'center')
    elseif self.counter == 3 then
        love.graphics.printf('Now the sky is your new river.', 0, 50, VIRTUAL_WIDTH, 'center')
    end
end