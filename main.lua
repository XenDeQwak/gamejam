local radius = 48
local resetTimer = -1
local event = require "src.event"
local slotmachine = require "src.slotmachine"
local color = require "src.color"
local buttonMaker = require "src.buttonmaker"
local money = require "src.money"
local bm = buttonMaker:new()
local image = {}
local spins = 0;
local isSpinning = false
local eventsTriggered = true

-- Reels
local slotSymbols = {
    ["SEVEN"] = "assets/symbols/slot-symbol1.png",
    ["CHERRY"] = "assets/symbols/slot-symbol2.png",
    ["BELL"] = "assets/symbols/slot-symbol3.png",
    ["BAR"] = "assets/symbols/slot-symbol4.png",
    ["ORANGE"] = "assets/symbols/slot-symbol5.png"
}

local slotmachineReels = slotmachine.getReels()
local reelSymbols = {
    {}, {}, {}
}
for r = 1, 3 do
    for i = 1, 5 do
        reelSymbols[r][i] = love.graphics.newImage(slotSymbols[slotmachineReels[r][i]])
    end
end

local reelsSpins        = 45
local remainingSpins    = {0,0,0}
local currentIndices    = {1, 1, 1}
local offsets           = {0, 0, 0}

local function drawReels(reelIndices)

    local x         = {524+20, 717+20, 912+20}
    local initialY  = 110
    local ySpacing  = 180
    local rotation  = 0

    -- To make it show in the middle of the reel
    local reelIndexOffset = -2

    for reel=1, 3 do
        for i=1, #reelSymbols[reel] do
            local index = (reelIndices[reel] + i - 2 + reelIndexOffset) % #reelSymbols[1] + 1
            local newY = initialY + ((i - 1) * ySpacing + offsets[reel] % (ySpacing * 5)) % (ySpacing * 5)
            if not (newY <= 190 or newY >= 710) then
                love.graphics.draw(reelSymbols[reel][index], x[reel], newY, rotation)
            end
        end
    end

end

function love.load()
    print("Game started!")
    love.window.setMode(1920, 1080, {fullscreen = true, fullscreentype = "exclusive"})
    love.graphics.setFont(love.graphics.newFont(32))

    image.background = love.graphics.newImage("assets/ui/background.png")
    image.slots = love.graphics.newImage("assets/Slot Machine/slot_machine.png")
    image.lever_default = love.graphics.newImage("assets/lever/slot_lever_default.png")
    image.lever_active = love.graphics.newImage("assets/lever/slot_lever_active.png")
    image.lever = image.lever_default

    lever = {x = 1290, y = 350}

    function AddButton(label, xCoord, yCoord, width, height, onClick, fontSize)
        btn = bm:createButton(label, xCoord, yCoord, width, height, onClick)
        if fontSize then
            btn.style.font = love.graphics.newFont(fontSize)
        end
        return btn
    end

    function RemoveButton(btn)
        bm:removeButton(btn)
    end
    event.load()
end

function love.draw()

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(image.background, 0, 0, 0)

    drawReels(currentIndices)
    createScreen()

    if event.message then
        event.draw()
    end
    bm:draw()

    local text = "$$$: " .. tostring(money.AMOUNT)
    local x, y = 50, 50
    love.graphics.print(text, x, y)
end

function love.update(dt)
    spinningReels(dt)
    bm:update(dt)
    leverTimer(dt)
end

function love.mousepressed(x, y, button)
    if button == 1 then
        local hasNoEvent = not event.message
        local hasEnoughMoney = money.AMOUNT >= 100
        local isNotSpinning = not isSpinning
        if hasNoEvent and hasEnoughMoney and isNotSpinning then
            onLeverClick(x, y)
        end
    end
    bm:mousepressed(x, y, button)
end

function createScreen()
    love.graphics.setColor(color.setRGBA(0, 0, 0))
    love.graphics.rectangle("line", 350, 150, 1200, 750)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(image.slots, 400, 175)
    love.graphics.draw(image.lever, lever.x, lever.y,0,2,2)

    -- love.graphics.circle("fill",lever.x+103,lever.y+65,radius)
end


function onLeverClick(x, y)
    local leverActualX = lever.x+103
    local leverActualY = lever.y+65
    local dx = x - leverActualX
    local dy = y - leverActualY
    local distance = math.sqrt(dx * dx + dy * dy)

    if distance <= radius and resetTimer <= 0 then

        startSpin()

        resetTimer = 1.25
        image.lever = image.lever_active
        lever.y = lever.y + 70
    end
end

function leverTimer(dt)
    if resetTimer > 0 then
        resetTimer = resetTimer - dt
    elseif resetTimer > -1 then
        image.lever = image.lever_default
        lever.y = lever.y - 70
        resetTimer = -1
    end
end

function startSpin()
    eventsTriggered = false

    money:subtract(100)
    local result = slotmachine.spin(spins)
    spins = spins + 1
    currentIndices = result[1]
    local isWin = result[2]
    remainingSpins = {
        reelsSpins * math.random(3, 5),
        reelsSpins * math.random(5, 7),
        reelsSpins * math.random(10, 12)
    }
    local reward = require "src.reward"
    local rewardMoney = function ()
        if isWin then
            local prizeMoney = 300
            money:add(prizeMoney)
        end
    end
    reward:setReward(rewardMoney)
    slotmachine.rewardAction = reward
    isSpinning = true
end

function spinningReels(dt)
    local offset = 20
    local notSpinning = true

    for i = 1, 3 do
        if remainingSpins[i] > 0 then
            notSpinning = false
            remainingSpins[i] = remainingSpins[i] - 1
            offsets[i] = offsets[i] + offset
        end
    end

    if notSpinning and not eventsTriggered then
        isSpinning = false
        eventsTriggered = true
        triggerEvents()
    end
end

function triggerEvents()
    if slotmachine.rewardAction then
        slotmachine.rewardAction:grantReward()
    end
    
    -- others
    event.nextEvent()
end