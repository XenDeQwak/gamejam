local color = {
    RED = 0,
    GREEN = 0,
    BLUE = 0,
    ALPHA = 1
}

function color.setRGBA(red, green, blue, alpha)
    color.RED   = red
    color.GREEN = green
    color.BLUE  = blue
    color.ALPHA = alpha or 1
end

function color.getRGBA()
    return love.math.colorFromBytes(color.RED, color.GREEN, color.BLUE)
end

return color
