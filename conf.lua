function love.conf(t)
    _G.baseW = 1920 * 0.8
    _G.baseH = 1080 * 0.8
    t.window.title = "Project Loop"
    t.window.fullscreen = false
    t.window.fullscreentype = "exclusive"
    t.window.resizable = true
end
