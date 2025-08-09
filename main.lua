function love.load()
    player = {}
    pc = {}
    love.window.setMode(1920, 1080, {resizable = true})
end

function love.update(dt)
end

function love.draw()
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