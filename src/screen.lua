local screen = {}

function screen.updateScale(w, h)
    screen.scale = math.min(w / baseW, h / baseH)
    screen.offsetX = (w - baseW * screen.scale) / 2
    screen.offsetY = (h - baseH * screen.scale) / 2
end
return screen