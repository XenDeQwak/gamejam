local isLeverDown, originalY
local radius = 80
local resetTimer = 0
local event = require "src.event"
local screen= require "src.screen"
local slotmachine = require "src/slotmachine"
local color = require "src/color"
local buttonMaker = require "src.buttonmaker"
local bm

function love.load()

    print("Game started!")
    
    love.window.setMode(1280,720,{resizable=true})
    love.graphics.setFont(love.graphics.newFont(32))
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
    screen.updateScale(love.graphics.getDimensions())

    lever = {x = 1300, y = 280}
    msgTab = {x = 510, y = 150};
    slotsTab = {x = 400, y = 150};

    isLeverDown = false
    originalY = lever.y
    event.load()
    lever.Image = love.graphics.newImage("assets/slot_lever_default.png")
    bm = buttonMaker:new()

    local function addButton(label, xCoord, yCoord, width, height, onClick, fontSize)
        local btn = bm:createButton(
            label,
            xCoord,
            yCoord, 
            width, 
            height,
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
    love.graphics.translate(screen.offsetX, screen.offsetY)
    love.graphics.scale(screen.scale)
    createScreen()
    

    if isLeverDown then
        slot()
    end

    if event.message then 
        event.draw()
    end

    bm:draw()

    love.graphics.pop()
end



function love.update(dt)
    leverTimer(dt)
    -- event.update(dt)
end

function love.resize(w, h)
    screen.updateScale(w,h)
end

function love.mousepressed(x, y, button)
    if button == 1 then
        onLeverClick(x, y)
    end
    bm:mousepressed(x, y, button)
end

function createScreen()

    color.setRGBA(0, 0, 0)
    love.graphics.setColor(color.getRGBA())
    love.graphics.rectangle("line", 350, 150, 1200, 750)

    color.setRGBA(222, 184, 135)
    love.graphics.setColor(color.getRGBA())
    love.graphics.rectangle("fill", 400, 200, 850, 650)

    color.setRGBA(255, 0, 0)
    love.graphics.setColor(color.getRGBA())
    love.graphics.draw(lever.Image,lever.x,lever.y)

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
        lever.Image = love.graphics.newImage("assets/slot_lever_active.png")

        -- event.nextEvent()
        slotmachine.spin()
    end
end

function leverTimer(dt)
    if resetTimer > 0 then
        resetTimer = resetTimer - dt
    else
        lever.Image = love.graphics.newImage("assets/slot_lever_default.png")
        isLeverDown = false
    end
end
