local event = {
    isBroke=false,
    hasDebt=false,
    familyAnger=0,
    debt=0,
    availableEvents={}
}

function isBrokeFunc()
    return event.isBroke
end

function hasDebtFunc()
    return event.hasDebt
end


local allEvents = {
    {
        name = "Broke",
        condition = isBrokeFunc,
        action = outOfMoney,
        cooldown = 0
    },
    {
        -- TODO: Say NO, cooldown == 3
        name = "Debt",
        condition = hasDebtFunc,
        action = mafiaDebt,
        cooldown = 0
    }
}

function event.nextEvent()
    for index,event in ipairs(availableEvents()) do
        print(event.name)
    end
    local available = availableEvents()
    if #available == 0 then
        return nil
    end
    local choice = available[math.random(#available)]
    return choice
end

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

function outOfMoney()
    love.graphics.print("OUT OF MONEY", 450, 500)
    -- Popup, GO TO MAFIA or SELL HOUSE

end

function mafiaDebt()
    love.graphics.print("SOMEONE IS AT THE DOOR", 450, 500)
    -- if choice no, cooldown 3
    -- if choice yes, money== money-debt, hasDebt=false
end 

return event 
