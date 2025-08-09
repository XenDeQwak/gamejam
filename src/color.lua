local color = {
    RED = 0,
    GREEN = 0,
    BLUE = 0,
    ALPHA = 1
}

color.setRGBA = function (red, green, blue, alpha)
    color.RED   = red
    color.GREEN = green
    color.BLUE  = blue
    color.ALPHA = alpha or 1
end

color.getRGBA = function ()
    return {color.RED, color.GREEN, color.BLUE, color.ALPHA}
end

return color
