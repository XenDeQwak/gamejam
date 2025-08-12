local notifSprite
local event = {
    isBroke=true,
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
   
    --this is just a grey overlay bg thing, only way i could get it to work for some reason
    love.graphics.push()
    love.graphics.origin()
    love.graphics.setColor(0,0,0,0.5)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.pop()

    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(notifSprite,575,350,0,0.4,0.4)

    love.graphics.setColor(color.setRGBA(0,0,0))
    local messageHeight = 352
    local messageStart = 300
    local messageY = (messageHeight*0.5)+messageStart
    local maxWidth=350
    love.graphics.printf(event.message,900,messageY,maxWidth,"center")

end

local familyActions ={
    [0] = function()
    notifSprite = love.graphics.newImage("assets/ui/daughter1.png")
    event.message=("Dad, let's go to the park!")
    --if yes, familyAnger = 0
    --if no, familyAnger++
    end,

    [1] = function ()
    notifSprite = love.graphics.newImage("assets/ui/daughter1.png")
    event.message=("Honey, we didn't get to celebrate Olivia's birthday. Make it up to her.")

    --if "Plan Party"
        --if money<1000
            --love.graphics.print(Not Enough Money)
        --else
            --familyAnger = 0
            --money-=1000
    --if "No"
        --familyAnger++

    end,

    [2] = function ()
    notifSprite = love.graphics.newImage("assets/ui/daughter1.png")
    event.message=("Dad, is that more important than me?")

    --if "Yes" 
        --familyAnger++
    --if "Buy Gifts"
        --if money<3000,
            --love.graphics.print(Not Enough Money)
        --else
            --familyAnger = 0
            --money -= -3000

    end,

    [3] = function ()
    notifSprite = love.graphics.newImage("assets/ui/daughter1.png")
    event.message=("This isn't good for Olivia, I am thinking about leaving...")

    --if "whatever..", 
        --hasFamily = false
        --notifSprite = divorce popup
        --event.message=("Your family has left")

    --if "Make-Up with Family" 
        --if money<5000, 
            --love.graphics.print(Not Enough Money)
        --else
            --money -= 5000
            --familyAnger = 2

    end
}

local function mafiaDebt()
    print("MAFIA DEBT")
    notifSprite = love.graphics.newImage("assets/ui/daughter1.png")
    event.message=("We've come to collect")

    -- if "Give me time"
        --if mafiaWait == 3
            --gunCock, death
        --mafiaWait++
    -- elseif choice "Pay"
        --money = money-debt*1.1
        --hasDebt=false

end 

local function outOfMoney()
    print("OUT OF MONEY")
    notifSprite = love.graphics.newImage("assets/ui/daughter1.png")
    event.message=("You are out of money")

    -- Popup, GO TO MAFIA or SELL HOUSE
    --if SELL HOUSE
        --isBroke = false
        --money+=10000
        --hasFamily = false, 
        --notifSprite = divorce popup
        --event.message=("Your family has left")
    --elseif MAFIA
        --isBroke = false
        --hasDebt = true
        --money+=3000,
        --notifSprite = mafia popup
        --event.message=(We will come to collect")
end

local allEvents = { --this is prioritized based on sequence (broke will occur first if available)
    {
        name = "Broke",
        condition = function() return event.isBroke end,
        action = outOfMoney,
        cooldown = 0
    },
    {
        name = "Debt",
        condition = function() return event.hasDebt end,
        action = mafiaDebt,
        cooldown = 0
    },
    {
        name = "Family",
        condition = function() return event.hasFamily end,
        action = function() familyActions[event.familyAnger]() end,
        cooldown=0
    }
}

function event.nextEvent()
    local triggered=nil

    for index,events in ipairs(allEvents) do
        print(events.name)
    end

    for index,events in ipairs(allEvents) do
        if events.cooldown > 0 then
            events.cooldown = events.cooldown - 1
        elseif not triggered and events.condition() then
            events.action()
            events.cooldown = 3
            triggered=true
        end
    end
end

return event 
