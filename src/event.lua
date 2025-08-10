local event = {
    isBroke=true,
    hasDebt=false,
    familyAnger=0,
    debt=0,
    availableEvents={},
    message=nil,
    popupTimer=0
}
function event.load()
    notifSpriteBase = love.graphics.newImage("assets/ui/notif_box.png")
end
function event.draw()
    love.graphics.draw(notifSpriteBase,450,500)
    love.graphics.print(event.message,450,500)
end

-- function event.update(dt)
--     if event.popupTimer > 0 then
--         event.popupTimer = event.popupTimer - dt
--     else
--         event.message=nil
--     end
-- end

function event.mousepressed(x,y,button)
    if button == 1 then

    end
end

function button(text,func,func_param,width,height)

end

function outOfMoney()
    print("OUT OF MONEY")
    event.message="OUT OF MONEY"
    event.popupTimer=3
    -- Popup, GO TO MAFIA or SELL HOUSE

end

function mafiaDebt()
    print("MAFIA DEBT")
    event.message="MAFIA DEBT"
    event.popupTimer=3
    -- if choice no, cooldown 3
    -- if choice yes, money== money-debt, hasDebt=false
end 

local allEvents = {
    {
        name = "Broke",
        condition = function() return event.isBroke end,
        action = outOfMoney,
        cooldown = 0
    },
    {
        -- TODO: Say NO, cooldown == 3
        name = "Debt",
        condition = function() return event.hasDebt end,
        action = mafiaDebt,
        cooldown = 0
    }
}

function availableEvents()
    local available = {}
    for index,event in ipairs(allEvents) do
        if event.cooldown > 0 then
            event.cooldown = event.cooldown - 1
        elseif event.condition() then
            table.insert(available, event)
        end
    end
    return available
end

function event.nextEvent()
    for index,event in ipairs(availableEvents()) do
        print(event.name)
    end
    local available = availableEvents()
    if #available == 0 then
        return nil
    end
    local choice = available[math.random(#available)]
    choice.action()
end

return event 
