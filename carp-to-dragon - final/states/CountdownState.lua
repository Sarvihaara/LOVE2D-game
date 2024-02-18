CountdownState = Class{__includes = BaseState}

COUNTDOWN_TIME = 1

function CountdownState:init()
    self.count = 3
    self.timer = 0

    self.waterfall = love.graphics.newImage('pictures/waterfall.png')

end

function CountdownState:update(dt)
    self.timer = self.timer + dt
    
    if self.timer > COUNTDOWN_TIME then
        self.timer = self.timer % COUNTDOWN_TIME
        self.count = self.count - 1

        if self.count <= 0 then
            gStateMachine:change('play2')
        end
    end
    end


function CountdownState:render()
    love.graphics.draw(self.waterfall, 0, 0)
    love.graphics.setFont(titleFont)
    love.graphics.printf('Waterfall', 0, 100, VIRTUAL_WIDTH, 'center')
    --bcs font used for titleFont doesn't support numbers, have to change
    love.graphics.setFont(narrationFont)
    love.graphics.printf(tostring(self.count), 0, 180, VIRTUAL_WIDTH, 'center')
end