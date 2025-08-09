local scale, offsetX, offsetY, isLeverDown, originalY
local radius = 80
local resetTimer = 0  

function love.load()
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
    updateScale(love.graphics.getDimensions())
    lever = {x = 1420, y = 280}
    isLeverDown = false
    originalY = lever.y
end

function love.resize(w, h)
    updateScale(w, h)
end

function updateScale(w, h)
    scale = math.min(w / baseW, h / baseH)
    offsetX = (w - baseW * scale) / 2
    offsetY = (h - baseH * scale) / 2
end

function love.draw()
    love.graphics.push()
    love.graphics.translate(offsetX, offsetY)
    love.graphics.scale(scale)
    createScreen()
    if isLeverDown then
        slot()
    end
    love.graphics.pop()
end

function love.update(dt)
    leverTimer(dt)
end

function love.mousepressed(x, y, button)
    if button == 1 then
        onLeverClick(x, y)
    end
end

function createScreen()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", 350, 150, 1200, 750)

    love.graphics.setColor(157/255, 95/255, 70/255)
    love.graphics.rectangle("fill", 400, 200, 850, 650)
   

    love.graphics.setColor(255, 0, 0) 
    love.graphics.circle("fill", lever.x, lever.y, radius)
end

function slot()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(32))
    love.graphics.print("THE SLOT IS ROLLING", 450, 500)
end

function onLeverClick(x, y) 
    mx = (x - offsetX) / scale
    my = (y - offsetY) / scale

    local dx = mx - lever.x
    local dy = my - lever.y
    local distance = math.sqrt(dx * dx + dy * dy)

    if love.mouse.isDown(1) and distance <= radius and resetTimer <= 0 then
        lever.y = lever.y + 450
        isLeverDown = true
        resetTimer = 1
    end
end

function leverTimer(dt)
    if resetTimer > 0 then
        resetTimer = resetTimer - dt
        if resetTimer <= 0 then
            lever.y = originalY
            isLeverDown = false
        end
    end
end
