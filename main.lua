local scale, offsetX, offsetY

function love.load()
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
    updateScale(love.graphics.getDimensions())
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

function createScreen()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", 350, 150, 1200, 750)

    love.graphics.setColor(157/255, 95/255, 70/255)
    love.graphics.rectangle("fill", 400, 200, 850, 650)

    local r = 80
    local cx = 300 + 1200 - r 
    local cy = 200 + r        

    love.graphics.setColor(255, 0, 0) 
    love.graphics.circle("fill", cx, cy, r)
end
