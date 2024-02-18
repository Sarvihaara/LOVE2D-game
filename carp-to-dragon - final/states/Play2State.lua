Play2State = Class{__includes = BaseState}

--LINE 22!!!

--carp speed, game difficulty speed are used here, as global variables
--declared in play1state are accessible from here

WATERFALL_SPEED = 60
--reset game-difficulty & carp speed
CARP_SPEED = 100
GAME_DIFFICULTY_SPEED = 0

require 'Rock'

function Play2State:init()
    
    self.carp = Carp()
    --change carp orientation so it is facing up
    self.carp.orientation = -(math.pi / 2)
    --adjust carp x position since it will shift too
    --this is important for precise collision detector
    --x_detect is not just carp.x (top rightmost pixel) like in play1
    --but since orientation changed carp.x back to top leftmost pixel
    --need to add width to have it remain top leftmost bcs of how collision
    --detection is written (plus height bcs after flipping up
    --width is really now contained in height and vice verse)
    --of course this still does not solve y position problem since carp y is still
    --positioned up so if you go behind a rock and down through it, carp will pass half through
    --before collision is detected, but since the goal is to avoid rock head first or on sides,
    --I'll say this doesn't matter 
    self.carp.x_detect = self.carp.newHeight
    

    self.waterfall = love.graphics.newImage('pictures/waterfall.png')
    self.top = love.graphics.newImage('pictures/waterfall top.png')
    self.waterfall_scroll = 0
    self.watertop_scroll = 0
    

    --create table for rocks (inserting and removing them)
    self.rocks = {}

    self.spawnTimer = 0
    self.difficultyTimer = 0
    self.playTimer = 0

    self.playDuration = 15

end

function Play2State:update(dt)

    self.waterfall_scroll = (self.waterfall_scroll + WATERFALL_SPEED * dt) % (VIRTUAL_HEIGHT + 3)
    --begin updating this scroll only when it begins to actually get used
    if self.playTimer > self.playDuration then
        self.watertop_scroll = self.watertop_scroll + WATERFALL_SPEED * dt
    end

    if love.keyboard.isDown('up') then
        self.carp.y = math.max(0, self.carp.y - CARP_SPEED * dt)
    end
    if love.keyboard.isDown('down') then
        self.carp.y = math.min(VIRTUAL_HEIGHT - 35, self.carp.y + CARP_SPEED * dt)
    end
    --different limitation here - cannot exit the waterfall!
    if love.keyboard.isDown('left') then
        self.carp.x = math.max(VIRTUAL_WIDTH / 3 + 15, self.carp.x - CARP_SPEED * dt)
    end
    if love.keyboard.isDown('right') then
        self.carp.x = math.min(VIRTUAL_WIDTH, self.carp.x + CARP_SPEED * dt)
    end

    self.spawnTimer = self.spawnTimer + dt
    self.difficultyTimer = self.difficultyTimer + dt
    self.playTimer = self.playTimer + dt

    --spawn rocks only while waterfall top is not yet reached
    if self.playTimer < self.playDuration then
        --approx. every five seconds ramp up game difficulty
        --but also increase the carp's speed capacity slightly
        if self.difficultyTimer > 5 then
            GAME_DIFFICULTY_SPEED = GAME_DIFFICULTY_SPEED + 5
            CARP_SPEED = CARP_SPEED + 2
            self.difficultyTimer = 0
        end

        --initialise for each spawn constructor function and put that spawn in table
        if self.spawnTimer > 1.25 then
            table.insert(self.rocks, Rock())
            self.spawnTimer = 0
        end
    end

    --even after the top of waterfall is reached, rocks that are still on screen
    --need to continue moving and getting removed once off screen
    for k, rock in pairs(self.rocks) do
        rock:update(dt)
    end

    for k, rock in pairs(self.rocks) do
        if self.carp:collides(rock) then
            explosion:play()
            gStateMachine:change('title', {
                counter = 5
            })
        end
    end

    for k, rock in pairs(self.rocks) do
        if rock.remove then
            table.remove(self.rocks, k)
        end
    end

end

function Play2State:render()

    if self.playTimer > self.playDuration then
        love.graphics.draw(self.top, 0, self.watertop_scroll, 0, 1, 1, 0, VIRTUAL_HEIGHT * 2)
    else
        love.graphics.draw(self.waterfall, 0, self.waterfall_scroll, 0, 1, 1, 0, VIRTUAL_HEIGHT + 144)
    end

    if self.playTimer > 24 then
        gStateMachine:change('win')
    end

    self.carp:render()

    for k, rock in pairs(self.rocks) do
        rock:render()
    end

end