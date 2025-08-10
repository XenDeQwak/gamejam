local isLeverDown, originalY
local radius = 80
local resetTimer = 0
local event = require "src/event"
local screen= require "src.screen"

function love.load()

    print("Game started!")
    
    love.window.setMode(1280,720,{resizable=true})
    love.graphics.setFont(love.graphics.newFont(32))
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)

    screen.updateScale(love.graphics.getDimensions())

    lever = {x = 1420, y = 280}
    msgTab = {x = 510, y = 150};
    slotsTab = {x = 400, y = 150};
    isLeverDown = false
    originalY = lever.y
    event.load()
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
end

function createScreen()
    local color = require "src/color"

    color.setRGBA(0, 0, 0)
    love.graphics.setColor(color.getRGBA())
    love.graphics.rectangle("line", 350, 150, 1200, 750)

    color.setRGBA(222, 184, 135)
    love.graphics.setColor(color.getRGBA())
    love.graphics.rectangle("fill", 400, 200, 850, 650)

    color.setRGBA(255, 0, 0)
    love.graphics.setColor(color.getRGBA())
    love.graphics.circle("fill", lever.x, lever.y, radius)

    color.setRGBA(255, 255, 255)
    love.graphics.setColor(color.getRGBA())
    love.graphics.rectangle("fill", slotsTab.x, slotsTab.y, 100, 50)

    color.setRGBA(255, 255, 255)
    love.graphics.setColor(color.getRGBA())
    love.graphics.rectangle("fill", msgTab.x, msgTab.y, 100, 50)
end

function slot()
    love.graphics.print("THE SLOT IS ROLLING", 450, 500)
end

function onLeverClick(x, y)

    -- local slotmachine = require "src/slotmachine"
    -- slotmachine.test_rollSymbols(500)

    mx = (x - screen.offsetX) / screen.scale
    my = (y - screen.offsetY) / screen.scale

    local dx = mx - lever.x
    local dy = my - lever.y
    local distance = math.sqrt(dx * dx + dy * dy)

-- lever onclick
    if distance <= radius and resetTimer <= 0 then
        lever.y = lever.y + 450
        isLeverDown = true
        resetTimer = 1

        event.nextEvent()
    end
end

function leverTimer(dt)
    if resetTimer > 0 then
        resetTimer = resetTimer - dt
    else
        lever.y = originalY
        isLeverDown = false
    end
end
