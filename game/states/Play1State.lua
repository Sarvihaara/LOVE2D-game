Play1State = Class{__includes = BaseState}

--constants here
CARP_SPEED = 100
GAME_DIFFICULTY_SPEED = 0
GAME_DIFFICULTY_SIZE = 0

function Play1State:init()

    -- images loaded into memory from files to later draw onto the screen
    self.background = love.graphics.newImage('pictures/background.png')
    self.ground = love.graphics.newImage('pictures/ground.png')
    self.ground_scroll = 0
    
    self.carp = Carp()

    --create table for spawns (inserting and removing them)
    self.spawns = {}
    self.otters = {}
    self.hooks = {}
    self.hooklines = {}

    self.spawnTimer = 0
    self.difficultyTimer = 0

    --signal for when the time for fade in transition to countdownState comes
    self.transitionState = false
    self.opacity = 0

end

function Play1State:update(dt)

    self.ground_scroll = (self.ground_scroll + GROUND_SPEED * dt) % VIRTUAL_WIDTH
    
    if love.keyboard.isDown('up') then
        self.carp.y = math.max(0, self.carp.y - CARP_SPEED * dt)
    end
    if love.keyboard.isDown('down') then
        self.carp.y = math.min(VIRTUAL_HEIGHT - 35, self.carp.y + CARP_SPEED * dt)
    end
    if love.keyboard.isDown('left') then
        self.carp.x = math.max(0 + self.carp.newWidth, self.carp.x - CARP_SPEED * dt)
    end
    if love.keyboard.isDown('right') then
        self.carp.x = math.min(VIRTUAL_WIDTH, self.carp.x + CARP_SPEED * dt)
    end

    self.spawnTimer = self.spawnTimer + dt
    self.difficultyTimer = self.difficultyTimer + dt

    --approx. every five seconds ramp up game difficulty
    --but also increase the carp's speed capacity slightly
    if self.difficultyTimer > 5 then
        GAME_DIFFICULTY_SPEED = GAME_DIFFICULTY_SPEED + 5
        GAME_DIFFICULTY_SIZE = GAME_DIFFICULTY_SIZE + 1
        CARP_SPEED = CARP_SPEED + 2
        self.difficultyTimer = 0
    end

    --initialise for each spawn constructor function and put that spawn in table, same for otter and hook
    if self.spawnTimer > 3 then
        table.insert(self.spawns, Spawn())
        --leave it to chance whether an otter or a hook also appear or not
        if math.random(2) == 1 and 2 then
            table.insert(self.otters, Otter())
        end
        if math.random(2) == 1 and 2 then
            hookline = Hookline()
            table.insert(self.hooklines, hookline)
            table.insert(self.hooks, Hook(hookline))
        end
        self.spawnTimer = 0
    end

    for k, spawn in pairs(self.spawns) do
        spawn:update(dt)
    end

    for k, otter in pairs(self.otters) do
        otter:update(dt)
    end

    for k, hook in pairs(self.hooks) do
        hook:update(dt)
    end

    for k, hookline in pairs(self.hooklines) do
        hookline:update(dt)
    end


    for k, spawn in pairs(self.spawns) do
        if self.carp:collides(spawn) then
            if spawn.width >= self.carp.newWidth then
                --sound effect
                explosion:play()
                --reset game difficulty, otherwise there will be only bigger
                --and bigger and faster spawns each time user restarts!
                GAME_DIFFICULTY_SIZE = 0
                GAME_DIFFICULTY_SPEED = 0
                --5 is the self.counter I want to continue with after each loss
                gStateMachine:change('title', {
                    counter = 5
                })
            else
                blip:play()
                spawn.remove = true
                self.carp:grow()
            end
        end
    end

    for k, otter in pairs(self.otters) do
        if self.carp:collides(otter) then
            explosion:play()
            GAME_DIFFICULTY_SIZE = 0
            GAME_DIFFICULTY_SPEED = 0
            gStateMachine:change('title', {
                counter = 5
            })
        end
    end

    for k, hook in pairs(self.hooks) do
        if self.carp:collides(hook) then
            explosion:play()
            GAME_DIFFICULTY_SIZE = 0
            GAME_DIFFICULTY_SPEED = 0
            gStateMachine:change('title', {
                counter = 5
            })
        end
    end


    for k, spawn in pairs(self.spawns) do
        if spawn.remove then
            table.remove(self.spawns, k)
        end
    end

    for k, otter in pairs(self.otters) do
        if otter.remove then
            table.remove(self.otters, k)
        end
    end

    for k, hook in pairs(self.hooks) do
        if hook.remove then
            table.remove(self.hooks, k)
        end
    end

    for k, hookline in pairs(self.hooklines) do
        if hookline.remove then
            table.remove(self.hooklines, k)
        end
    end

    --when the carp grows enough, change to countdown from where
    --change to part 2
    if self.carp.newWidth >= 50 then
        self.transitionState = true
    
        Timer.tween(2, {
            [self] = {opacity = 255}
        }):finish(function()
            gStateMachine:change('count')
        end)

    end

    Timer.update(dt)
end

function Play1State:render()

    -- draw the background starting at top left (0, 0)
    love.graphics.draw(self.background, 0, 0)
    -- draw the ground on top of the background, toward the bottom of the screen
    -- 30 pixels is the actual height of the png
    love.graphics.draw(self.ground, -self.ground_scroll, VIRTUAL_HEIGHT - 80)

    self.carp:render()
    
    for k, spawn in pairs(self.spawns) do
        spawn:render()
    end

    for k, otter in pairs(self.otters) do
        otter:render()
    end

    for k, hook in pairs(self.hooks) do
        hook:render()
    end

    for k, hookline in pairs(self.hooklines) do
        hookline:render()
    end

    --when transitioning to countdown (waterfall), draw a rectangle whose opacity thanks to tweening
    --changes from invisible to visible (white), creating fade in effect
    if self.transitionState then
        love.graphics.setColor(255, 255, 255, self.opacity)
        love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    end

end
