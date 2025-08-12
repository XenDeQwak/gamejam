local Gspot = require "src.lib.Gspot"

local UI = {}
UI.__index = UI

function UI:new()
    local ui = setmetatable({}, self)
    ui.g = Gspot()
    return ui
end

function UI:createButton(label, xCoord, yCoord, btnWidth, btnHeight, onClick)
    local btn = self.g:button(label, {x = xCoord, y = yCoord, w = btnWidth, h = btnHeight})

    -- if imgPath then
    --     local img = love.graphics.newImage(imgPath)
    --     btn.draw = function(self)
    --         love.graphics.setColor(1, 1, 1, 1)
    --         love.graphics.draw(img, self.pos.x, self.pos.y, 0, w / img:getWidth(), h / img:getHeight())
    --         love.graphics.setColor(0, 0, 0, 1)
    --         love.graphics.print(self.label, self.pos.x + 5, self.pos.y + 5)
    --     end
    -- end
    btn.click = function(this, x, y)
        if onClick then
            onClick(this, x, y)
        end
    end
    return btn
end

function UI:removeButton(button)
    self.g:rem(button)
end

function UI:update(dt)
    self.g:update(dt)
end

function UI:draw()
    self.g:draw()
end

function UI:mousepressed(x, y, button)
    self.g:mousepress(x, y, button)
end

function UI:mousereleased(x, y, button)
    self.g:mouserelease(x, y, button)
end

function UI:keypressed(key)
    self.g:keypress(key)
end

function UI:textinput(text)
    self.g:textinput(text)
end

return UI
