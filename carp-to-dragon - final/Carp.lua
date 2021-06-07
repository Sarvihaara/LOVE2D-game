Carp = Class{}

function Carp:init()
    self.image = love.graphics.newImage('sprites/carp.png')
    self.xscale = -1
    self.yscale = 1
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    -- position in the middle of the screen
    -- carp is mirrored, so self.x actually tracks upper rightmost pixel of carp, not upper leftmost
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)
    -- trial and error shows that dividing by 1.5 gives the most precise dimension of the 
    -- actual carp within the image
    self.newWidth = self.width / 1.5
    self.newHeight = self.height / 1.5

    self.xoverlap = false
    self.yoverlap = false

    self.orientation = 0

    --due to mirroring etc need to follow actual self.x position
    --for playstate 1 let it remain self.x and that is kept in mind during
    --collision detection, for playstate2 will change for accurate
    --collision detection
    self.x_detect = 0


end


function Carp:collides(object)
    --1st condition lines of spawn width and carp width on x axis do not overlap
    --2nd condition lines of spawn height and carp height on y axis do not overlap
    --both overlap needed for collision; one overlap or no overlap -> no collision
    -- (btw keep in mind that since carp is mirrored self.x/y tracks its upper right edge
    -- not upper left, this will in practice matter only for self.x)
    if object.x + 4 > self.x + self.x_detect - 2 or self.x + self.x_detect - self.newWidth + 4 > object.x + object.width - 2 then
        --do nothing, xoverlap is already set to false
    else
        self.xoverlap = true
    end

    if object.y + 4 > self.y + self.newHeight - 2 or self.y + 4 > object.y + object.height - 2 then
        --do nothing, yoverlap is false
    else
        self.yoverlap = true
    end

    if self.xoverlap == true and self.yoverlap == true then
        --collision
        --very important!!! always reset the values for the next checking before you return the result!
        self.xoverlap = false
        self.yoverlap = false
        return true
    else
        --at least one overlap is false; no collision
        self.xoverlap = false
        self.yoverlap = false
        return false
    end
end

function Carp:grow()
    self.xscale = self.xscale - 0.1 --bcs original xscale negative since image is mirrored
    self.yscale = self.yscale + 0.1
    --update carp width and height for accurate collision detection - original dimensions
    --times whatever the changed scale value is
    self.newWidth = -(self.width * self.xscale) / 1.5
    self.newHeight = self.height * self.yscale / 1.5
end

function Carp:render()
    love.graphics.draw(self.image, self.x, self.y, self.orientation, self.xscale, self.yscale)
end