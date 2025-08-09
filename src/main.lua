local scale, offsetX, offsetY

function love.load()
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
    updateScale(love.graphics.getDimensions())
    lever = {}
    lever.x = 1420
    lever.y = 280
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
    love.graphics.pop()
end

function love.update(dt)
     if love.mouse.isDown(1) then
        lever.y = lever.y + 5
     end
end

function createScreen()

    local color = require "color"

    color.setRGBA(0, 0, 0, 1)
    love.graphics.setColor(color.getRGBA())
    love.graphics.rectangle("line", 350, 150, 1200, 750)

    color.setRGBA(157, 95, 70)
    love.graphics.setColor(color.getRGBA())
    love.graphics.rectangle("fill", 400, 200, 850, 650)

    local radius = 80

    color.setRGBA(255, 0, 0)
    love.graphics.setColor(color.getRGBA())
    love.graphics.circle("fill", lever.x, lever.y, radius)
end

function getMouse()

end
