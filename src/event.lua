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
    love.graphics.setFont(love.graphics.newFont(40))
end

function event.draw()
    love.graphics.draw(notifSprite,575,300,0,0.4,0.4)

    love.graphics.setColor(color.setRGBA(255,0,0))
    -- love.graphics.rectangle("fill",1000,,100,1200)

    love.graphics.setColor(color.setRGBA(0,0,0))
    
    local boxheight = 352
    local boxStart = 300
    local messageY = (boxheight*0.5)+boxStart
    local maxWidth=350

    love.graphics.printf(event.message,900,messageY,maxWidth,"center")
end

function outOfMoney()
    print("OUT OF MONEY")
    event.message="OUT OF MONEY"
    event.popupTimer=3
    -- Popup, GO TO MAFIA or SELL HOUSE

end

local familyActions ={
    [0] = function()
    notifSprite = love.graphics.newImage("assets/ui/daughter1.png")
    event.message=("Dad, let's go to the park!")
    end,

    [1] = function ()

    end,

    [2] = function ()

    end,

    [3] = function ()

    end
}

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
        action = familyActions[event.familyAnger],
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
