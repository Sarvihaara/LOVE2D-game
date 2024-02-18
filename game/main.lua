--[[
    Carp To Dragon

    Author: Noa Midzic
    nmidzic@yahoo.com

    A 2D game made in LOVE game engine
]]


require 'Dependencies'

-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288


function love.load()

    -- app window title
    love.window.setTitle('Carp To Dragon')

    --https://freemusicarchive.org/music/Chad_Crouch/Arps/Algorithms
    music = love.audio.newSource('sounds&music/Chad_Crouch_-_Algorithms.mp3', 'stream' )
    music:setLooping(true)
    music:setVolume(0.1) --10 percent of the original volume
    music:play()

    --sound effects (source: bfxr)
    explosion = love.audio.newSource('sounds&music/Explosion6.wav', 'static')
    blip = love.audio.newSource('sounds&music/Blip_Select10.wav', 'static')

    smallFont = love.graphics.newFont('fonts/Kashima Demo.otf', 20)
    titleFont = love.graphics.newFont('fonts/Harukaze.ttf', 60)
    narrationFont = love.graphics.newFont('fonts/Korean_Calligraphy.ttf', 10)

    math.randomseed(os.time())

    -- initialise virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })


    --initialise state machine
    gStateMachine = StateMachine {
        ['title'] = function() return TitleState() end,
        ['play1'] = function() return Play1State() end,
        ['play2'] = function() return Play2State() end,
        ['win'] = function() return WinState() end,
        ['count'] = function() return CountdownState() end,
    }


    gStateMachine:change('title', {
        counter = 0
    })

    
    -- initialise table memorising the last pressed key (for title state!)
    love.keyboard.keysPressed = {}


end

function love.resize(width, height)
    push:resize(width, height)
end



function love.keypressed(key)
    -- add to table of keys pressed this frame
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end



function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end


function love.update(dt)

    --update whichever state currently on in state machine
    gStateMachine:update(dt)

    --reset key table
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    gStateMachine:render()
    
    push:finish()
end