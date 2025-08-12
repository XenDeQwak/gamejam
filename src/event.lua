local notifSprite
local event = {
    isBroke=true,
    hasDebt=false,
    hasHouse=true,
    mafiaWait=0,
    familyAnger=0,
    debt=0,
    availableEvents={},
    message=nil
}
local color = require "src/color"

local btnWidth = 150
local btnHeight = 75
local fontSize = 20
local notEnoughMoney = nil
local moneyStr = nil

function event.load()
    love.graphics.setFont(love.graphics.newFont(40))

end

function event.draw()
   
    love.graphics.setColor(0,0,0,0.5)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())


    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(notifSprite,575,350,0,0.4,0.4)

    love.graphics.setColor(color.setRGBA(0,0,0))
    local messageHeight = 352
    local messageStart = 300
    local messageY = (messageHeight*0.45)+messageStart
    local maxWidth=350
    love.graphics.printf(event.message,900,messageY,maxWidth,"center")

    if(notEnoughMoney) then
        love.graphics.setColor(color.setRGBA(245,245,220))
        love.graphics.rectangle("fill",770,180,380,125)
        love.graphics.setColor(color.setRGBA(255,0,0))
        love.graphics.printf("Not Enough Money: " .. moneyStr,790,200,maxWidth,"center")
    end
end

local familyActions ={
    [0] = function()
        notifSprite = love.graphics.newImage("assets/ui/daughter1.png")
        event.message=("Dad, let's go to the park!")

        eventBtn1 = AddButton("Sure!",875, 650, btnWidth, btnHeight, function() 
            -- if(money<1000) then
                notEnoughMoney=true
                moneyStr="1000"
            -- else
                RemoveButton(eventBtn1)
                RemoveButton(eventBtn2)
                event.message=nil
            -- end
        end,fontSize)

        eventBtn2 = AddButton("I'm Busy", 1075, 650, btnWidth, btnHeight, function() 
            notEnoughMoney=false
            RemoveButton(eventBtn1)
            RemoveButton(eventBtn2)
            event.message=nil
            event.familyAnger=event.familyAnger+1
        end, fontSize)
    end,


    [1] = function ()
        notifSprite = love.graphics.newImage("assets/ui/daughter1.png")
        event.message=("Honey, we didn't celebrate Olivia's birthday. ")
        eventBtn1 = AddButton("Plan Party ",875, 650, btnWidth, btnHeight, function() 
            -- if(money<3000) then
                notEnoughMoney=true
                moneyStr="3000"
            -- else
                RemoveButton(eventBtn1)
                RemoveButton(eventBtn2)
                event.message=nil
                event.familyAnger=0
            -- end
        end,fontSize)

        eventBtn2 = AddButton("I'm Busy", 1075, 650, btnWidth, btnHeight, function()
            notEnoughMoney=false
            RemoveButton(eventBtn1)
            RemoveButton(eventBtn2)
            event.message=nil
            event.familyAnger=event.familyAnger+1
        end, fontSize)
    end,

    [2] = function ()
        notifSprite = love.graphics.newImage("assets/ui/daughter1.png")
        event.message=("Is that game more important than me?")

        eventBtn1 = AddButton("Buy Gifts",875, 650, btnWidth, btnHeight, function() 
            -- if(money<5000) then
                notEnoughMoney=true
                moneyStr="5000"
            -- else
                RemoveButton(eventBtn1)
                RemoveButton(eventBtn2)
                event.message=nil
                event.familyAnger=0
            -- end
        end,fontSize)

        eventBtn2 = AddButton("Yes", 1075, 650, btnWidth, btnHeight, function()
            notEnoughMoney=false
            RemoveButton(eventBtn1)
            RemoveButton(eventBtn2)
            event.message=nil
            event.familyAnger=event.familyAnger+1
        end, fontSize)
    end,

    [3] = function ()
        notifSprite = love.graphics.newImage("assets/ui/daughter1.png")
        event.message=("This isn't good for Olivia. We are leaving.")

        eventBtn1 = AddButton("Make Up with Family", 875, 650, btnWidth, btnHeight, function()
            -- if(money<5000) then
                notEnoughMoney=true
                moneyStr="5000"
            -- else
                RemoveButton(eventBtn1)
                RemoveButton(eventBtn2)
                event.message=nil
                event.familyAnger=2
            -- end
        end, fontSize-7)

        eventBtn2 = AddButton("whatever..",1075, 650, btnWidth, btnHeight, function() 
            notEnoughMoney=false
            -- notifSprite = daughter crashout img
            RemoveButton(eventBtn1)
            RemoveButton(eventBtn2)
            event.familyAnger=event.familyAnger+1

            event.message=("Your family has left you")
            okButton = AddButton("Okay",975,650,btnWidth,btnHeight,function()
                RemoveButton(okButton)
                event.message=nil
            end,fontSize)
        end,fontSize)
    end,

    [4] = function ()
        notifSprite = love.graphics.newImage("assets/ui/daughter1.png")
        event.message=("JUST QUIT THE GAME DAD!!!")
        noBtn = AddButton("NO!!!",975,650,btnWidth,btnHeight,function()
            RemoveButton(noBtn)
            event.message=nil
        end,fontSize)
    end
}

local function mafiaDebt()
    print("MAFIA DEBT")
    notifSprite = love.graphics.newImage("assets/ui/daughter1.png")
    event.message=("We've come to collect.")


    eventBtn1 = AddButton("Pay",1075, 650, btnWidth, btnHeight, function() 
        -- if(money<3300) then
        --     notenoughmoney=true
        --     moneystr="3300"
        -- else
            --money = money-3300
            event.hasDebt=false
        RemoveButton(eventBtn1)
        RemoveButton(eventBtn2)
    end,fontSize)

    eventBtn2 = AddButton("Give me time", 875, 650, btnWidth, btnHeight, function()
        notEnoughMoney=false
        if event.mafiaWait == 3 then
            event.message=("You have been shot by the mafia.\nGame Over.")
        else
            event.mafiaWait = event.mafiaWait+1
            event.message=nil
        end
        RemoveButton(eventBtn1)
        RemoveButton(eventBtn2)
    end, fontSize-3)
end 

local function outOfMoney()
    print("OUT OF MONEY")

    notifSprite = love.graphics.newImage("assets/ui/daughter1.png")
    event.message=("You are out of money")
    if not event.hasDebt then
        eventBtn1 = AddButton("Borrow from Mafia", 875, 650, btnWidth, btnHeight, function()
            -- notifSprite = mafia
            RemoveButton(eventBtn1)
            RemoveButton(eventBtn2)
            event.message=("We Will Collect.\nYou have gained 3000$")
            okButton = AddButton("Great",975,650,btnWidth,btnHeight,function()
                RemoveButton(okButton)
                event.message=nil
            end,fontSize)
            event.hasDebt=true
        end, fontSize-4)
    end

    if event.hasHouse then
        eventBtn2 = AddButton("Sell House",1075, 650, btnWidth, btnHeight, function() 
            -- notifSprite = wife2
            --money=money+10000
            RemoveButton(eventBtn1)
            RemoveButton(eventBtn2)
            event.familyAnger=4
            event.hasHouse=false

            event.message=("Your family has left you.\n You gained 10000$")
            okButton = AddButton("oh",975,650,btnWidth,btnHeight,function()
                RemoveButton(okButton)
                event.message=nil
            end,fontSize)
        end,fontSize)
    end
    if not event.hasHouse and event.hasDebt then
        -- notifSprite
        event.message=("Cannot get any more money\n\nGame Over")
    end

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
        condition = function() return true end,
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
            events.cooldown = 2
            triggered=true
        end
    end
end

return event 
