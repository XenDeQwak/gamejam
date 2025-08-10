local scale, offsetX, offsetY, isLeverDown, originalY
local radius = 80
local resetTimer = 0
local event = require "event"

function love.load()

    print("Game started!")
    
    love.window.setMode(1280,720,{resizable=true})
    love.graphics.setFont(love.graphics.newFont(32))
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)

    updateScale(love.graphics.getDimensions())
    lever = {x = 1420, y = 280}
    msgTab = {x = 510, y = 150};
    slotsTab = {x = 400, y = 150};
    isLeverDown = false
    originalY = lever.y
end

function love.draw()
    love.graphics.push()
    love.graphics.translate(offsetX, offsetY)
    love.graphics.scale(scale)
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
    event.update(dt)
end

function love.resize(w, h)
    updateScale(w, h)
end

function updateScale(w, h)
    scale = math.min(w / baseW, h / baseH)
    offsetX = (w - baseW * scale) / 2
    offsetY = (h - baseH * scale) / 2
end

function love.mousepressed(x, y, button)
    if button == 1 then
        onLeverClick(x, y)
    end
end

function createScreen()
    local color = require "color"

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

    local slotmachine = require "slotmachine"

    slotmachine.spin()

    mx = (x - offsetX) / scale
    my = (y - offsetY) / scale

    local dx = mx - lever.x
    local dy = my - lever.y
    local distance = math.sqrt(dx * dx + dy * dy)

    if distance <= radius and resetTimer <= 0 then
        lever.y = lever.y + 450
        isLeverDown = true
        resetTimer = 1
        local event = require("event")
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
