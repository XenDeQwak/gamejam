local notifSprite
local event = {
    isBroke=false,
    hasDebt=false,
    hasFamily=true,
    familyAnger=0,
    debt=0,
    availableEvents={},
    message=nil
}
local color = require "src/color"


function event.load()

end
function event.draw()

    love.graphics.draw(notifSprite,575,350,0,0.4,0.4)

    -- love.graphics.setColor(color.setRGBA(255,0,0))
    -- love.graphics.rectangle("fill",1000,396,100,351)

    love.graphics.setColor(color.setRGBA(0,0,0))
    
    local boxheight = 351
    local boxStart = 396
    local messageY = (boxheight*0.3)+boxStart
    local maxWidth=350


    love.graphics.printf(event.message,900,messageY,maxWidth,"center")
end

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

function family()
    print("FAMILY HANGOUT")
    notifSprite = love.graphics.newImage("assets/ui/daughter1.png")
    event.message=("Dad, let's go to the park!")
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
    },
    {
        name = "Family",
        condition = function() return event.hasFamily end,
        action = family,
        cooldown=0
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
