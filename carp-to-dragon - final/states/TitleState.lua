TitleState = Class{__includes = BaseState}

--accessible to play1 state too as global variable
GROUND_SPEED = 50


function TitleState:init()
    -- images loaded into memory from files to later draw onto the screen
    self.background = love.graphics.newImage('pictures/background.png')
    self.ground = love.graphics.newImage('pictures/ground.png')
    self.ground_scroll = 0
end

function TitleState:enter(params)
    self.counter = params.counter
end

function TitleState:update(dt)

    self.ground_scroll = (self.ground_scroll + GROUND_SPEED * dt) % VIRTUAL_WIDTH

   if love.keyboard.wasPressed('space') then
        self.counter = self.counter + 1
        if self.counter == 6 then
            gStateMachine:change('play1')
        end
    end
end

function TitleState:render()

    -- draw the background starting at top left (0, 0)
    love.graphics.draw(self.background, 0, 0)
    -- draw the ground on top of the background, toward the bottom of the screen
    -- 30 pixels is the actual height of the png
    love.graphics.draw(self.ground, -self.ground_scroll, VIRTUAL_HEIGHT - 80)

    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(titleFont)
    love.graphics.printf('Carp To Dragon', 0, 40, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(narrationFont)
    if self.counter == 1 then
        love.graphics.printf('According to an old legend...', 0, 140, VIRTUAL_WIDTH, 'center')
    elseif self.counter == 2 then
        love.graphics.printf('The Japanese carp, or koi, that reaches the top of a waterfall, will turn into a dragon.', 0, 140, VIRTUAL_WIDTH, 'center')
    elseif self.counter == 3 then
        love.graphics.printf('You want to see for yourself if the legends are true. But first, you must reach the end of the river.', 0, 140, VIRTUAL_WIDTH, 'center')
    elseif self.counter == 4 then
        love.graphics.printf('You will succeed only if you grow enough to take on the waterfall, but be careful which fish you choose to face, and beware otters and fishers!', 0, 140, VIRTUAL_WIDTH, 'center')
    elseif self.counter == 5 then
        love.graphics.printf('Start Game', 0, 140, VIRTUAL_WIDTH, 'center')
    end

    love.graphics.setFont(smallFont)
    love.graphics.printf('Press Spacebar To Continue', 0, 200, VIRTUAL_WIDTH, 'center')
end