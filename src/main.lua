function love.load()
    player = {}
    pc = {}
    love.window.setMode(0, 0, {fullscreen = true, fullscreentype = "desktop"})

end

function love.update(dt)
end

function love.draw()
    love.graphics.rectangle("line", 350, 150, 1200, 750)
end