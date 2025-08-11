local isLeverDown
local leverScale = 2
local radius = 80 * leverScale
local resetTimer = -1
local event = require "src.event"
local screen= require "src.screen"
local slotmachine = require "src/slotmachine"
local color = require "src/color"
local buttonMaker = require "src.buttonmaker"
local bm
local image ={}

function love.load()

    print("Game started!")
    
    love.window.setMode(1280,720,{resizable=true})
    love.graphics.setFont(love.graphics.newFont(32))
    screen.updateScale(love.graphics.getDimensions())
    image.background = love.graphics.newImage("assets/ui/background.png")
    image.slots = love.graphics.newImage("assets/Slot Machine/slot_machine.png")

    image.lever_default = love.graphics.newImage("assets/lever/slot_lever_default.png")
    image.lever_active = love.graphics.newImage("assets/lever/slot_lever_active.png")
    image.lever = image.lever_default

    event.load()

    lever = {x = 1290, y = 350}

    isLeverDown = false

    bm = buttonMaker:new()

    local function addButton(label, xCoord, yCoord, width, height, onClick, fontSize)
        local btn = bm:createButton(label,xCoord,yCoord, width, height,
            --onClick is a function call (function() [statements] end)
            onClick
        )
        if fontSize then
            btn.style.font = love.graphics.newFont(fontSize)
        end
    end

    local btnWidth = 100
    local btnHeight = 60
    local fontSize = 20

    addButton("Test", 100, 100, btnWidth, btnHeight, nil, fontSize)
    addButton("Test2", 200, 100, btnWidth, btnHeight, nil, fontSize)

end

function love.draw()

    love.graphics.push()

    love.graphics.setColor(1,1,1,1)
    local bgScaleX = love.graphics.getWidth() / image.background:getWidth()
    local bgScaleY = love.graphics.getHeight() / image.background:getHeight()
    love.graphics.draw(image.background, 0, 0, 0, bgScaleX, bgScaleY)

    love.graphics.translate(screen.offsetX, screen.offsetY)
    love.graphics.scale(screen.scale)
    createScreen()

    if isLeverDown then
        slot()
    elseif event.message then 
        event.draw()
    end

    bm:draw()

    love.graphics.pop()
end

function love.update(dt)
    leverTimer(dt)
end

function love.resize(w, h)
    screen.updateScale(w,h)
end

function love.mousepressed(x, y, button)
    if button == 1 then
        if(not event.message) then 
            onLeverClick(x, y)
        end
    end
    bm:mousepressed(x, y, button)
end

function createScreen()

    love.graphics.setColor(color.setRGBA(0,0,0))
    love.graphics.rectangle("line", 350, 150, 1200, 750)

    love.graphics.setColor(1,1,1)
    love.graphics.draw(image.slots,400,175)

    love.graphics.draw(image.lever, lever.x, lever.y, 0, leverScale, leverScale)

end

function slot()
    love.graphics.print("THE SLOT IS ROLLING", 450, 500)
end

function onLeverClick(x, y)

    mx = (x - screen.offsetX) / screen.scale
    my = (y - screen.offsetY) / screen.scale

    local dx = mx - lever.x
    local dy = my - lever.y
    local distance = math.sqrt(dx * dx + dy * dy)

-- lever onclick
    if distance <= radius and resetTimer <= 0 then
        isLeverDown = true
        resetTimer = 1
        image.lever = image.lever_active
        slotmachine.spin()
        lever.y = lever.y+70
    end
end

function leverTimer(dt)
    if resetTimer > 0 then
        resetTimer = resetTimer - dt
    elseif  resetTimer>-1 then
        image.lever = image.lever_default
        isLeverDown = false
        lever.y = lever.y-70
        resetTimer=-1
        -- event.nextEvent()
    end
end
